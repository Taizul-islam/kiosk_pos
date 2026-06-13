import 'package:get/get.dart';
import '../modules/welcome/welcome_screen.dart';
import '../modules/order_type/order_type_screen.dart';
import '../modules/menu_categories/menu_categories_screen.dart'; // NEW
import '../modules/menu/menu_screen.dart';
import '../modules/menu/menu_controller.dart';
import '../modules/cart/cart_screen.dart';
import '../modules/payment/payment_screen.dart';
import '../modules/payment/payment_controller.dart';
import '../modules/payment/card_reader_screen.dart';
import '../modules/payment/staff_pin_screen.dart';
import '../modules/order_confirmed/order_confirmed_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String orderType = '/order-type';
  static const String menuCategories = '/menu-categories'; // NEW
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String cardReader = '/card-reader';
  static const String staffPin = '/staff-pin';
  static const String orderConfirmed = '/order-confirmed';

  static List<GetPage> pages = [
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(
      name: orderType,
      page: () => const OrderTypeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 10),
    ),
    // NEW SCREEN
    GetPage(
      name: menuCategories,
      page: () => const MenuCategoriesScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: menu,
      page: () => const MenuScreen(),
      binding: BindingsBuilder(() {
        Get.put(MenuController(), permanent: true);
      }),
    ),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(
      name: payment,
      page: () => const PaymentScreen(),
      binding: BindingsBuilder(() {
        Get.put(PaymentController(), permanent: true);
      }),
    ),
    GetPage(name: cardReader, page: () => const CardReaderScreen()),
    GetPage(name: staffPin, page: () => const StaffPinScreen()),
    GetPage(name: orderConfirmed, page: () => const OrderConfirmedScreen()),
  ];
}