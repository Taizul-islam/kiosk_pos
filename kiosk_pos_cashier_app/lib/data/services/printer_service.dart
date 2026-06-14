import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PrinterService {
  final String id; // 'receipt' or 'kitchen'
  final GetStorage _storage = GetStorage();

  // Observable states
  final RxString ipAddress = ''.obs;
  final RxString port = '9100'.obs;
  final RxBool isConnected = false.obs;
  final RxBool isTesting = false.obs;
  final RxString statusMessage = ''.obs;

  PrinterService({required this.id}) {
    _loadSavedSettings();
  }

  // Load saved printer settings
  void _loadSavedSettings() {
    ipAddress.value = _storage.read('${id}_printer_ip') ?? '';
    port.value = _storage.read('${id}_printer_port') ?? '9100';
    if (ipAddress.isNotEmpty) {
      debugPrint('📌 Loaded $id printer: ${ipAddress.value}:${port.value}');
    }
  }

  // Save printer settings
  Future<void> saveSettings(String ip, String portNumber) async {
    await _storage.write('${id}_printer_ip', ip);
    await _storage.write('${id}_printer_port', portNumber);
    ipAddress.value = ip;
    port.value = portNumber;
    debugPrint('💾 Saved $id printer: $ip:$portNumber');
  }

  // Test connection to printer
  Future<bool> testConnection({String? ip, String? portNumber}) async {
    final testIp = ip ?? ipAddress.value;
    final testPort = int.tryParse(portNumber ?? port.value) ?? 9100;

    if (testIp.isEmpty) {
      statusMessage.value = 'Please enter an IP address';
      isConnected.value = false;
      return false;
    }

    isTesting.value = true;
    statusMessage.value = 'Connecting to $testIp:$testPort...';

    try {
      debugPrint('🔌 Testing connection to $testIp:$testPort');

      final socket = await Socket.connect(
        testIp,
        testPort,
        timeout: const Duration(seconds: 5),
      );

      // Connection successful
      socket.destroy();
      isConnected.value = true;
      statusMessage.value = '✅ Connected to $testIp:$testPort';
      isTesting.value = false;

      // Save if using new IP/Port
      if (ip != null || portNumber != null) {
        await saveSettings(testIp, testPort.toString());
      }

      debugPrint('✅ $id printer connected successfully');
      return true;

    } on SocketException catch (e) {
      isConnected.value = false;
      statusMessage.value = '❌ Cannot reach printer at $testIp:$testPort';
      isTesting.value = false;
      debugPrint('❌ Socket error: $e');

      // Suggest trying different port
      if (testPort == 9100) {
        statusMessage.value = '❌ Port 9100 failed. Try port 515 or 631?';
      }
      return false;

    } on TimeoutException {
      isConnected.value = false;
      statusMessage.value = '❌ Connection timed out. Check IP address.';
      isTesting.value = false;
      return false;

    } catch (e) {
      isConnected.value = false;
      statusMessage.value = '❌ Error: ${e.toString().substring(0, 50)}';
      isTesting.value = false;
      return false;
    }
  }

  // Print kitchen order ticket
  Future<bool> printKitchenTicket({
    required String orderNumber,
    required String? customerName,
    required String? tableNumber,
    required String orderType,
    required List<Map<String, dynamic>> items,
    String? specialInstructions,
  }) async {
    if (!isConnected.value) {
      debugPrint('❌ Printer not connected, trying to reconnect...');
      final connected = await testConnection();
      if (!connected) return false;
    }

    try {
      final socket = await Socket.connect(
        ipAddress.value,
        int.tryParse(port.value) ?? 9100,
        timeout: const Duration(seconds: 5),
      );

      final buffer = StringBuffer();

      // Initialize printer
      buffer.write('\x1B\x40');

      // Header
      buffer.write('\x1B\x61\x01'); // Center align
      buffer.write('\x1B\x21\x30'); // Double height
      buffer.write('\n');
      buffer.write('=' * 48);
      buffer.write('\n');
      buffer.write('         KITCHEN ORDER\n');
      buffer.write('=' * 48);
      buffer.write('\n\n');

      // Reset formatting
      buffer.write('\x1B\x21\x00');
      buffer.write('\x1B\x61\x00'); // Left align

      // Order info
      buffer.write('Order: #$orderNumber\n');
      buffer.write('Type: ${orderType == 'dine_in' ? '🪑 DINE IN' : '🛍️ TAKE AWAY'}\n');
      if (tableNumber != null && tableNumber.isNotEmpty) {
        buffer.write('Table: $tableNumber\n');
      }
      if (customerName != null && customerName.isNotEmpty) {
        buffer.write('Customer: $customerName\n');
      }
      buffer.write('Time: ${DateTime.now().toString().substring(11, 19)}\n');
      buffer.write('\n');
      buffer.write('-' * 48);
      buffer.write('\n');

      // Items
      buffer.write('\x1B\x21\x10'); // Bold
      buffer.write('ITEM                          QTY\n');
      buffer.write('\x1B\x21\x00'); // Reset
      buffer.write('-' * 48);
      buffer.write('\n');

      for (final item in items) {
        final name = item['name'] as String;
        final qty = item['qty'].toString();
        final modifiers = item['modifiers'] as String? ?? '';

        buffer.write('${qty}x $name\n');
        if (modifiers.isNotEmpty) {
          buffer.write('    -> $modifiers\n');
        }
      }

      if (specialInstructions != null && specialInstructions.isNotEmpty) {
        buffer.write('\n');
        buffer.write('-' * 48);
        buffer.write('\n');
        buffer.write('⚠️  $specialInstructions\n');
      }

      buffer.write('\n');
      buffer.write('=' * 48);
      buffer.write('\n');
      buffer.write('\x1B\x61\x01'); // Center
      buffer.write('\x1B\x21\x30'); // Double height
      buffer.write('     PREPARE ASAP!\n');
      buffer.write('\x1B\x21\x00');
      buffer.write('=' * 48);
      buffer.write('\n');

      // Form feed
      buffer.write('\x0C');

      socket.write(buffer.toString());
      await socket.flush();
      socket.destroy();

      debugPrint('✅ Kitchen ticket printed: #$orderNumber');
      return true;
    } catch (e) {
      debugPrint('❌ Kitchen print failed: $e');
      isConnected.value = false;
      return false;
    }
  }

  // Print customer receipt
  Future<bool> printReceipt({
    required String orderNumber,
    required String? customerName,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double tax,
    required double total,
    required String paymentMethod,
  }) async {
    if (!isConnected.value) {
      final connected = await testConnection();
      if (!connected) return false;
    }

    try {
      final socket = await Socket.connect(
        ipAddress.value,
        int.tryParse(port.value) ?? 9100,
        timeout: const Duration(seconds: 5),
      );

      final buffer = StringBuffer();

      buffer.write('\x1B\x40');
      buffer.write('\x1B\x61\x01'); // Center

      // Store header
      buffer.write('\x1B\x21\x30'); // Double height
      buffer.write('\n');
      buffer.write('       BURGER HOUSE\n');
      buffer.write('\x1B\x21\x00');
      buffer.write('   123 Main Street, Kingstown\n');
      buffer.write('   Tel: +1-784-123-4567\n');
      buffer.write('\n');
      buffer.write('-' * 48);
      buffer.write('\n');

      buffer.write('\x1B\x61\x00'); // Left align
      buffer.write('Receipt: #$orderNumber\n');
      buffer.write('Date: ${DateTime.now().toString().substring(0, 19)}\n');
      if (customerName != null && customerName.isNotEmpty) {
        buffer.write('Customer: $customerName\n');
      }
      buffer.write('\n');
      buffer.write('-' * 48);
      buffer.write('\n');

      // Items with prices
      for (final item in items) {
        final name = item['name'] as String;
        final qty = item['qty'] as int;
        final price = (item['price'] as double) * qty;

        buffer.write('${qty}x ${name.length > 28 ? name.substring(0, 25) + '...' : name}\n');
        buffer.write('    \$${price.toStringAsFixed(2)}\n');
      }

      buffer.write('\n');
      buffer.write('-' * 48);
      buffer.write('\n');
      buffer.write('SUBTOTAL:     \$${subtotal.toStringAsFixed(2)}\n');
      buffer.write('TAX (15%):    \$${tax.toStringAsFixed(2)}\n');
      buffer.write('-' * 48);
      buffer.write('\n');
      buffer.write('\x1B\x21\x20'); // Double height
      buffer.write('TOTAL:        \$${total.toStringAsFixed(2)}\n');
      buffer.write('\x1B\x21\x00');
      buffer.write('-' * 48);
      buffer.write('\n');

      buffer.write('\x1B\x61\x01'); // Center
      buffer.write('Payment: ${paymentMethod.toUpperCase()}\n');
      buffer.write('\n');
      buffer.write('   Thank you for your order!\n');
      buffer.write('     Please come again!\n');
      buffer.write('\n\n\n');

      buffer.write('\x0C'); // Form feed

      socket.write(buffer.toString());
      await socket.flush();
      socket.destroy();

      debugPrint('✅ Receipt printed: #$orderNumber');
      return true;
    } catch (e) {
      debugPrint('❌ Receipt print failed: $e');
      isConnected.value = false;
      return false;
    }
  }

  // Get status with emoji
  String get statusText {
    if (isTesting.value) return '🔌 Testing...';
    if (isConnected.value) return '✅ Connected';
    if (ipAddress.isEmpty) return '⚙️ Not configured';
    return '❌ Disconnected';
  }

  Color get statusColor {
    if (isTesting.value) return Colors.orange;
    if (isConnected.value) return Colors.green;
    if (ipAddress.isEmpty) return Colors.grey;
    return Colors.red;
  }
}