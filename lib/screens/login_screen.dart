import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // =================================================
              // SAARTHI HEADER
              // =================================================

              Container(
                width: double.infinity,
                height: 285,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.travel_explore,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'SAARTHI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Your Smart Travel Companion',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // =================================================
              // LOGIN FORM
              // =================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123B65),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Sign in to continue your journey with Saarthi.',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF123B65),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF1976D2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F7FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFF1976D2),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF123B65),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1976D2),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F7FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showMessage(
                            context,
                            'Password recovery will be available soon.',
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          showMessage(
                            context,
                            'Account registration will be available soon.',
                          );
                        },
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Center(
                      child: Text(
                        'Explore • Discover • Experience',
                        style: TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
