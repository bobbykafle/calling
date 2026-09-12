import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_responsive.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeIn,
      ),
    );

    _mainController.forward();

    // Minimum time the splash stays visible, so it doesn't flash
    // even if the auth check resolves instantly.
    _minSplashTime = Future.delayed(const Duration(milliseconds: 3000));

    // Ask AuthBloc to check if a user is already logged in
    // (this reads _authRepository.currentUser under the hood).
    context.read<AuthBloc>().add(const AuthCheckRequested());
  }

  late final Future<void> _minSplashTime;

  Future<void> _navigateOnAuthResult(AuthStatus status) async {
    await _minSplashTime;
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      status == AuthStatus.authenticated
          ? AppRoutes.home
          : AppRoutes.login,
    );
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
    AppResponsive.init(context);
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == AuthStatus.authenticated ||
              current.status == AuthStatus.unauthenticated),
      listener: (context, state) {
        _navigateOnAuthResult(state.status);
      },
      child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryBlue,
              context.offWhite,
              context.lightBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO WITH RIPPLE WRAPPED AROUND IT ONLY
                    SizedBox(
                      width: 340,
                      height: 340,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // RIPPLE EFFECT (confined to logo area)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  _buildRippleCircle(
                                    radius: 115 +
                                        (_pulseController.value * 20),
                                    opacity:
                                        (1.0 - _pulseController.value) *
                                            0.35,
                                  ),
                                  _buildRippleCircle(
                                    radius: 130 +
                                        (_pulseController.value * 30),
                                    opacity:
                                        (1.0 - _pulseController.value) *
                                            0.22,
                                  ),
                                  _buildRippleCircle(
                                    radius: 145 +
                                        (_pulseController.value * 40),
                                    opacity:
                                        (1.0 - _pulseController.value) *
                                            0.12,
                                  ),
                                ],
                              );
                            },
                          ),

                          // CALLLY LOGO IMAGE
                          Container(
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      context.black.withOpacity(0.20),
                                  blurRadius: 35,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/splash.png',
                                width: 230,
                                height: 230,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // APP NAME
                    Text(
                      'Callly',
                      style: context.labelMB,
                    ),

                    const VSpace(1),

                    // SUBTITLE
                    Text(
                      'Voice & Video, closer than ever',
                      style: context.labelMB,
                    ),

                    const SizedBox(height: 32),

                    // LOADING DOTS
                    AnimatedBuilder(
                      animation: _dotsController,
                      builder: (context, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (index) {
                              final double wave =
                                  ((_dotsController.value * 3) - index) %
                                      1.0;

                              final double opacity =
                                  (wave > 0 ? wave : 0.0).clamp(0.2, 1.0);

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      context.white.withOpacity(opacity),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // VERSION / FOOTER
                    Text(
                      'v1.0.0 • Made with ❤️',
                      style: context.labelMB,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  // RIPPLE CIRCLE
  Widget _buildRippleCircle({
    required double radius,
    required double opacity,
  }) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.white.withOpacity(
            opacity.clamp(0.0, 1.0),
          ),
          width: 1.2,
        ),
      ),
    );
  }
}