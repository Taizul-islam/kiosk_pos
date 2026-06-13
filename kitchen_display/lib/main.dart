import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to landscape for kitchen display
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Full screen, no system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Keep screen on
  // (In production: use wakelock package)

  runApp(const KitchenApp());
}