import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../utils/formatters.dart';
import '../../data/demo/demo_inventory.dart';
import '../../data/models/inventory_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<IngredientModel> get _filteredIngredients {
    if (_searchQuery.isEmpty) return DemoInventory.ingredients;
    return DemoInventory.ingredients.where((i) {
      final q = _searchQuery.toLowerCase();
      return i.name.toLowerCase().contains(q) ||
          i.category.toLowerCase().contains(q);
    }).toList();
  }

  int get _lowStockCount =>
      DemoInventory.ingredients.where((i) => i.isLowStock).length;
  double get _totalValue =>
      DemoInventory.ingredients.fold(0.0, (sum, i) => sum + i.stockValue);

  String _getStockStatus(IngredientModel i) {
    if (i.currentStock <= 0) return 'Out of Stock';
    if (i.currentStock <= i.minStock) return 'Low Stock';
    if (i.currentStock <= i.minStock * 2) return 'Reorder Soon';
    return 'In Stock';
  }

  Color _getStockColor(IngredientModel i) {
    if (i.currentStock <= 0) return AppColors.error;
    if (i.currentStock <= i.minStock) return AppColors.processing;
    if (i.currentStock <= i.minStock * 2) return const Color(0xFFF1C40F);
    return AppColors.accent;
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
                    child: Icon(Icons.arrow_back_ios_rounded, size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Inventory', style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
              ]),
            ),

            // Stats
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Row(children: [
                _buildStatCard(size, 'Items', '${DemoInventory.ingredients.length}', Icons.inventory_2_rounded, AppColors.reading),
                SizedBox(width: size.width * 0.03),
                _buildStatCard(size, 'Stock Value', Formatters.currency(_totalValue), Icons.shopping_cart_rounded, AppColors.accent),
                SizedBox(width: size.width * 0.03),
                _buildStatCard(size, 'Low Stock', '$_lowStockCount', Icons.warning_amber_rounded, AppColors.error),
                SizedBox(width: size.width * 0.03),
                _buildStatCard(size, 'Suppliers', '${DemoInventory.suppliers.length}', Icons.local_shipping_rounded, const Color(0xFF6C5CE7)),
              ]),
            ),

            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: AppColors.primary,
                labelStyle: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Stock'),
                  Tab(text: 'Suppliers'),
                  Tab(text: 'Orders'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStockTab(size),
                  _buildSuppliersTab(size),
                  _buildOrdersTab(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STOCK TAB ====================
  Widget _buildStockTab(Size size) {
    final items = _filteredIngredients;
    return Column(
      children: [
        // Search
        Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search ingredients...',
              prefixIcon: Icon(Icons.search_rounded, size: size.width * 0.045),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.012),
            ),
            style: TextStyle(fontSize: size.width * 0.033),
          ),
        ),

        // Low stock alert
        if (_lowStockCount > 0)
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            padding: EdgeInsets.all(size.width * 0.035),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: size.width * 0.05),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text('$_lowStockCount items need reordering',
                    style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.w600, color: AppColors.error)),
              ),
            ]),
          ),

        // List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(size.width * 0.04),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final status = _getStockStatus(item);
              final color = _getStockColor(item);
              return Container(
                margin: EdgeInsets.only(bottom: size.height * 0.01),
                padding: EdgeInsets.all(size.width * 0.035),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(
                    width: size.width * 0.11, height: size.width * 0.11,
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Icon(Icons.inventory_2_rounded, size: size.width * 0.05, color: color)),
                  ),
                  SizedBox(width: size.width * 0.035),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.name, style: TextStyle(fontSize: size.width * 0.034, fontWeight: FontWeight.bold)),
                      SizedBox(height: size.height * 0.004),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.003),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                          child: Text(item.category, style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade600)),
                        ),
                        SizedBox(width: size.width * 0.025),
                        Text('${item.currentStock.toStringAsFixed(0)} ${item.unit}',
                            style: TextStyle(fontSize: size.width * 0.028, fontWeight: FontWeight.w600, color: color)),
                      ]),
                      SizedBox(height: size.height * 0.006),
                      // Stock bar
                      Container(
                        height: size.height * 0.008,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                        child: Row(children: [
                          Flexible(
                            flex: (item.stockPercent * 100).toInt().clamp(0, 100),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: ((1 - item.stockPercent) * 100).toInt().clamp(0, 100),
                            child: Container(color: Colors.grey.shade200),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(Formatters.currency(item.costPerUnit), style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    SizedBox(height: size.height * 0.004),
                    Text(status, style: TextStyle(fontSize: size.width * 0.024, fontWeight: FontWeight.w600, color: color)),
                  ]),
                  SizedBox(width: size.width * 0.025),
                  // Stock adjust buttons
                  Column(children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.015),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Icon(Icons.add_rounded, size: size.width * 0.035, color: AppColors.accent),
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.015),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Icon(Icons.remove_rounded, size: size.width * 0.035, color: AppColors.error),
                      ),
                    ),
                  ]),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==================== SUPPLIERS TAB ====================
  Widget _buildSuppliersTab(Size size) {
    return ListView.builder(
      padding: EdgeInsets.all(size.width * 0.04),
      itemCount: DemoInventory.suppliers.length,
      itemBuilder: (context, index) {
        final supplier = DemoInventory.suppliers[index];
        final itemCount = supplier.itemIds.length;
        return Container(
          margin: EdgeInsets.only(bottom: size.height * 0.012),
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: size.width * 0.12, height: size.width * 0.12,
                decoration: BoxDecoration(color: const Color(0xFF6C5CE7).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Icon(Icons.local_shipping_rounded, size: size.width * 0.06, color: const Color(0xFF6C5CE7))),
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(supplier.name, style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.004),
                  Text(supplier.contactPerson, style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
                ]),
              ),
            ]),
            SizedBox(height: size.height * 0.02),
            Row(children: [
              _buildSupplierInfo(size, '📞', supplier.phone),
              SizedBox(width: size.width * 0.04),
              _buildSupplierInfo(size, '✉️', supplier.email),
            ]),
            SizedBox(height: size.height * 0.015),
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.006),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Text('$itemCount items', style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade600)),
              ),
              const Spacer(),
              SizedBox(
                height: size.height * 0.045,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Create Order', style: TextStyle(fontSize: size.width * 0.028, color: Colors.white)),
                ),
              ),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildSupplierInfo(Size size, String emoji, String text) {
    return Expanded(
      child: Row(children: [
        Text(emoji, style: TextStyle(fontSize: size.width * 0.03)),
        SizedBox(width: size.width * 0.01),
        Flexible(child: Text(text, style: TextStyle(fontSize: size.width * 0.025, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  // ==================== ORDERS TAB ====================
  Widget _buildOrdersTab(Size size) {
    final orders = DemoInventory.purchaseOrders;
    if (orders.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.receipt_long_outlined, size: size.width * 0.15, color: Colors.grey.shade300),
          SizedBox(height: size.height * 0.02),
          Text('No purchase orders', style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey.shade500)),
        ]),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(size.width * 0.04),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final po = orders[index];
        final supplier = DemoInventory.suppliers.firstWhere(
              (s) => s.id == po.supplierId,
          orElse: () => DemoInventory.suppliers.first,
        );
        return Container(
          margin: EdgeInsets.only(bottom: size.height * 0.012),
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Text('#${po.id}', style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
                SizedBox(width: size.width * 0.03),
                _buildStatusBadge(po.status, size),
              ]),
              Text(Formatters.currency(po.totalCost), style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ]),
            SizedBox(height: size.height * 0.015),
            Text('Supplier: ${supplier.name}', style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade600)),
            SizedBox(height: size.height * 0.01),
            ...po.items.map((item) {
              final ing = DemoInventory.ingredients.firstWhere(
                    (i) => i.id == item.ingredientId,
                orElse: () => DemoInventory.ingredients.first,
              );
              return Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.005),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(ing.name, style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade700)),
                  Text('${item.quantity.toStringAsFixed(0)} × ${Formatters.currency(item.cost / item.quantity)}',
                      style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
                ]),
              );
            }),
            SizedBox(height: size.height * 0.015),
            Row(children: [
              Icon(Icons.calendar_today_rounded, size: size.width * 0.035, color: Colors.grey.shade500),
              SizedBox(width: size.width * 0.01),
              Text('Ordered: ${po.orderedDate.toString().substring(0, 10)}',
                  style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
            ]),
            if (po.status != 'received' && po.status != 'cancelled') ...[
              SizedBox(height: size.height * 0.015),
              Row(children: [
                if (po.status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.reading, minimumSize: Size.zero, padding: EdgeInsets.symmetric(vertical: size.height * 0.012), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('Mark Ordered', style: TextStyle(fontSize: size.width * 0.028, color: Colors.white)),
                    ),
                  ),
                if (po.status == 'ordered')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: Size.zero, padding: EdgeInsets.symmetric(vertical: size.height * 0.012), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('Mark Received', style: TextStyle(fontSize: size.width * 0.028, color: Colors.white)),
                    ),
                  ),
                SizedBox(width: size.width * 0.025),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.symmetric(vertical: size.height * 0.012), side: BorderSide(color: AppColors.error.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('Cancel', style: TextStyle(fontSize: size.width * 0.028, color: AppColors.error)),
                  ),
                ),
              ]),
            ],
          ]),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status, Size size) {
    Color color;
    switch (status) {
      case 'received':
        color = AppColors.accent;
        break;
      case 'ordered':
        color = AppColors.reading;
        break;
      case 'pending':
        color = AppColors.processing;
        break;
      default:
        color = AppColors.error;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.004),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(), style: TextStyle(fontSize: size.width * 0.022, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildStatCard(Size size, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Icon(icon, size: size.width * 0.045, color: color),
          SizedBox(height: size.height * 0.005),
          Text(value, style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: size.width * 0.022, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }
}