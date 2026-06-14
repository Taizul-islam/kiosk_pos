import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/services/printer_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Store
  final _storeNameController = TextEditingController(text: 'Burger House');
  final _storeAddressController = TextEditingController(text: '123 Main Street, Kingstown');
  final _storePhoneController = TextEditingController(text: '+1-784-123-4567');
  final _taxController = TextEditingController(text: '15');
  final _currencyController = TextEditingController(text: '\$');

  // Printer Services
  final PrinterService _receiptPrinter = PrinterService(id: 'receipt');
  final PrinterService _kitchenPrinter = PrinterService(id: 'kitchen');

  // Receipt Printer controllers
  final _receiptPrinterIpController = TextEditingController();
  final _receiptPrinterPortController = TextEditingController();
  bool _receiptAutoPrint = true;

  // Kitchen Printer controllers
  final _kitchenPrinterIpController = TextEditingController();
  final _kitchenPrinterPortController = TextEditingController();
  bool _kitchenAutoPrint = true;

  @override
  void initState() {
    super.initState();
    // Load saved IP/Port into controllers
    _receiptPrinterIpController.text = _receiptPrinter.ipAddress.value;
    _receiptPrinterPortController.text = _receiptPrinter.port.value;
    _kitchenPrinterIpController.text = _kitchenPrinter.ipAddress.value;
    _kitchenPrinterPortController.text = _kitchenPrinter.port.value;
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storePhoneController.dispose();
    _taxController.dispose();
    _currencyController.dispose();
    _receiptPrinterIpController.dispose();
    _receiptPrinterPortController.dispose();
    _kitchenPrinterIpController.dispose();
    _kitchenPrinterPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
              ]),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Settings',
                    style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
              ]),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ============ STORE INFO ============
                  _buildSectionHeader('🏪 Store Information', size),
                  SizedBox(height: size.height * 0.015),
                  _buildTextField(_storeNameController, 'Store Name', Icons.store_rounded, size),
                  SizedBox(height: size.height * 0.015),
                  _buildTextField(_storeAddressController, 'Address', Icons.location_on_rounded, size),
                  SizedBox(height: size.height * 0.015),
                  _buildTextField(_storePhoneController, 'Phone', Icons.phone_rounded, size),
                  SizedBox(height: size.height * 0.03),

                  // ============ TAX & CURRENCY ============
                  _buildSectionHeader('💰 Tax & Currency', size),
                  SizedBox(height: size.height * 0.015),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(_taxController, 'Tax Rate (%)', Icons.percent_rounded, size, keyboardType: TextInputType.number),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      flex: 3,
                      child: _buildTextField(_currencyController, 'Currency Symbol', Icons.attach_money_rounded, size),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.03),

                  // ============ RECEIPT PRINTER ============
                  _buildSectionHeader('🧾 Receipt Printer (Customer)', size),
                  SizedBox(height: size.height * 0.005),
                  Text('Prints customer receipts after payment',
                      style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
                  SizedBox(height: size.height * 0.015),

                  // Connection Status
                  _buildPrinterStatus(_receiptPrinter, size),
                  SizedBox(height: size.height * 0.015),

                  // IP + Port
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: _buildTextField(
                        _receiptPrinterIpController, 'IP Address', Icons.wifi_rounded, size,
                        onChanged: (v) => _receiptPrinter.ipAddress.value = v,
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        _receiptPrinterPortController, 'Port', Icons.settings_ethernet_rounded, size,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _receiptPrinter.port.value = v,
                      ),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.015),

                  // Auto print toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('Auto Print Receipt', style: TextStyle(fontSize: size.width * 0.03)),
                    value: _receiptAutoPrint,
                    onChanged: (v) => setState(() => _receiptAutoPrint = v),
                    activeColor: AppColors.accent,
                  ),
                  SizedBox(height: size.height * 0.01),

                  // Test & Save button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return ElevatedButton.icon(
                        onPressed: _receiptPrinter.isTesting.value
                            ? null
                            : () async => await _receiptPrinter.testConnection(),
                        icon: _receiptPrinter.isTesting.value
                            ? SizedBox(
                          width: size.width * 0.04, height: size.width * 0.04,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Icon(Icons.wifi_find_rounded, size: size.width * 0.04),
                        label: Text(
                          _receiptPrinter.isTesting.value ? 'Testing...' : 'TEST & SAVE CONNECTION',
                          style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _receiptPrinter.isConnected.value ? AppColors.accent : AppColors.primary,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // ============ KITCHEN PRINTER ============
                  _buildSectionHeader('👨‍🍳 Kitchen Printer', size),
                  SizedBox(height: size.height * 0.005),
                  Text('Prints order tickets for kitchen staff',
                      style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
                  SizedBox(height: size.height * 0.015),

                  // Connection Status
                  _buildPrinterStatus(_kitchenPrinter, size),
                  SizedBox(height: size.height * 0.015),

                  // IP + Port
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: _buildTextField(
                        _kitchenPrinterIpController, 'IP Address', Icons.wifi_rounded, size,
                        onChanged: (v) => _kitchenPrinter.ipAddress.value = v,
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        _kitchenPrinterPortController, 'Port', Icons.settings_ethernet_rounded, size,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _kitchenPrinter.port.value = v,
                      ),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.015),

                  // Auto print toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('Auto Print Kitchen', style: TextStyle(fontSize: size.width * 0.03)),
                    value: _kitchenAutoPrint,
                    onChanged: (v) => setState(() => _kitchenAutoPrint = v),
                    activeColor: AppColors.error,
                  ),
                  SizedBox(height: size.height * 0.01),

                  // Test & Save button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return ElevatedButton.icon(
                        onPressed: _kitchenPrinter.isTesting.value
                            ? null
                            : () async => await _kitchenPrinter.testConnection(),
                        icon: _kitchenPrinter.isTesting.value
                            ? SizedBox(
                          width: size.width * 0.04, height: size.width * 0.04,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Icon(Icons.wifi_find_rounded, size: size.width * 0.04),
                        label: Text(
                          _kitchenPrinter.isTesting.value ? 'Testing...' : 'TEST & SAVE CONNECTION',
                          style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kitchenPrinter.isConnected.value ? AppColors.accent : AppColors.error,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: size.height * 0.04),
                ]),
              ),
            ),

            // ============ TEST PRINT BUTTONS ============
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))],
              ),
              child: SafeArea(
                top: false,
                child: Row(children: [
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton.icon(
                        onPressed: _receiptPrinter.isConnected.value ? _testReceiptPrint : null,
                        icon: Icon(Icons.receipt_long_rounded, size: size.width * 0.04),
                        label: Text('Test Receipt', style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _receiptPrinter.isConnected.value ? AppColors.primary : Colors.grey.shade300,
                          disabledBackgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton.icon(
                        onPressed: _kitchenPrinter.isConnected.value ? _testKitchenPrint : null,
                        icon: Icon(Icons.restaurant_rounded, size: size.width * 0.04),
                        label: Text('Test Kitchen', style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kitchenPrinter.isConnected.value ? AppColors.error : Colors.grey.shade300,
                          disabledBackgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }),
                  ),
                ]),
              ),
            ),

            // ============ SAVE SETTINGS ============
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))
              ]),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity, height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar('✅ Settings Saved!', 'All settings have been updated',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.accent,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('SAVE SETTINGS',
                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PRINTER STATUS INDICATOR ====================
  Widget _buildPrinterStatus(PrinterService printer, Size size) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 0.035),
        decoration: BoxDecoration(
          color: printer.isConnected.value
              ? AppColors.accent.withOpacity(0.08)
              : printer.ipAddress.isEmpty
              ? Colors.grey.shade50
              : AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: printer.isConnected.value
                ? AppColors.accent.withOpacity(0.3)
                : printer.ipAddress.isEmpty
                ? Colors.grey.shade200
                : AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Row(children: [
          Container(
            width: size.width * 0.035, height: size.width * 0.035,
            decoration: BoxDecoration(
              color: printer.isConnected.value
                  ? AppColors.accent
                  : printer.ipAddress.isEmpty
                  ? Colors.grey.shade400
                  : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: size.width * 0.025),
          Expanded(
            child: Text(printer.statusText,
                style: TextStyle(fontSize: size.width * 0.033, fontWeight: FontWeight.bold, color: printer.statusColor)),
          ),
        ]),
      );
    });
  }

  // ==================== WIDGET BUILDERS ====================
  Widget _buildSectionHeader(String title, Size size) {
    return Text(title,
        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Size size,
      {TextInputType keyboardType = TextInputType.text, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: size.width * 0.03),
        prefixIcon: Icon(icon, size: size.width * 0.045),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.04),
      ),
      style: TextStyle(fontSize: size.width * 0.035),
    );
  }

  // ==================== TEST PRINT METHODS ====================
  void _testReceiptPrint() async {
    final success = await _receiptPrinter.printReceipt(
      orderNumber: 'TEST-001',
      customerName: 'Test Customer',
      items: [
        {'name': 'Classic Burger', 'qty': 2, 'price': 12.00},
        {'name': 'French Fries', 'qty': 1, 'price': 5.00},
        {'name': 'Soda', 'qty': 2, 'price': 3.00},
      ],
      subtotal: 35.00,
      tax: 5.25,
      total: 40.25,
      paymentMethod: 'CARD',
    );

    Get.snackbar(
      success ? '✅ Receipt Test Sent!' : '❌ Print Failed',
      success ? 'Check the printer for output' : 'Could not connect to printer',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? AppColors.accent : AppColors.error,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _testKitchenPrint() async {
    final success = await _kitchenPrinter.printKitchenTicket(
      orderNumber: 'TEST-K01',
      customerName: 'Test Customer',
      tableNumber: '5',
      orderType: 'dine_in',
      items: [
        {'name': 'Classic Burger', 'qty': 2, 'modifiers': 'Medium, Extra Cheese'},
        {'name': 'French Fries', 'qty': 1, 'modifiers': 'Large'},
        {'name': 'Soda', 'qty': 2, 'modifiers': 'Coca-Cola'},
      ],
    );

    Get.snackbar(
      success ? '✅ Kitchen Test Sent!' : '❌ Print Failed',
      success ? 'Check the printer for output' : 'Could not connect to printer',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? AppColors.accent : AppColors.error,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}