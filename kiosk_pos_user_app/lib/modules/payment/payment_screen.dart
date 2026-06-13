import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import '../../utils/formatters.dart';
import '../menu/menu_controller.dart';
import 'payment_controller.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..forward();
    _slideAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuController = Get.find<MenuController>();
    final paymentController = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(size),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    Text('Select Payment Type',
                        style: TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    SizedBox(height: size.height * 0.04),

                    // ============ CARD PAYMENT ============
                    _buildPaymentOption(
                      size: size,
                      icon: Icons.credit_card_rounded,
                      title: 'Credit or Debit Card',
                      subtitle: 'Pay at the CUB terminal, then staff confirms',
                      method: 'card',
                      color: AppColors.primary,
                      paymentController: paymentController,
                    ),
                    SizedBox(height: size.height * 0.02),

                    // ============ CASH PAYMENT ============
                    _buildPaymentOption(
                      size: size,
                      icon: Icons.money_rounded,
                      title: 'Cash',
                      subtitle: 'Pay at the counter, then staff confirms',
                      method: 'cash',
                      color: AppColors.accent,
                      paymentController: paymentController,
                    ),
                    SizedBox(height: size.height * 0.02),

                    // ============ MEMBERSHIP CARD ============
                    _buildPaymentOption(
                      size: size,
                      icon: Icons.card_membership_rounded,
                      title: 'Membership Card',
                      subtitle: 'Tap your card on the reader',
                      method: 'member',
                      color: const Color(0xFF6C5CE7),
                      paymentController: paymentController,
                    ),

                    SizedBox(height: size.height * 0.04),
                    _buildAmountDisplay(size, menuController),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(size, paymentController),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(Size size) {
    return Container(
      height: size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2))
      ]),
      child: Row(children: [
        GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                size: size.width * 0.045, color: AppColors.textPrimary)),
        SizedBox(width: size.width * 0.03),
        Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Icon(Icons.restaurant_rounded,
                    color: Colors.white, size: size.width * 0.045))),
        SizedBox(width: size.width * 0.03),
        Text('BURGER HOUSE',
            style: TextStyle(
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1)),
      ]),
    );
  }

  Widget _buildPaymentOption({
    required Size size,
    required IconData icon,
    required String title,
    required String subtitle,
    required String method,
    required Color color,
    required PaymentController paymentController,
  }) {
    return GestureDetector(
      onTap: () => paymentController.selectMethod(method),
      child: Obx(() {
        final isSelected = paymentController.selectedMethod.value == method;
        return Container(
          width: size.width * 0.85,
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.025, horizontal: size.width * 0.05),
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
          child: Row(children: [
            Container(
              width: size.width * 0.13,
              height: size.width * 0.13,
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(icon,
                  size: size.width * 0.065,
                  color: isSelected ? Colors.white : color),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: size.width * 0.038,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary)),
                    SizedBox(height: size.height * 0.004),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade500)),
                  ]),
            ),
            Container(
              width: size.width * 0.055,
              height: size.width * 0.055,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade300,
                      width: 2)),
              child: isSelected
                  ? Center(
                  child: Container(
                      width: size.width * 0.028,
                      height: size.width * 0.028,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle)))
                  : null,
            ),
          ]),
        );
      }),
    );
  }

  Widget _buildAmountDisplay(Size size, MenuController mc) {
    return Obx(() {
      return Container(
        width: size.width * 0.85,
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount to Pay',
                  style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey.shade600)),
              Text(Formatters.currency(mc.cartTotal),
                  style: TextStyle(
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ]),
      );
    });
  }

  Widget _buildBottomButtons(Size size, PaymentController pc) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3))
      ]),
      child: SafeArea(
        child: Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, size.height * 0.065),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text('BACK',
                  style: TextStyle(
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600)),
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Obx(() {
                final isSelected = pc.selectedMethod.isNotEmpty;
                return ElevatedButton(
                  onPressed: isSelected
                      ? () {
                    // Different flow based on payment method
                    if (pc.selectedMethod.value == 'cash') {
                      // Cash: skip card reader, go straight to staff PIN
                      Get.toNamed(AppRoutes.staffPin);
                    } else {
                      // Card & Member: go to card reader screen
                      Get.toNamed(AppRoutes.cardReader);
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isSelected ? AppColors.accent : Colors.grey.shade300,
                    minimumSize: Size(double.infinity, size.height * 0.065),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('PROCEED TO PAY',
                      style: TextStyle(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}