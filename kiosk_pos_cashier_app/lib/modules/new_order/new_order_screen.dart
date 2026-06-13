import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _nameController = TextEditingController();
  final _tableController = TextEditingController();
  String? _orderType;

  @override
  void dispose() {
    _nameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  void _startOrder() {
    Get.toNamed(AppRoutes.menu, arguments: {
      'orderType': _orderType ?? 'dine_in',
      'customerName': _nameController.text.isNotEmpty ? _nameController.text : null,
      'tableNumber': _tableController.text.isNotEmpty ? _tableController.text : null,
      'source': 'cashier',
    });
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
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_rounded, size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('New Order', style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer name
                    Text('Customer Name', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600)),
                    SizedBox(height: size.height * 0.01),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Optional - Enter customer name', prefixIcon: Icon(Icons.person_outline_rounded, size: size.width * 0.05)),
                      style: TextStyle(fontSize: size.width * 0.038),
                    ),
                    SizedBox(height: size.height * 0.025),

                    // Table number
                    Text('Table Number', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600)),
                    SizedBox(height: size.height * 0.01),
                    TextField(
                      controller: _tableController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Optional - Enter table number', prefixIcon: Icon(Icons.table_restaurant_rounded, size: size.width * 0.05)),
                      style: TextStyle(fontSize: size.width * 0.038),
                    ),
                    SizedBox(height: size.height * 0.04),

                    // Order type
                    Text('Order Type', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600)),
                    SizedBox(height: size.height * 0.015),
                    Row(children: [
                      Expanded(
                        child: _buildTypeButton(size, Icons.restaurant_rounded, 'DINE IN', 'dine_in', AppColors.primary),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: _buildTypeButton(size, Icons.shopping_bag_rounded, 'TAKE AWAY', 'take_away', const Color(0xFF6C5CE7)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // Start Order button
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))]),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: _startOrder,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: Text('START ORDER', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(Size size, IconData icon, String title, String type, Color color) {
    final isSelected = _orderType == type;
    return GestureDetector(
      onTap: () => setState(() => _orderType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Column(children: [
          Icon(icon, size: size.width * 0.06, color: isSelected ? Colors.white : color),
          SizedBox(height: size.height * 0.01),
          Text(title, style: TextStyle(fontSize: size.width * 0.033, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : color)),
        ]),
      ),
    );
  }
}