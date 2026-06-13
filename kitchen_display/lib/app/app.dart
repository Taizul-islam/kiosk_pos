import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/theme.dart';
import '../modules/kitchen/kitchen_screen.dart';

class KitchenApp extends StatelessWidget {
  const KitchenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kitchen Display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: const KitchenScreen(),
    );
  }
}