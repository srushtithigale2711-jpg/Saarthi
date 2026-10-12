import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_phone_field/country_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newproject/screens/main_navigation_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeToTerms = false;
  bool isLoading = false;

  String? completePhoneNumber;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your full name';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters';
    }

    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter a password';
    }

    if (password.length < 8) {
      return 'Minimum 8 characters required';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Include at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Include at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Include at least one number';
    }

    if (!RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\];`~+=]',
    ).hasMatch(password)) {
      return 'Include at least one special character';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (confirmPassword != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeToTerms) {
      showMessage('Please agree to the terms and conditions.');
      return;
    }

    if (completePhoneNumber == null || completePhoneNumber!.isEmpty) {
      showMessage('Please enter a valid mobile number.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    User? user;

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = completePhoneNumber!;
      final password = passwordController.text;

      // STEP 1: CREATE FIREBASE EMAIL/PASSWORD ACCOUNT
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'account-creation-failed',
          message: 'Unable to create Firebase user.',
        );
      }

      // STEP 2: SEND EMAIL VERIFICATION
      await user.sendEmailVerification();

      // Save the basic profile immediately.
      // NEVER store the password in Firestore.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'emailVerified': false,
        'phoneVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      // STEP 3: WAIT FOR REAL EMAIL VERIFICATION
      final emailVerified = await showEmailVerificationDialog(
        user: user,
        email: email,
      );

      if (!mounted) {
        return;
      }

      if (!emailVerified) {
        // Do NOT delete the account.
        // The user can verify the email and log in later.
        showMessage(
          'Your account is saved. Please verify your email before continuing.',
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'emailVerified': true,
      });

      // STEP 4: PHONE OTP VERIFICATION
      setState(() {
        isLoading = true;
      });

      final phoneVerified = await verifyPhoneNumber(
        user: user,
        phoneNumber: phone,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      if (!phoneVerified) {
        // Do NOT delete the account if phone verification fails.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'emailVerified': true,
          'phoneVerified': false,
        });

        showMessage(
          'Email verified, but mobile verification was not completed. '
          'Your account has been saved.',
        );
        return;
      }

      // STEP 5: SAVE VERIFIED USER DATA
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'emailVerified': true,
        'phoneVerified': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // STEP 6: SUCCESS
      if (!mounted) {
        return;
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Account Created',
                    style: TextStyle(
                      color: Color(0xFF123B65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Your email and mobile number have been verified successfully.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'CONTINUE TO SAARTHI',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Do NOT automatically delete the account here.
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message =
              'An account already exists with this email address. Try logging in.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        case 'network-request-failed':
          message =
              'Network error. Please check your internet connection.';
          break;
        case 'operation-not-allowed':
          message =
              'Email/password authentication is not enabled in Firebase.';
          break;
        case 'credential-already-in-use':
          message =
              'This phone number is already linked to another account.';
          break;
        case 'invalid-verification-code':
          message = 'The OTP is incorrect. Please try again.';
          break;
        case 'invalid-verification-id':
          message =
              'The OTP session has expired. Please request a new OTP.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ??
              'Unable to create your account. Please try again.';
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showMessage(message);
      }
    } catch (e) {
      // Do not delete the Firebase account automatically.
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showMessage(
          'Something went wrong. Your Firebase account has not been deleted. '
          'Please try again.',
        );
      }
    }
  }

  // ============================================================
  // EMAIL VERIFICATION DIALOG
  // ============================================================

  Future<bool> showEmailVerificationDialog({
    required User user,
    required String email,
  }) async {
    bool checking = false;
    String? message;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> checkVerification() async {
              setDialogState(() {
                checking = true;
                message = null;
              });

              try {
                await user.reload();

                final refreshedUser = FirebaseAuth.instance.currentUser;

                if (refreshedUser != null &&
                    refreshedUser.emailVerified) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, true);
                  }
                  return;
                }

                setDialogState(() {
                  checking = false;
                  message =
                      'Email is not verified yet. Open the verification '
                      'email and click the link first.';
                });
              } catch (_) {
                setDialogState(() {
                  checking = false;
                  message =
                      'Could not check verification status. Please try again.';
                });
              }
            }

            Future<void> resendVerification() async {
              try {
                await user.sendEmailVerification();

                setDialogState(() {
                  message =
                      'A new verification email has been sent. '
                      'Please check your inbox and spam folder.';
                });
              } on FirebaseAuthException catch (e) {
                setDialogState(() {
                  message = e.message ??
                      'Unable to resend the verification email.';
                });
              } catch (_) {
                setDialogState(() {
                  message = 'Unable to resend the verification email.';
                });
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    color: Color(0xFF1565C0),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Verify Your Email',
                      style: TextStyle(
                        color: Color(0xFF123B65),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'We sent a verification link to:',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      email,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '1. Open your email inbox.\n'
                      '2. Find the SAARTHI/Firebase verification email.\n'
                      '3. Click the verification link.\n'
                      '4. Come back to SAARTHI.\n'
                      '5. Tap CHECK VERIFICATION.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'If you cannot find the email, check Spam, '
                      'Promotions, and Updates folders.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F7FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF123B65),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: checking ? null : resendVerification,
                  child: const Text(
                    'RESEND EMAIL',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: checking ? null : checkVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: checking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'CHECK VERIFICATION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    return result == true;
  }

  // ============================================================
  // PHONE VERIFICATION
  // ============================================================

  Future<bool> verifyPhoneNumber({
    required User user,
    required String phoneNumber,
  }) async {
    final Completer<bool> completer =
        Completer<bool>();

    bool finished = false;

    Future<void> completeOnce(bool value) async {
      if (finished) {
        return;
      }

      finished = true;

      if (!completer.isCompleted) {
        completer.complete(value);
      }
    }

    // TESTING ONLY:
    // Firebase fictional phone numbers can be tested on Android without
    // sending a real SMS. This disables app verification only in debug
    // builds. Remove this testing setting before a production release.
    if (kDebugMode) {
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      // E.164 number.
      // Example:
      // +919021408390
      phoneNumber: phoneNumber,

      // ========================================================
      // AUTOMATIC VERIFICATION
      // ========================================================

      verificationCompleted:
          (PhoneAuthCredential credential) async {
        try {
          await user.linkWithCredential(
            credential,
          );

          await completeOnce(true);
        } on FirebaseAuthException catch (_) {
          await completeOnce(false);
        } catch (_) {
          await completeOnce(false);
        }
      },

      // ========================================================
      // VERIFICATION FAILED
      // ========================================================

      verificationFailed:
          (FirebaseAuthException e) async {
        if (mounted) {
          showMessage(
            e.message ??
                'Unable to send OTP. Please check your phone number.',
          );
        }

        await completeOnce(false);
      },

      // ========================================================
      // OTP SENT
      // ========================================================

      codeSent: (
        String verificationId,
        int? resendToken,
      ) async {
        final String? otp =
            await showOtpDialog();

        if (otp == null || otp.isEmpty) {
          await completeOnce(false);
          return;
        }

        try {
          final PhoneAuthCredential phoneCredential =
              PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: otp,
          );

          await user.linkWithCredential(
            phoneCredential,
          );

          await completeOnce(true);
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            String message;

            switch (e.code) {
              case 'invalid-verification-code':
                message =
                    'The OTP is incorrect. Please try again.';
                break;

              case 'invalid-verification-id':
                message =
                    'The OTP session has expired.';
                break;

              case 'credential-already-in-use':
                message =
                    'This phone number is already linked to another account.';
                break;

              default:
                message = e.message ??
                    'Phone verification failed.';
            }

            showMessage(message);
          }

          await completeOnce(false);
        } catch (_) {
          await completeOnce(false);
        }
      },

      // ========================================================
      // AUTO RETRIEVAL TIMEOUT
      // ========================================================

      codeAutoRetrievalTimeout:
          (String verificationId) {
        // Manual OTP entry remains available.
      },
    );

    return completer.future;
  }

  // ============================================================
  // OTP DIALOG
  // ============================================================

  Future<String?> showOtpDialog() async {
    final TextEditingController otpController =
        TextEditingController();

    String? errorText;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.sms_outlined,
                    color: Color(0xFF1565C0),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Verify Mobile Number',
                      style: TextStyle(
                        color: Color(0xFF123B65),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter the 6-digit OTP sent to your mobile number.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller:
                        otpController,
                    keyboardType:
                        TextInputType.number,
                    maxLength: 6,
                    autofocus: true,
                    textAlign:
                        TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration:
                        InputDecoration(
                      hintText: '000000',
                      counterText: '',
                      errorText: errorText,
                      filled: true,
                      fillColor:
                          const Color(0xFFF3F7FC),
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide.none,
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            const BorderSide(
                          color:
                              Color(0xFF1976D2),
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (errorText != null) {
                        setDialogState(() {
                          errorText = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final otp =
                        otpController.text.trim();

                    if (otp.length != 6 ||
                        !RegExp(
                          r'^\d{6}$',
                        ).hasMatch(otp)) {
                      setDialogState(() {
                        errorText =
                            'Enter a valid 6-digit OTP';
                      });
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      otp,
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1565C0),
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: const Text(
                    'VERIFY',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    otpController.dispose();

    return result;
  }

  // ============================================================
  // DELETE INCOMPLETE USER
  // ============================================================

  Future<void> _deleteCreatedUser(
    User user,
  ) async {
    try {
      await user.delete();
    } catch (_) {
      // Nothing else to do.
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF1976D2),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor:
          const Color(0xFFF3F7FC),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            BorderSide.none,
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            const BorderSide(
          color: Color(0xFF1976D2),
          width: 2,
        ),
      ),
      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF123B65),
          ),
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF123B65),
            fontWeight:
                FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            28,
            15,
            28,
            35,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // ICON
                // =================================================

                const Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.person_add_alt_1,
                      size: 45,
                      color:
                          Color(0xFF1565C0),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // TITLE
                // =================================================

                const Center(
                  child: Text(
                    'Join SAARTHI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF123B65),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Create your account to start your journey.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // FULL NAME
                // =================================================

                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      nameController,
                  textCapitalization:
                      TextCapitalization
                          .words,
                  validator:
                      validateName,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      inputDecoration(
                    hintText:
                        'Enter your full name',
                    icon:
                        Icons.person_outline,
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // EMAIL
                // =================================================

                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      emailController,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  validator:
                      validateEmail,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      inputDecoration(
                    hintText:
                        'Enter your email',
                    icon:
                        Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // MOBILE NUMBER
                // =================================================

                const Text(
                  'Mobile Number',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 8),

                PhoneNumberField(
                  initialCountry:
                      Countries.india,
                  required: true,
                  validateLength: true,
                  borderType:
                      PhoneFieldBorderType.none,
                  borderRadius: 15,
                  filled: true,
                  fillColor:
                      const Color(0xFFF3F7FC),
                  focusedBorderColor:
                      const Color(0xFF1976D2),
                  errorColor:
                      Colors.red,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  textStyle:
                      const TextStyle(
                    fontSize: 16,
                    color:
                        Color(0xFF123B65),
                  ),
                  cursorColor:
                      const Color(0xFF1976D2),
                  selectorStyle:
                      const CountrySelectorStyle(
                    showFlag: true,
                    showDialCode: true,
                    showIsoCode: false,
                    showDropdownIcon: true,
                    showDivider: true,
                    flagSize: 22,
                  ),
                  pickerConfig:
                      const CountryPickerConfig(
                    type:
                        CountryPickerType.bottomSheet,
                    searchable: true,
                  ),
                  labels:
                      const PhoneFieldLabels(
                    labelText:
                        'Mobile Number',
                    searchHint:
                        'Search country',
                    pickerTitle:
                        'Select Country',
                    requiredError:
                        'Please enter your mobile number',
                  ),
                  onChanged: (phone) {
                    setState(() {
                      completePhoneNumber =
                          phone.completeNumber;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // =================================================
                // PASSWORD
                // =================================================

                const Text(
                  'Password',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      passwordController,
                  obscureText:
                      obscurePassword,
                  validator:
                      validatePassword,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      inputDecoration(
                    hintText:
                        'Create a strong password',
                    icon:
                        Icons.lock_outline,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                        color:
                            Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // CONFIRM PASSWORD
                // =================================================

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      confirmPasswordController,
                  obscureText:
                      obscureConfirmPassword,
                  validator:
                      validateConfirmPassword,
                  textInputAction:
                      TextInputAction.done,
                  decoration:
                      inputDecoration(
                    hintText:
                        'Re-enter your password',
                    icon:
                        Icons.lock_reset_outlined,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword =
                              !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                        color:
                            Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // =================================================
                // TERMS
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value:
                          agreeToTerms,
                      activeColor:
                          const Color(
                        0xFF1565C0,
                      ),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                agreeToTerms =
                                    value ??
                                        false;
                              });
                            },
                    ),
                    const Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(
                          top: 12,
                        ),
                        child: Text(
                          'I agree to the Terms and Conditions and Privacy Policy.',
                          style:
                              TextStyle(
                            fontSize: 13,
                            color:
                                Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =================================================
                // CREATE ACCOUNT BUTTON
                // =================================================

                SizedBox(
                  width:
                      double.infinity,
                  height: 55,
                  child:
                      ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : createAccount,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF1565C0,
                      ),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15,
                        ),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.5,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Text(
                            'CREATE ACCOUNT',
                            style:
                                TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              letterSpacing:
                                  0.8,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // LOGIN LINK
                // =================================================

                Center(
                  child:
                      TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(
                              context,
                            );
                          },
                    child:
                        const Text(
                      'Already have an account? Login',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF1565C0,
                        ),
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}