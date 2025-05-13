import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fe_core_vips/presentation/widgets/widgets.dart';
import '/presentation/feactures/splash/widgets/widgets.dart';
import '/presentation/routes/app_router.dart' show AppRoutes;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final int _splashDuration = 3000; // 3 segundos

  @override
  void initState() {
    super.initState();

    _setupAnimation();
    _initializeApp();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    // Calcula tiempo restante para la duración mínima
    final elapsedTime = DateTime.now().difference(startTime).inMilliseconds;
    final remainingTime = _splashDuration - elapsedTime;

    if (remainingTime > 0) {
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    if (!mounted) return;
    context.goNamed(AppRoutes.auth);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Logo y nombre de la app animados
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const AnimatedLogo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
