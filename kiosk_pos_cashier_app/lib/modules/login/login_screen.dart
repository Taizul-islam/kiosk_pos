import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/services/auth_service.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  String _errorMessage = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final AuthService _authService = Get.put(AuthService());

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
    await Future.delayed(const Duration(milliseconds: 400));
    final user = _authService.login(_pin);
    if (user != null) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      setState(() {
        _errorMessage = 'Invalid PIN';
        _pin = '';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Container(
              width: size.width * 0.25,
              height: size.width * 0.25,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2),
                ],
              ),
              child: Center(
                  child: Icon(Icons.store_rounded,
                      color: Colors.white, size: size.width * 0.13)),
            ),
            SizedBox(height: size.height * 0.04),
            Text('BURGER HOUSE',
                style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 2)),
            SizedBox(height: size.height * 0.01),
            Text('Staff Login',
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.grey.shade500)),
            SizedBox(height: size.height * 0.06),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      width: size.width * 0.05,
                      height: size.width * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < _pin.length
                            ? AppColors.primary
                            : Colors.grey.shade200,
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
            SizedBox(height: size.height * 0.05),
            _buildKeypad(size),
            const Spacer(),
            Text('Cashier / Manager Terminal',
                style: TextStyle(
                    fontSize: size.width * 0.025,
                    color: Colors.grey.shade400,
                    letterSpacing: 2)),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
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
                    onTap: () {
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