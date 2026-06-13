import 'dart:async';
import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import '../../utils/formatters.dart';
import '../menu/menu_controller.dart';

enum PaymentStatus { started, reading, processing, approved, declined }

class CardReaderScreen extends StatefulWidget {
  const CardReaderScreen({super.key});

  @override
  State<CardReaderScreen> createState() => _CardReaderScreenState();
}

class _CardReaderScreenState extends State<CardReaderScreen>
    with TickerProviderStateMixin {
  PaymentStatus _status = PaymentStatus.started;
  int _readingDots = 0;
  Timer? _simulationTimer;
  Timer? _dotsTimer;

  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late AnimationController _processingController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSimulation();
  }

  void _initAnimations() {
    _arrowController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..repeat(reverse: true);
    _arrowAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut));

    _pulseController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _shimmerController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.linear));

    _processingController = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat();
  }

  void _startSimulation() {
    _simulationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _status = PaymentStatus.reading);
      _startDots();

      _simulationTimer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        _stopDots();
        setState(() => _status = PaymentStatus.processing);

        _simulationTimer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() => _status = PaymentStatus.approved);
          _printReceipt();

          _simulationTimer = Timer(const Duration(seconds: 2), () {
            if (!mounted) return;
            Get.toNamed(AppRoutes.staffPin);
          });
        });
      });
    });
  }

  void _startDots() {
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() => _readingDots = (_readingDots + 1) % 4);
    });
  }

  void _stopDots() => _dotsTimer?.cancel();

  void _printReceipt() {
    Get.snackbar('🖨️ Receipt Printing', 'Your receipt is being printed...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _processingController.dispose();
    _simulationTimer?.cancel();
    _dotsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuController = Get.find<MenuController>();

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
                    SizedBox(height: size.height * 0.02),
                    _buildInstructionText(size),
                    SizedBox(height: size.height * 0.03),
                    _buildAmountDisplay(size, menuController),
                    SizedBox(height: size.height * 0.03),
                    _buildCardReaderScreen(size),
                    SizedBox(height: size.height * 0.03),
                    _buildStatusBadge(size),
                    SizedBox(height: size.height * 0.02),
                    if (_status == PaymentStatus.started) _buildAnimatedArrow(size),
                    if (_status == PaymentStatus.processing) _buildProcessingAnimation(size),
                    if (_status == PaymentStatus.approved) _buildApprovedCheck(size),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
            _buildHardwareIndicator(size),
            if (_status != PaymentStatus.approved) _buildCancelButton(size),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(Size size) {
    return Container(
      height: size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]),
      child: Row(children: [
        if (_status != PaymentStatus.approved)
          GestureDetector(onTap: () { _simulationTimer?.cancel(); _dotsTimer?.cancel(); Get.back(); }, child: Icon(Icons.arrow_back_ios_rounded, size: size.width * 0.045, color: AppColors.textPrimary)),
        SizedBox(width: size.width * 0.03),
        Container(width: size.width * 0.08, height: size.width * 0.08, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(Icons.restaurant_rounded, color: Colors.white, size: size.width * 0.045))),
        SizedBox(width: size.width * 0.03),
        Text('BURGER HOUSE', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1)),
      ]),
    );
  }

  Widget _buildInstructionText(Size size) {
    String line1 = '', line2 = '';
    switch (_status) {
      case PaymentStatus.started: line1 = 'Pay by contactless payment'; line2 = 'or insert your card now'; break;
      case PaymentStatus.reading: line1 = 'Card detected'; line2 = 'Please wait...'; break;
      case PaymentStatus.processing: line1 = 'Processing payment'; line2 = 'Do not remove card'; break;
      case PaymentStatus.approved: line1 = 'Payment successful!'; line2 = 'Thank you'; break;
      case PaymentStatus.declined: line1 = 'Payment declined'; line2 = 'Please try again'; break;
    }
    return Column(children: [
      Text(line1, style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      Text(line2, style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: _status == PaymentStatus.approved ? AppColors.accent : AppColors.textPrimary)),
    ]);
  }

  Widget _buildAmountDisplay(Size size, MenuController mc) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: size.height * 0.025),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]), borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Text('AMOUNT TO PAY', style: TextStyle(fontSize: size.width * 0.03, color: Colors.white70, letterSpacing: 2)),
          SizedBox(height: size.height * 0.01),
          Text(Formatters.currency(mc.cartTotal), style: TextStyle(fontSize: size.width * 0.1, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
      );
    });
  }

  Widget _buildCardReaderScreen(Size size) {
    return Container(
      width: size.width * 0.75,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade700), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(children: [
        Text('CARD READER', style: TextStyle(fontSize: size.width * 0.025, color: Colors.grey.shade500, letterSpacing: 2)),
        SizedBox(height: size.height * 0.02),
        _buildReaderStatus(size),
        SizedBox(height: size.height * 0.02),
        Container(
          height: size.height * 0.06,
          decoration: BoxDecoration(
            border: Border.all(color: _status == PaymentStatus.approved ? AppColors.accent : Colors.grey.shade600, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: _status == PaymentStatus.approved
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle, color: AppColors.accent, size: size.width * 0.05),
              SizedBox(width: size.width * 0.02),
              Text('CARD READ OK', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, color: AppColors.accent)),
            ])
                : Text('INSERT / TAP CARD', style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey.shade500, letterSpacing: 1)),
          ),
        ),
      ]),
    );
  }

  Widget _buildReaderStatus(Size size) {
    String text = ''; Color color = Colors.grey;
    switch (_status) {
      case PaymentStatus.started: text = 'WAITING FOR CARD...'; color = Colors.grey.shade400; break;
      case PaymentStatus.reading: text = 'READING${'.' * _readingDots}'; color = AppColors.reading; break;
      case PaymentStatus.processing: text = 'PROCESSING...'; color = AppColors.processing; break;
      case PaymentStatus.approved: text = 'APPROVED ✓'; color = AppColors.accent; break;
      case PaymentStatus.declined: text = 'DECLINED ✗'; color = AppColors.error; break;
    }
    return Column(children: [
      Text(text, style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
      if (_status == PaymentStatus.processing) ...[
        SizedBox(height: size.height * 0.01),
        SizedBox(width: size.width * 0.04, height: size.width * 0.04, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(color))),
      ],
    ]);
  }

  Widget _buildStatusBadge(Size size) {
    String text = ''; Color color = Colors.grey; IconData icon = Icons.circle; bool isPulsing = false;
    switch (_status) {
      case PaymentStatus.started: text = 'TRANSACTION STARTED'; color = AppColors.accent; icon = Icons.play_circle_fill; isPulsing = true; break;
      case PaymentStatus.reading: text = 'READING CARD...'; color = AppColors.reading; icon = Icons.nfc_rounded; break;
      case PaymentStatus.processing: text = 'PROCESSING...'; color = AppColors.processing; icon = Icons.sync_rounded; break;
      case PaymentStatus.approved: text = 'PAYMENT APPROVED'; color = AppColors.accent; icon = Icons.check_circle_rounded; break;
      case PaymentStatus.declined: text = 'PAYMENT DECLINED'; color = AppColors.error; icon = Icons.cancel_rounded; break;
    }

    Widget badge = Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06, vertical: size.height * 0.015),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(25), border: Border.all(color: color.withOpacity(0.3), width: 1.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: size.width * 0.04, color: color),
        SizedBox(width: size.width * 0.02),
        Text(text, style: TextStyle(fontSize: size.width * 0.033, fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
        if (_status == PaymentStatus.reading) Text('.${' .' * _readingDots}', style: TextStyle(fontSize: size.width * 0.033, fontWeight: FontWeight.bold, color: color)),
        if (_status == PaymentStatus.processing) ...[
          SizedBox(width: size.width * 0.02),
          SizedBox(width: size.width * 0.035, height: size.width * 0.035, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(color))),
        ],
      ]),
    );

    if (isPulsing) {
      return AnimatedBuilder(animation: _pulseAnimation, builder: (context, child) => Opacity(opacity: _pulseAnimation.value, child: badge));
    }
    return badge;
  }

  Widget _buildAnimatedArrow(Size size) {
    return AnimatedBuilder(
      animation: _arrowAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _arrowAnimation.value),
        child: Column(children: [
          Icon(Icons.keyboard_arrow_down_rounded, size: size.width * 0.08, color: AppColors.primary.withOpacity(0.6)),
          Transform.translate(offset: const Offset(0, -8), child: Icon(Icons.keyboard_arrow_down_rounded, size: size.width * 0.08, color: AppColors.primary.withOpacity(0.4))),
          Transform.translate(offset: const Offset(0, -16), child: Icon(Icons.keyboard_arrow_down_rounded, size: size.width * 0.08, color: AppColors.primary.withOpacity(0.2))),
        ]),
      ),
    );
  }

  Widget _buildProcessingAnimation(Size size) {
    return AnimatedBuilder(
      animation: _processingController,
      builder: (context, child) => Transform.rotate(
        angle: _processingController.value * 2 * 3.14159,
        child: Icon(Icons.sync_rounded, size: size.width * 0.08, color: AppColors.processing.withOpacity(0.6)),
      ),
    );
  }

  Widget _buildApprovedCheck(Size size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Container(
          width: size.width * 0.2, height: size.width * 0.2,
          decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)]),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget _buildHardwareIndicator(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _status == PaymentStatus.approved ? AppColors.accent : Colors.grey.shade300, width: 2))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _buildHardwareItem(size, Icons.credit_card_rounded, 'CARD READER', _status != PaymentStatus.started, AppColors.primary),
        SizedBox(width: size.width * 0.08),
        Icon(Icons.arrow_forward_rounded, size: size.width * 0.04, color: Colors.grey.shade400),
        SizedBox(width: size.width * 0.08),
        _buildHardwareItem(size, Icons.receipt_long_rounded, 'RECEIPT', _status == PaymentStatus.approved, AppColors.accent, subtitle: _status == PaymentStatus.approved ? 'PRINTING...' : null),
      ]),
    );
  }

  Widget _buildHardwareItem(Size size, IconData icon, String label, bool isActive, Color color, {String? subtitle}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: size.width * 0.12, height: size.width * 0.12,
        decoration: BoxDecoration(color: isActive ? color.withOpacity(0.1) : Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: isActive ? color : Colors.grey.shade300, width: isActive ? 2 : 1)),
        child: Center(child: Icon(icon, size: size.width * 0.05, color: isActive ? color : Colors.grey.shade400)),
      ),
      SizedBox(height: size.height * 0.01),
      Text(label, style: TextStyle(fontSize: size.width * 0.025, fontWeight: FontWeight.w600, color: isActive ? color : Colors.grey.shade500, letterSpacing: 1)),
      if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: size.width * 0.02, color: color, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildCancelButton(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity, height: size.height * 0.065,
          child: OutlinedButton(
            onPressed: () { _simulationTimer?.cancel(); _dotsTimer?.cancel(); Get.until((route) => route.settings.name == AppRoutes.menu); },
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text('CANCEL TRANSACTION', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          ),
        ),
      ),
    );
  }
}