import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../utils/formatters.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Today';
  DateTime? _startDate;
  DateTime? _endDate;

  // Demo data for different periods
  Map<String, double> _getDataForPeriod() {
    switch (_selectedPeriod) {
      case 'Today':
        return {
          'totalOrders': 47,
          'totalRevenue': 1245.50,
          'cashRevenue': 456.00,
          'cardRevenue': 689.50,
          'memberRevenue': 100.00,
        };
      case 'Yesterday':
        return {
          'totalOrders': 38,
          'totalRevenue': 980.00,
          'cashRevenue': 320.00,
          'cardRevenue': 560.00,
          'memberRevenue': 100.00,
        };
      case 'Last 7 Days':
        return {
          'totalOrders': 312,
          'totalRevenue': 8450.00,
          'cashRevenue': 3200.00,
          'cardRevenue': 4450.00,
          'memberRevenue': 800.00,
        };
      case 'Last 30 Days':
        return {
          'totalOrders': 1340,
          'totalRevenue': 36200.00,
          'cashRevenue': 14200.00,
          'cardRevenue': 18500.00,
          'memberRevenue': 3500.00,
        };
      case 'This Month':
        return {
          'totalOrders': 890,
          'totalRevenue': 24100.00,
          'cashRevenue': 9500.00,
          'cardRevenue': 12200.00,
          'memberRevenue': 2400.00,
        };
      case 'Custom':
        return {
          'totalOrders': 125,
          'totalRevenue': 3200.00,
          'cashRevenue': 1200.00,
          'cardRevenue': 1700.00,
          'memberRevenue': 300.00,
        };
      default:
        return {
          'totalOrders': 0,
          'totalRevenue': 0,
          'cashRevenue': 0,
          'cardRevenue': 0,
          'memberRevenue': 0,
        };
    }
  }

  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedPeriod = 'Custom';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = _getDataForPeriod();
    final totalOrders = data['totalOrders']!.toInt();
    final totalRevenue = data['totalRevenue']!;
    final cashRevenue = data['cashRevenue']!;
    final cardRevenue = data['cardRevenue']!;
    final memberRevenue = data['memberRevenue']!;

    final periods = ['Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'This Month'];

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
                Text('Reports', style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const Spacer(),
                // Calendar icon for custom date
                GestureDetector(
                  onTap: _pickCustomDateRange,
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.02),
                    decoration: BoxDecoration(
                      color: _selectedPeriod == 'Custom' ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.calendar_month_rounded, size: size.width * 0.05,
                        color: _selectedPeriod == 'Custom' ? AppColors.primary : Colors.grey.shade600),
                  ),
                ),
              ]),
            ),

            // Period filter chips
            Container(
              height: size.height * 0.06,
              color: Colors.white,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.01),
                itemCount: periods.length + (_selectedPeriod == 'Custom' ? 1 : 0),
                separatorBuilder: (_, __) => SizedBox(width: size.width * 0.02),
                itemBuilder: (context, index) {
                  final isCustomTab = _selectedPeriod == 'Custom' && index == periods.length;
                  final period = isCustomTab ? 'Custom' : periods[index];
                  final isSelected = _selectedPeriod == period;
                  return GestureDetector(
                    onTap: () {
                      if (period == 'Custom') {
                        _pickCustomDateRange();
                      } else {
                        setState(() {
                          _selectedPeriod = period;
                          _startDate = null;
                          _endDate = null;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (isCustomTab) ...[
                            Icon(Icons.date_range_rounded, size: size.width * 0.035, color: isSelected ? Colors.white : Colors.grey.shade600),
                            SizedBox(width: size.width * 0.01),
                          ],
                          Text(
                            isCustomTab
                                ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                                : period,
                            style: TextStyle(
                                fontSize: size.width * 0.028,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.grey.shade600),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(children: [
                  // Period display
                  if (_selectedPeriod == 'Custom' && _startDate != null)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: size.height * 0.02),
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        Icon(Icons.info_outline, size: size.width * 0.04, color: AppColors.primary),
                        SizedBox(width: size.width * 0.02),
                        Text('Showing data from ${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}',
                            style: TextStyle(fontSize: size.width * 0.03, color: AppColors.primary)),
                      ]),
                    ),

                  // Revenue card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(children: [
                      Text('TOTAL REVENUE', style: TextStyle(fontSize: size.width * 0.03, color: Colors.white70, letterSpacing: 2)),
                      SizedBox(height: size.height * 0.01),
                      Text(Formatters.currency(totalRevenue),
                          style: TextStyle(fontSize: size.width * 0.1, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: size.height * 0.01),
                      Text('$totalOrders orders',
                          style: TextStyle(fontSize: size.width * 0.03, color: Colors.white54)),
                    ]),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Quick stats
                  Row(children: [
                    Expanded(
                      child: _buildStatCard(size, 'Avg Order',
                          Formatters.currency(totalOrders > 0 ? totalRevenue / totalOrders : 0),
                          Icons.receipt_long_rounded, AppColors.primary),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: _buildStatCard(size, 'Orders', '$totalOrders',
                          Icons.shopping_bag_rounded, AppColors.reading),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: _buildStatCard(size, 'Items/Order', '2.4',
                          Icons.restaurant_rounded, const Color(0xFF6C5CE7)),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.025),

                  // Payment breakdown
                  Text('Payment Breakdown', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.015),
                  _buildBreakdownCard(size, 'Card', cardRevenue, totalRevenue, AppColors.reading, Icons.credit_card_rounded),
                  _buildBreakdownCard(size, 'Cash', cashRevenue, totalRevenue, AppColors.accent, Icons.money_rounded),
                  _buildBreakdownCard(size, 'Member', memberRevenue, totalRevenue, const Color(0xFF6C5CE7), Icons.card_membership_rounded),
                  SizedBox(height: size.height * 0.025),

                  // Comparison
                  if (_selectedPeriod != 'Custom') ...[
                    Text('Comparison', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                    SizedBox(height: size.height * 0.015),
                    _buildComparisonCard(size, 'vs Previous Period', totalRevenue, totalRevenue * 0.85),
                    SizedBox(height: size.height * 0.025),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(Size size, String label, double amount, double total, Color color, IconData icon) {
    final percent = total > 0 ? (amount / total * 100).toStringAsFixed(0) : '0';
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.01),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(
          width: size.width * 0.1, height: size.width * 0.1,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: size.width * 0.05, color: color),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(child: Text(label, style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600))),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Formatters.currency(amount), style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, color: color)),
          Text('$percent%', style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
        ]),
      ]),
    );
  }

  Widget _buildStatCard(Size size, String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.035),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: size.width * 0.05, color: color),
        SizedBox(height: size.height * 0.012),
        Text(value, style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
        SizedBox(height: size.height * 0.004),
        Text(label, style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade500)),
      ]),
    );
  }

  Widget _buildComparisonCard(Size size, String label, double current, double previous) {
    final change = previous > 0 ? ((current - previous) / previous * 100) : 0.0;
    final isUp = change >= 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: size.width * 0.1, height: size.width * 0.1,
          decoration: BoxDecoration(
            color: isUp ? AppColors.accent.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: size.width * 0.05, color: isUp ? AppColors.accent : AppColors.error),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade600)),
            SizedBox(height: size.height * 0.005),
            Text('${isUp ? '+' : ''}${change.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: isUp ? AppColors.accent : AppColors.error)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('Current', style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade500)),
          Text(Formatters.currency(current), style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.005),
          Text('Previous', style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade500)),
          Text(Formatters.currency(previous), style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade500)),
        ]),
      ]),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}