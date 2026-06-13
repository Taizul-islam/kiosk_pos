import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storeNameController = TextEditingController(text: 'Burger House');
  final _storeAddressController = TextEditingController(text: '123 Main Street, Kingstown');
  final _storePhoneController = TextEditingController(text: '+1-784-123-4567');
  final _taxController = TextEditingController(text: '15');
  final _currencyController = TextEditingController(text: '\$');

  // Receipt Printer
  final _receiptPrinterNameController = TextEditingController(text: 'Receipt Printer');
  final _receiptPrinterIpController = TextEditingController(text: '192.168.1.100');
  final _receiptPrinterPortController = TextEditingController(text: '9100');
  String _receiptPrinterType = 'network';
  bool _receiptAutoPrint = true;
  String _receiptPaperSize = '80mm';

  // Kitchen Printer
  final _kitchenPrinterNameController = TextEditingController(text: 'Kitchen Printer');
  final _kitchenPrinterIpController = TextEditingController(text: '192.168.1.101');
  final _kitchenPrinterPortController = TextEditingController(text: '9100');
  String _kitchenPrinterType = 'network';
  bool _kitchenAutoPrint = true;
  String _kitchenPaperSize = '80mm';

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storePhoneController.dispose();
    _taxController.dispose();
    _currencyController.dispose();
    _receiptPrinterNameController.dispose();
    _receiptPrinterIpController.dispose();
    _receiptPrinterPortController.dispose();
    _kitchenPrinterNameController.dispose();
    _kitchenPrinterIpController.dispose();
    _kitchenPrinterPortController.dispose();
    super.dispose();
  }

  void _testPrint(String printerName, String ip) {
    Get.snackbar(
      '🖨️ Test Print Sent',
      'Test ticket sent to $printerName at $ip',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.reading,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
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

                  _buildTextField(_receiptPrinterNameController, 'Printer Name', Icons.print_rounded, size),
                  SizedBox(height: size.height * 0.015),

                  // Connection type
                  _buildLabel('Connection Type', size),
                  SizedBox(height: size.height * 0.01),
                  Row(children: [
                    _buildTypeChip('Network', 'network', _receiptPrinterType, (v) => setState(() => _receiptPrinterType = v), size),
                    SizedBox(width: size.width * 0.03),
                    _buildTypeChip('USB', 'usb', _receiptPrinterType, (v) => setState(() => _receiptPrinterType = v), size),
                    SizedBox(width: size.width * 0.03),
                    _buildTypeChip('Serial', 'serial', _receiptPrinterType, (v) => setState(() => _receiptPrinterType = v), size),
                  ]),
                  SizedBox(height: size.height * 0.015),

                  if (_receiptPrinterType == 'network') ...[
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(_receiptPrinterIpController, 'IP Address', Icons.wifi_rounded, size),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(_receiptPrinterPortController, 'Port', Icons.settings_ethernet_rounded, size, keyboardType: TextInputType.number),
                      ),
                    ]),
                  ],
                  if (_receiptPrinterType == 'usb') ...[
                    _buildTextField(TextEditingController(text: 'USB001'), 'USB Port', Icons.usb_rounded, size),
                  ],
                  if (_receiptPrinterType == 'serial') ...[
                    _buildTextField(TextEditingController(text: 'COM1'), 'Serial Port', Icons.cable_rounded, size),
                  ],
                  SizedBox(height: size.height * 0.015),

                  // Paper size & auto print
                  Row(children: [
                    Expanded(
                      child: _buildDropdown('Paper', _receiptPaperSize, ['58mm', '80mm'], (v) => setState(() => _receiptPaperSize = v!), size),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('Auto Print', style: TextStyle(fontSize: size.width * 0.03)),
                        value: _receiptAutoPrint,
                        onChanged: (v) => setState(() => _receiptAutoPrint = v),
                        activeColor: AppColors.accent,
                      ),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.01),
                  // Test print button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _testPrint(_receiptPrinterNameController.text, _receiptPrinterIpController.text),
                      icon: Icon(Icons.print_rounded, size: size.width * 0.04),
                      label: Text('Test Receipt Print', style: TextStyle(fontSize: size.width * 0.03)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.014),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // ============ KITCHEN PRINTER ============
                  _buildSectionHeader('👨‍🍳 Kitchen Printer', size),
                  SizedBox(height: size.height * 0.005),
                  Text('Prints order tickets for kitchen staff',
                      style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
                  SizedBox(height: size.height * 0.015),

                  _buildTextField(_kitchenPrinterNameController, 'Printer Name', Icons.print_rounded, size),
                  SizedBox(height: size.height * 0.015),

                  _buildLabel('Connection Type', size),
                  SizedBox(height: size.height * 0.01),
                  Row(children: [
                    _buildTypeChip('Network', 'network', _kitchenPrinterType, (v) => setState(() => _kitchenPrinterType = v), size),
                    SizedBox(width: size.width * 0.03),
                    _buildTypeChip('USB', 'usb', _kitchenPrinterType, (v) => setState(() => _kitchenPrinterType = v), size),
                    SizedBox(width: size.width * 0.03),
                    _buildTypeChip('Serial', 'serial', _kitchenPrinterType, (v) => setState(() => _kitchenPrinterType = v), size),
                  ]),
                  SizedBox(height: size.height * 0.015),

                  if (_kitchenPrinterType == 'network') ...[
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(_kitchenPrinterIpController, 'IP Address', Icons.wifi_rounded, size),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(_kitchenPrinterPortController, 'Port', Icons.settings_ethernet_rounded, size, keyboardType: TextInputType.number),
                      ),
                    ]),
                  ],
                  if (_kitchenPrinterType == 'usb') ...[
                    _buildTextField(TextEditingController(text: 'USB002'), 'USB Port', Icons.usb_rounded, size),
                  ],
                  if (_kitchenPrinterType == 'serial') ...[
                    _buildTextField(TextEditingController(text: 'COM2'), 'Serial Port', Icons.cable_rounded, size),
                  ],
                  SizedBox(height: size.height * 0.015),

                  Row(children: [
                    Expanded(
                      child: _buildDropdown('Paper', _kitchenPaperSize, ['58mm', '80mm'], (v) => setState(() => _kitchenPaperSize = v!), size),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('Auto Print', style: TextStyle(fontSize: size.width * 0.03)),
                        value: _kitchenAutoPrint,
                        onChanged: (v) => setState(() => _kitchenAutoPrint = v),
                        activeColor: AppColors.accent,
                      ),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _testPrint(_kitchenPrinterNameController.text, _kitchenPrinterIpController.text),
                      icon: Icon(Icons.print_rounded, size: size.width * 0.04),
                      label: Text('Test Kitchen Print', style: TextStyle(fontSize: size.width * 0.03)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.014),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                ]),
              ),
            ),

            // Save button
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))
              ]),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
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

  Widget _buildSectionHeader(String title, Size size) {
    return Text(title,
        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
  }

  Widget _buildLabel(String text, Size size) {
    return Text(text, style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.w500, color: Colors.grey.shade700));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Size size,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildTypeChip(String label, String value, String selected, Function(String) onChanged, Size size) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.012),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700)),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontSize: size.width * 0.03))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}