import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({super.key});

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;
  Timer? _returnTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animController, curve: const Interval(0.3, 1.0)),
    );
    _animController.forward();

    // Auto return to welcome after 15 seconds
    _returnTimer = Timer(const Duration(seconds: 15), () {
      Get.offAllNamed(AppRoutes.dashboard);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _returnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Generate random order number for demo
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnim.value,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success icon
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.accent.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5),
                            ],
                          ),
                          child: Icon(Icons.check_rounded,
                              color: Colors.white,
                              size: size.width * 0.18),
                        ),
                        SizedBox(height: size.height * 0.04),

                        Text('Order Confirmed!',
                            style: TextStyle(
                                fontSize: size.width * 0.07,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height * 0.02),

                        Text('Your order number is',
                            style: TextStyle(
                                fontSize: size.width * 0.038,
                                color: Colors.grey.shade600)),
                        SizedBox(height: size.height * 0.01),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: size.height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                            Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(orderNumber,
                              style: TextStyle(
                                  fontSize: size.width * 0.08,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                  color: AppColors.primary)),
                        ),
                        SizedBox(height: size.height * 0.04),

                        Text(
                            'Please wait at the counter.\nYour order will be ready shortly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.width * 0.035,
                                color: Colors.grey.shade600,
                                height: 1.5)),
                        SizedBox(height: size.height * 0.04),

                        Text('This screen will return to the menu automatically.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.width * 0.028,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}