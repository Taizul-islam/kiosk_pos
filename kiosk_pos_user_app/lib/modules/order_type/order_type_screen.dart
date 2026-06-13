import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../config/theme.dart';

class OrderTypeScreen extends StatefulWidget {
  const OrderTypeScreen({super.key});

  @override
  State<OrderTypeScreen> createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..forward();
    _slideAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _slideController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _slideController, curve: const Interval(0.3, 1.0)));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _selectType(String type) {
    setState(() => _selectedType = type);
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.toNamed(AppRoutes.menuCategories, arguments: {'orderType': type}); // CHANGED
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Static text
            Text('Where are you\neating today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2)),

            SizedBox(height: size.height * 0.06),

            // ============ TWO BUTTONS IN A ROW - SLIDES FROM LEFT ============
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionButton(
                        size,
                        Icons.restaurant_rounded,
                        'EAT IN',
                        'eat_in',
                        AppColors.primary),
                    SizedBox(width: size.width * 0.04),
                    _buildOptionButton(
                        size,
                        Icons.shopping_bag_rounded,
                        'TAKE AWAY',
                        'take_away',
                        const Color(0xFF6C5CE7)),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Back button
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_rounded,
                  size: size.width * 0.04),
              label: Text('Back',
                  style: TextStyle(fontSize: size.width * 0.035)),
            ),

            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      Size size, IconData icon, String title, String type, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => _selectType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width * 0.38,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.03, horizontal: size.width * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4))
          ]
              : [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.12,
              height: size.width * 0.12,
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(icon,
                  size: size.width * 0.06,
                  color: isSelected ? Colors.white : color),
            ),
            SizedBox(height: size.height * 0.02),
            Text(title,
                style: TextStyle(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}