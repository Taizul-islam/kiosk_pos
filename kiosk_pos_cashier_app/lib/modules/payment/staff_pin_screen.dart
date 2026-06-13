import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../app/routes.dart';
import '../menu/menu_controller.dart';

class StaffPinScreen extends StatefulWidget {
  const StaffPinScreen({super.key});

  @override
  State<StaffPinScreen> createState() => _StaffPinScreenState();
}

class _StaffPinScreenState extends State<StaffPinScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  String _errorMessage = '';
  bool _isProcessing = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumber(String num) {
    if (_pin.length < 4) {
      setState(() {
        _pin += num;
        _errorMessage = '';
      });
      if (_pin.length == 4) _verifyPin();
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _onClear() {
    setState(() {
      _pin = '';
      _errorMessage = '';
    });
  }

  Future<void> _verifyPin() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));

    // Accept both cashier (0000) and manager (1234) PINs
    final validPins = [AppConstants.cashierPin, AppConstants.managerPin];

    if (validPins.contains(_pin)) {
      Get.find<MenuController>().clearCart();
      Get.offAllNamed(AppRoutes.orderConfirmed);
    } else {
      setState(() {
        _errorMessage = 'Invalid PIN. Please try again.';
        _pin = '';
        _isProcessing = false;
      });
      _shakeController.forward().then((_) => _shakeController.reset());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(size),
            const Spacer(),
            Container(
              width: size.width * 0.2,
              height: size.width * 0.2,
              decoration: BoxDecoration(
                  color: Colors.orange.shade50, shape: BoxShape.circle),
              child: Center(
                  child: Icon(Icons.lock_outline_rounded,
                      size: size.width * 0.1,
                      color: Colors.orange.shade700)),
            ),
            SizedBox(height: size.height * 0.03),
            Text('Staff Confirmation',
                style: TextStyle(
                    fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),
            SizedBox(height: size.height * 0.01),
            Text('Enter your PIN to confirm payment',
                style: TextStyle(
                    fontSize: size.width * 0.035, color: Colors.grey.shade600)),
            SizedBox(height: size.height * 0.04),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final filled = index < _pin.length;
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02),
                      width: size.width * 0.06,
                      height: size.width * 0.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? AppColors.primary
                            : Colors.grey.shade200,
                        border: _errorMessage.isNotEmpty
                            ? Border.all(color: AppColors.error, width: 2)
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: size.height * 0.02),
              Text(_errorMessage,
                  style: TextStyle(
                      color: AppColors.error,
                      fontSize: size.width * 0.035)),
            ],
            SizedBox(height: size.height * 0.04),
            _buildKeypad(size),
            const Spacer(),
            TextButton(
                onPressed: () => Get.back(),
                child: Text('← Back',
                    style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: Colors.grey.shade500))),
            SizedBox(height: size.height * 0.03),
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

  Widget _buildKeypad(Size size) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['⌫', '0', '✕']
    ];
    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return Padding(
              padding: EdgeInsets.all(size.width * 0.01),
              child: SizedBox(
                width: size.width * 0.22,
                height: size.height * 0.08,
                child: Material(
                  color: key == '⌫' || key == '✕'
                      ? Colors.grey.shade100
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isProcessing
                        ? null
                        : () {
                      if (key == '⌫') _onDelete();
                      else if (key == '✕') _onClear();
                      else _onNumber(key);
                    },
                    child: Center(
                      child: key == '⌫'
                          ? Icon(Icons.backspace_outlined,
                          size: size.width * 0.06,
                          color: Colors.grey.shade700)
                          : key == '✕'
                          ? Icon(Icons.close,
                          size: size.width * 0.06,
                          color: Colors.grey.shade700)
                          : Text(key,
                          style: TextStyle(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}