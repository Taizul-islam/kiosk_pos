import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../config/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1080',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                ),
              ),
            ),
          ),
          // Blur + dark overlay
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  Container(
                    width: size.width * 0.22,
                    height: size.width * 0.22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.restaurant_rounded,
                          size: size.width * 0.12, color: AppColors.primary),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Text('ORDER & PAY HERE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.width * 0.09,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.1)),
                  SizedBox(height: size.height * 0.015),
                  Text('FAST AND EASY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 4)),
                  SizedBox(height: size.height * 0.05),
                  // Card icons
                  _buildCardIcons(size),
                  const Spacer(flex: 2),
                  // Touch to Start
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.orderType),
                        child: Container(
                          width: size.width * 0.7,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryDark]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.touch_app_rounded,
                                  color: Colors.white, size: size.width * 0.07),
                              SizedBox(width: size.width * 0.03),
                              Text('TOUCH TO START',
                                  style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Text('SELF-SERVICE KIOSK',
                      style: TextStyle(
                          fontSize: size.width * 0.025,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 4)),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardIcons(Size size) {
    final cardSize = size.width * 0.12;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: cardSize, height: cardSize * 0.65,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Center(child: Text('VISA', style: TextStyle(fontSize: cardSize * 0.22, fontWeight: FontWeight.w900, color: const Color(0xFF1A1F71), letterSpacing: 1))),
        ),
        SizedBox(width: size.width * 0.04),
        Container(
          width: cardSize, height: cardSize * 0.65,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: cardSize * 0.28, height: cardSize * 0.28, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
            Transform.translate(offset: const Offset(-6, 0), child: Container(width: cardSize * 0.28, height: cardSize * 0.28, decoration: const BoxDecoration(color: Color(0xFFF79E1B), shape: BoxShape.circle))),
          ]),
        ),
        SizedBox(width: size.width * 0.04),
        Container(
          width: cardSize, height: cardSize * 0.65,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Center(child: Icon(Icons.credit_card_rounded, size: cardSize * 0.4, color: const Color(0xFF2E77D0))),
        ),
      ],
    );
  }
}