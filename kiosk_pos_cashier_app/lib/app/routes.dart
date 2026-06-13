import 'package:get/get.dart';
import '../modules/inventory/inventory_screen.dart';
import '../modules/login/login_screen.dart';
import '../modules/dashboard/dashboard_screen.dart';
import '../modules/new_order/new_order_screen.dart';
import '../modules/menu/menu_screen.dart';
import '../modules/menu/menu_controller.dart';
import '../modules/cart/cart_screen.dart';
import '../modules/payment/payment_screen.dart';
import '../modules/payment/payment_controller.dart';
import '../modules/payment/staff_pin_screen.dart';
import '../modules/active_orders/active_orders_screen.dart';
import '../modules/reports/reports_screen.dart';
import '../modules/order_confirmed/order_confirmed_screen.dart';
import '../modules/menu_management/menu_management_screen.dart';
import '../modules/menu_management/product_form_screen.dart';
import '../modules/staff_management/staff_management_screen.dart';
import '../modules/card_issuance/card_issuance_screen.dart';
import '../modules/settings/settings_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String newOrder = '/new-order';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String staffPin = '/staff-pin';
  static const String activeOrders = '/active-orders';
  static const String reports = '/reports';
  static const String orderConfirmed = '/order-confirmed';
  static const String menuManagement = '/menu-management';
  static const String productForm = '/product-form';
  static const String staffManagement = '/staff-management';
  static const String cardIssuance = '/card-issuance';
  static const String settings = '/settings';
  static const String inventory = '/inventory';

  static List<GetPage> pages = [
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: newOrder, page: () => const NewOrderScreen()),
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
    GetPage(name: staffPin, page: () => const StaffPinScreen()),
    GetPage(name: activeOrders, page: () => const ActiveOrdersScreen()),
    GetPage(name: reports, page: () => const ReportsScreen()),
    GetPage(name: orderConfirmed, page: () => const OrderConfirmedScreen()),
    GetPage(name: menuManagement, page: () => const MenuManagementScreen()),
    GetPage(name: productForm, page: () => const ProductFormScreen()),
    GetPage(name: staffManagement, page: () => const StaffManagementScreen()),
    GetPage(name: cardIssuance, page: () => const CardIssuanceScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(
      name: inventory,
      page: () => const InventoryScreen(),
    ),
  ];
}