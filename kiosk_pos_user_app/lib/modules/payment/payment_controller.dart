import 'package:get/get.dart';

class PaymentController extends GetxController {
  final selectedMethod = ''.obs;

  void selectMethod(String method) {
    selectedMethod.value = method;
  }
}