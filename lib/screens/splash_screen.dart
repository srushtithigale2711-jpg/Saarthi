import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Floating background animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Soft logo pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _mainController.forward();

    // Navigate to Login
    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF061A40),
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF42A5F5),
            ],
            stops: [0.0, 0.35, 0.70, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative glowing circles
            Positioned(
              top: -100,
              right: -80,
              child: _glowCircle(
                size: 260,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),

            Positioned(
              bottom: -120,
              left: -90,
              child: _glowCircle(
                size: 300,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),

            // Animated travel elements
            AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 110 +
                          math.sin(
                                _floatingController.value * math.pi * 2,
                              ) *
                              12,
                      left: 42,
                      child: Icon(
                        Icons.flight_takeoff_rounded,
                        size: 27,
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),

                    Positioned(
                      top: 190 +
                          math.cos(
                                _floatingController.value * math.pi * 2,
                              ) *
                              10,
                      right: 38,
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 25,
                        color: Colors.white.withValues(alpha: 0.20),
                      ),
                    ),

                    Positioned(
                      bottom: 145 +
                          math.sin(
                                _floatingController.value * math.pi * 2 +
                                    1.5,
                              ) *
                              13,
                      right: 55,
                      child: Icon(
                        Icons.explore_rounded,
                        size: 30,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),

                    Positioned(
                      bottom: 110 +
                          math.cos(
                                _floatingController.value * math.pi * 2 +
                                    1.0,
                              ) *
                              11,
                      left: 48,
                      child: Icon(
                        Icons.photo_camera_rounded,
                        size: 24,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated logo
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final glow =
                                18 + (_pulseController.value * 10);

                            return Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(
                                      alpha: 0.20,
                                    ),
                                    blurRadius: glow + 20,
                                    spreadRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.20,
                                    ),
                                    blurRadius: 25,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF42A5F5),
                                      Color(0xFF0D47A1),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.travel_explore_rounded,
                                  size: 58,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        // App name
                        const Text(
                          'SAFAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 39,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 6,
                            height: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'SAATHI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 39,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 5,
                            height: 1,
                          ),
                        ),

                        const SizedBox(height: 17),

                        // Decorative divider
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.55,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.flight_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 28,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.55,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 17),

                        // Tagline
                        const Text(
                          'Your Smart Travel Companion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Explore • Discover • Experience',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom loading indicator
            Positioned(
              bottom: 55,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Planning your journey...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

