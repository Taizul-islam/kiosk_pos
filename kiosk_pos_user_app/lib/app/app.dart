import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_pos_user_app/app/routes.dart';

import '../config/theme.dart';


class PosKioskApp extends StatelessWidget {
  const PosKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Kiosk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.welcome,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}