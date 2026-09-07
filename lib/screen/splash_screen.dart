import 'package:flutter/material.dart';
import 'package:connectcall/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final AnimationController _dotsController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Main controller for entry scaling and fading
    _mainController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Controller for background pulsing ripple circles
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Controller for bottom loading dots
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _mainController.forward();

    // Hold on the splash a beat after the entry animation finishes, then
    // move on. If you want splash to branch to Home when already logged
    // in, dispatch `AuthCheckRequested()` here instead and listen to the
    // AuthBloc status in a BlocListener wrapping this widget.
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF4F46E5), Color(0xFF818CF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Animated Expanding Ripple Circles
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildRippleCircle(
                          radius: 110 + (_pulseController.value * 70),
                          opacity: (1.0 - _pulseController.value) * 0.4,
                        ),
                        _buildRippleCircle(
                          radius: 180 + (_pulseController.value * 85),
                          opacity: (1.0 - _pulseController.value) * 0.25,
                        ),
                        _buildRippleCircle(
                          radius: 250 + (_pulseController.value * 100),
                          opacity: (1.0 - _pulseController.value) * 0.15,
                        ),
                      ],
                    );
                  },
                ),

                // Foreground Content with Custom Icon, Name & Loading Indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom Glassmorphism Callly Logo Container (matches your design asset)
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 35,
                                spreadRadius: 6,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 90,
                              height: 90,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Curved connection arrows indicator behind inner action bubbles
                                  CircularProgressIndicator(
                                    value: 0.75,
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xFF4F46E5).withOpacity(0.4),
                                    ),
                                  ),
                                  // Inner Video & Audio dual mini badges
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF4F46E5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.videocam_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.more_horiz_rounded,
                                        size: 14,
                                        color: Color(0xFF4F46E5),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2563EB),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.phone_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // App Name positioned directly below the logo circle
                        const Text(
                          'Callly',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle Tagline
                        Text(
                          'Voice & Video, closer than ever',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Custom Animated Loading Dots Indicator
                        AnimatedBuilder(
                          animation: _dotsController,
                          builder: (context, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                final double wave =
                                    ((_dotsController.value * 3) - index) % 1.0;
                                final double opacity =
                                    (wave > 0 ? wave : 0.0).clamp(0.2, 1.0);
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(opacity),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // Footer Metadata
                        Text(
                          'v1.0.0 • Made with ❤️',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  // Helper function to render background animated circles
  Widget _buildRippleCircle({required double radius, required double opacity}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity.clamp(0.0, 1.0)),
          width: 1.2,
        ),
      ),
    );
  }
}