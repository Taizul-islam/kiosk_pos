import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../utils/formatters.dart';

// Demo customer data
class _DemoCustomer {
  final String cardNumber;
  final String name;
  final double balance;
  final int points;
  final int visits;

  _DemoCustomer({
    required this.cardNumber,
    required this.name,
    this.balance = 0.0,
    this.points = 0,
    this.visits = 0,
  });
}

class CardIssuanceScreen extends StatefulWidget {
  const CardIssuanceScreen({super.key});

  @override
  State<CardIssuanceScreen> createState() => _CardIssuanceScreenState();
}

class _CardIssuanceScreenState extends State<CardIssuanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Issue new card
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isCardDetected = false;
  String _cardUid = '';

  // Top up
  final _topUpCardController = TextEditingController();
  final _topUpAmountController = TextEditingController();
  _DemoCustomer? _foundCustomer;
  double _topUpAmount = 0;
  bool _isTopUpCardDetected = false;

  // Demo existing customers
  final List<_DemoCustomer> _existingCards = [
    _DemoCustomer(cardNumber: 'MEM00123456', name: 'John Doe', balance: 25.00, points: 150, visits: 12),
    _DemoCustomer(cardNumber: 'MEM00789012', name: 'Jane Smith', balance: 50.00, points: 320, visits: 28),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cardUid = 'MEM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _topUpCardController.dispose();
    _topUpAmountController.dispose();
    super.dispose();
  }

  void _simulateCardDetection() {
    setState(() {
      _isCardDetected = !_isCardDetected;
      if (!_isCardDetected) {
        _cardUid = 'MEM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      }
    });
  }

  void _simulateTopUpCardDetection() {
    setState(() => _isTopUpCardDetected = !_isTopUpCardDetected);
  }

  void _lookupCard() {
    final cardNumber = _topUpCardController.text.trim();
    if (cardNumber.isEmpty) {
      Get.snackbar('Error', 'Enter a card number or tap a card',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }

    try {
      final customer = _existingCards.firstWhere((c) => c.cardNumber == cardNumber);
      setState(() => _foundCustomer = customer);
    } catch (_) {
      Get.snackbar('Not Found', 'No card found with that number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
    }
  }

  void _issueCard() {
    if (_nameController.text.isEmpty) {
      Get.snackbar('Required', 'Please enter customer name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }

    // Add to demo list
    final newCard = _DemoCustomer(
      cardNumber: _cardUid,
      name: _nameController.text,
      balance: 0,
      points: 0,
      visits: 0,
    );
    _existingCards.add(newCard);

    Get.snackbar('✅ Card Issued!', 'Card $_cardUid linked to ${_nameController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);

    // Reset form
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _isCardDetected = false;
      _cardUid = 'MEM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    });
  }

  void _processTopUp() {
    if (_foundCustomer == null) return;
    if (_topUpAmount <= 0) {
      Get.snackbar('Error', 'Enter an amount to top up',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }

    final updatedCustomer = _DemoCustomer(
      cardNumber: _foundCustomer!.cardNumber,
      name: _foundCustomer!.name,
      balance: _foundCustomer!.balance + _topUpAmount,
      points: _foundCustomer!.points,
      visits: _foundCustomer!.visits,
    );

    final index = _existingCards.indexWhere((c) => c.cardNumber == _foundCustomer!.cardNumber);
    _existingCards[index] = updatedCustomer;
    setState(() => _foundCustomer = updatedCustomer);

    Get.snackbar('✅ Top Up Successful!', 'Added ${Formatters.currency(_topUpAmount)} to ${_foundCustomer!.name}\nNew Balance: ${Formatters.currency(updatedCustomer.balance)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);

    _topUpAmountController.clear();
    setState(() => _topUpAmount = 0);
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
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Card Management',
                    style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
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
                labelStyle: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Issue New'),
                  Tab(text: 'Top Up'),
                  Tab(text: 'All Cards'),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIssueNewTab(size),
                  _buildTopUpTab(size),
                  _buildAllCardsTab(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 1: ISSUE NEW CARD ====================
  Widget _buildIssueNewTab(Size size) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF8B7CF6)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.card_membership_rounded, color: Colors.white, size: size.width * 0.08),
            SizedBox(height: size.height * 0.015),
            Text('Issue New Membership Card', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: size.height * 0.005),
            Text('Link a new card to a customer. They can earn points and load balance.', style: TextStyle(fontSize: size.width * 0.03, color: Colors.white.withOpacity(0.8))),
          ]),
        ),
        SizedBox(height: size.height * 0.03),

        // Customer info
        Text('Customer Information', style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
        SizedBox(height: size.height * 0.015),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: Icon(Icons.person_outline_rounded, size: size.width * 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(fontSize: size.width * 0.036),
        ),
        SizedBox(height: size.height * 0.015),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number (optional)',
            prefixIcon: Icon(Icons.phone_outlined, size: size.width * 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(fontSize: size.width * 0.036),
        ),
        SizedBox(height: size.height * 0.04),

        // Card linking
        Text('Link Card', style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
        SizedBox(height: size.height * 0.015),
        GestureDetector(
          onTap: _simulateCardDetection,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.06),
            decoration: BoxDecoration(
              color: _isCardDetected ? AppColors.accent.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isCardDetected ? AppColors.accent : Colors.grey.shade300,
                width: _isCardDetected ? 2 : 1,
              ),
            ),
            child: Column(children: [
              Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                decoration: BoxDecoration(
                  color: _isCardDetected ? AppColors.accent.withOpacity(0.1) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isCardDetected ? Icons.check_circle_rounded : Icons.nfc_rounded,
                  size: size.width * 0.1,
                  color: _isCardDetected ? AppColors.accent : Colors.grey.shade400,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                _isCardDetected ? '✅ Card Detected' : 'Tap here to simulate card tap',
                style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600, color: _isCardDetected ? AppColors.accent : Colors.grey.shade600),
              ),
              if (_isCardDetected) ...[
                SizedBox(height: size.height * 0.015),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.012),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                  child: Text('UID: $_cardUid',
                      style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.primary)),
                ),
                SizedBox(height: size.height * 0.015),
                Text('Starting Balance: \$0.00 | Points: 0',
                    style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade600)),
              ],
            ]),
          ),
        ),

        SizedBox(height: size.height * 0.04),

        // Issue button
        SizedBox(
          width: double.infinity,
          height: size.height * 0.065,
          child: ElevatedButton.icon(
            onPressed: (_isCardDetected && _nameController.text.isNotEmpty) ? _issueCard : null,
            icon: Icon(Icons.card_membership_rounded, size: size.width * 0.05),
            label: Text('ISSUE CARD', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ]),
    );
  }

  // ==================== TAB 2: TOP UP ====================
  Widget _buildTopUpTab(Size size) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.add_card_rounded, color: Colors.white, size: size.width * 0.08),
            SizedBox(height: size.height * 0.015),
            Text('Top Up Card Balance', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: size.height * 0.005),
            Text('Add money to an existing membership card', style: TextStyle(fontSize: size.width * 0.03, color: Colors.white.withOpacity(0.8))),
          ]),
        ),
        SizedBox(height: size.height * 0.03),

        // Card lookup
        Text('Find Card', style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
        SizedBox(height: size.height * 0.015),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _topUpCardController,
              decoration: InputDecoration(
                hintText: 'Enter card number (e.g., MEM00123456)',
                prefixIcon: Icon(Icons.credit_card_rounded, size: size.width * 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(fontSize: size.width * 0.033),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          ElevatedButton(
            onPressed: _lookupCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(size.height * 0.06, size.height * 0.06),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Icon(Icons.search_rounded, size: size.width * 0.05),
          ),
        ]),
        SizedBox(height: size.height * 0.015),
        Text('Or tap the card on the reader', style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
        SizedBox(height: size.height * 0.01),
        GestureDetector(
          onTap: () {
            _simulateTopUpCardDetection();
            if (_isTopUpCardDetected) {
              _topUpCardController.text = 'MEM00123456';
              _lookupCard();
            } else {
              _topUpCardController.clear();
              setState(() => _foundCustomer = null);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: _isTopUpCardDetected ? AppColors.primary.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isTopUpCardDetected ? AppColors.primary : Colors.grey.shade300, width: _isTopUpCardDetected ? 2 : 1),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.nfc_rounded, size: size.width * 0.06, color: _isTopUpCardDetected ? AppColors.primary : Colors.grey.shade400),
              SizedBox(width: size.width * 0.03),
              Text(_isTopUpCardDetected ? '✅ Card Tapped!' : 'Simulate card tap', style: TextStyle(fontSize: size.width * 0.033, color: _isTopUpCardDetected ? AppColors.primary : Colors.grey.shade500)),
            ]),
          ),
        ),

        SizedBox(height: size.height * 0.03),

        // Customer info card
        if (_foundCustomer != null) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
            ),
            child: Column(children: [
              Row(children: [
                Container(
                  width: size.width * 0.12, height: size.width * 0.12,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(_foundCustomer!.name[0].toUpperCase(), style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold, color: AppColors.primary))),
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_foundCustomer!.name, style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.005),
                  Text('Card: ${_foundCustomer!.cardNumber}', style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade600, fontFamily: 'monospace')),
                ])),
              ]),
              SizedBox(height: size.height * 0.02),
              Row(children: [
                _buildInfoChip(size, '💰', 'Balance', Formatters.currency(_foundCustomer!.balance), AppColors.accent),
                SizedBox(width: size.width * 0.03),
                _buildInfoChip(size, '⭐', 'Points', '${_foundCustomer!.points}', const Color(0xFFF39C12)),
                SizedBox(width: size.width * 0.03),
                _buildInfoChip(size, '🛒', 'Visits', '${_foundCustomer!.visits}', AppColors.reading),
              ]),
            ]),
          ),
          SizedBox(height: size.height * 0.03),

          // Top up amount
          Text('Amount to Add', style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.015),
          // Quick amounts
          Wrap(spacing: size.width * 0.03, runSpacing: size.width * 0.03, children: [10.0, 20.0, 50.0, 100.0].map((amount) {
            final isSelected = _topUpAmount == amount;
            return GestureDetector(
              onTap: () {
                _topUpAmountController.text = amount.toStringAsFixed(0);
                setState(() => _topUpAmount = amount);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.015),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                ),
                child: Text(Formatters.currency(amount), style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary)),
              ),
            );
          }).toList()),
          SizedBox(height: size.height * 0.015),
          TextField(
            controller: _topUpAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Custom Amount',
              prefixText: '\$ ',
              prefixIcon: Icon(Icons.money_rounded, size: size.width * 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
            onChanged: (v) => setState(() => _topUpAmount = double.tryParse(v) ?? 0),
          ),
          SizedBox(height: size.height * 0.015),

          // New balance preview
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('New Balance', style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey.shade700)),
              Text(Formatters.currency(_foundCustomer!.balance + _topUpAmount), style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: AppColors.accent)),
            ]),
          ),
          SizedBox(height: size.height * 0.03),

          // Process button
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton.icon(
              onPressed: _topUpAmount > 0 ? _processTopUp : null,
              icon: Icon(Icons.check_rounded, size: size.width * 0.05),
              label: Text('CONFIRM TOP UP', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  // ==================== TAB 3: ALL CARDS ====================
// ==================== TAB 3: ALL CARDS (Full Management) ====================
  Widget _buildAllCardsTab(Size size) {
    return Column(
      children: [
        // Search bar
        Container(
          padding: EdgeInsets.all(size.width * 0.04),
          color: Colors.white,
          child: TextField(
            onChanged: (v) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by name or card number...',
              prefixIcon: Icon(Icons.search_rounded, size: size.width * 0.05),
              suffixIcon: Icon(Icons.filter_list_rounded, size: size.width * 0.05, color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.015),
            ),
            style: TextStyle(fontSize: size.width * 0.035),
          ),
        ),

        // Cards list
        Expanded(
          child: _existingCards.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card_off_rounded,
                    size: size.width * 0.15, color: Colors.grey.shade300),
                SizedBox(height: size.height * 0.02),
                Text('No cards issued yet',
                    style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.grey.shade500)),
                SizedBox(height: size.height * 0.01),
                Text('Go to "Issue New" tab to create cards',
                    style: TextStyle(
                        fontSize: size.width * 0.03,
                        color: Colors.grey.shade400)),
              ],
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(size.width * 0.04),
            itemCount: _existingCards.length,
            itemBuilder: (context, index) {
              final card = _existingCards[index];
              return _buildCardTile(card, size);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardTile(_DemoCustomer card, Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(size.width * 0.04),
        childrenPadding: EdgeInsets.fromLTRB(
            size.width * 0.04, 0, size.width * 0.04, size.width * 0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        leading: Container(
          width: size.width * 0.11,
          height: size.width * 0.11,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF8B7CF6)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Icon(Icons.card_membership_rounded,
                  color: Colors.white, size: size.width * 0.05)),
        ),
        title: Text(card.name,
            style: TextStyle(
                fontSize: size.width * 0.034, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * 0.004),
            Text(card.cardNumber,
                style: TextStyle(
                    fontSize: size.width * 0.024,
                    color: Colors.grey.shade500,
                    fontFamily: 'monospace')),
            SizedBox(height: size.height * 0.006),
            // FIXED: Use Wrap instead of Row to prevent overflow
            Wrap(
              spacing: size.width * 0.02,
              runSpacing: size.height * 0.005,
              children: [
                _buildMiniBadge(size, '💰',
                    Formatters.currency(card.balance), AppColors.accent),
                _buildMiniBadge(
                    size, '⭐', '${card.points} pts', const Color(0xFFF39C12)),
                _buildMiniBadge(
                    size, '🛒', '${card.visits} visits', AppColors.reading),
              ],
            ),
          ],
        ),
        children: [
          Container(height: 1, color: Colors.grey.shade200),
          SizedBox(height: size.height * 0.015),
          _buildDetailRow(size, Icons.person_outline, 'Name', card.name),
          SizedBox(height: size.height * 0.008),
          _buildDetailRow(size, Icons.credit_card, 'Card Number', card.cardNumber),
          SizedBox(height: size.height * 0.008),
          _buildDetailRow(size, Icons.account_balance_wallet, 'Balance',
              Formatters.currency(card.balance)),
          SizedBox(height: size.height * 0.008),
          _buildDetailRow(size, Icons.star_outline, 'Loyalty Points', '${card.points}'),
          SizedBox(height: size.height * 0.008),
          _buildDetailRow(size, Icons.shopping_bag_outlined, 'Total Visits', '${card.visits}'),
          SizedBox(height: size.height * 0.015),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _topUpCardController.text = card.cardNumber;
                  setState(() => _foundCustomer = card);
                  _tabController.animateTo(1);
                },
                icon: Icon(Icons.add_card_rounded, size: size.width * 0.035),
                label: Text('TOP UP', style: TextStyle(fontSize: size.width * 0.026)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  minimumSize: Size.zero,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showReplaceCardDialog(card, size),
                icon: Icon(Icons.swap_horiz_rounded, size: size.width * 0.035),
                label: Text('REPLACE', style: TextStyle(fontSize: size.width * 0.026)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  minimumSize: Size.zero,
                ),
              ),
            ),
          ]),
          SizedBox(height: size.height * 0.008),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _deleteCard(card),
              icon: Icon(Icons.delete_outline_rounded, size: size.width * 0.035),
              label: Text('DELETE CARD', style: TextStyle(fontSize: size.width * 0.026)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(Size size, String emoji, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02, vertical: size.height * 0.004),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: TextStyle(fontSize: size.width * 0.03)),
        SizedBox(width: size.width * 0.01),
        Text(value,
            style: TextStyle(
                fontSize: size.width * 0.026,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }

  Widget _buildDetailRow(Size size, IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: size.width * 0.04, color: Colors.grey.shade500),
      SizedBox(width: size.width * 0.03),
      Text('$label: ',
          style: TextStyle(
              fontSize: size.width * 0.03, color: Colors.grey.shade600)),
      Expanded(
          child: Text(value,
              style: TextStyle(
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.w500))),
    ]);
  }

// ==================== REPLACE CARD DIALOG ====================
  void _showReplaceCardDialog(_DemoCustomer oldCard, Size size) {
    String newCardUid = 'MEM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    bool isNewCardDetected = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning icon
                  Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle),
                    child: Center(
                        child: Icon(Icons.swap_horiz_rounded,
                            size: size.width * 0.08,
                            color: Colors.orange.shade700)),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text('Replace Card',
                      style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'This will deactivate the old card and transfer all data to a new card.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: size.width * 0.03, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Old card info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.03),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      Text('OLD CARD',
                          style: TextStyle(
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error)),
                      SizedBox(height: size.height * 0.005),
                      Text(oldCard.cardNumber,
                          style: TextStyle(
                              fontSize: size.width * 0.03,
                              fontFamily: 'monospace',
                              decoration: TextDecoration.lineThrough,
                              color: Colors.red.shade700)),
                      Text('${oldCard.name}',
                          style: TextStyle(
                              fontSize: size.width * 0.028,
                              color: Colors.grey.shade600)),
                    ]),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Arrow down
                  Icon(Icons.arrow_downward_rounded,
                      size: size.width * 0.06, color: AppColors.accent),
                  SizedBox(height: size.height * 0.02),

                  // New card
                  GestureDetector(
                    onTap: () => setDialogState(() {
                      isNewCardDetected = !isNewCardDetected;
                      if (!isNewCardDetected) {
                        newCardUid = 'MEM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                      }
                    }),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: isNewCardDetected
                            ? AppColors.accent.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isNewCardDetected
                                ? AppColors.accent
                                : Colors.grey.shade300,
                            width: isNewCardDetected ? 2 : 1),
                      ),
                      child: Column(children: [
                        Icon(
                            isNewCardDetected
                                ? Icons.check_circle_rounded
                                : Icons.nfc_rounded,
                            size: size.width * 0.08,
                            color: isNewCardDetected
                                ? AppColors.accent
                                : Colors.grey.shade400),
                        SizedBox(height: size.height * 0.01),
                        Text(
                            isNewCardDetected
                                ? 'NEW CARD DETECTED'
                                : 'Tap New Card Here',
                            style: TextStyle(
                                fontSize: size.width * 0.033,
                                fontWeight: FontWeight.w600,
                                color: isNewCardDetected
                                    ? AppColors.accent
                                    : Colors.grey.shade500)),
                        if (isNewCardDetected) ...[
                          SizedBox(height: size.height * 0.01),
                          Text(newCardUid,
                              style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary)),
                        ],
                      ]),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Transfer info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.03),
                    decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Text('Data to transfer:',
                          style: TextStyle(
                              fontSize: size.width * 0.026,
                              color: Colors.grey.shade600)),
                      SizedBox(height: size.height * 0.005),
                      Text(
                          'Balance: ${Formatters.currency(oldCard.balance)} | Points: ${oldCard.points} | Visits: ${oldCard.visits}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.width * 0.028,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ]),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.016),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text('CANCEL',
                            style: TextStyle(fontSize: size.width * 0.033)),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isNewCardDetected
                            ? () {
                          // Replace the card
                          final index = _existingCards
                              .indexWhere((c) => c.cardNumber == oldCard.cardNumber);
                          if (index != -1) {
                            final newCard = _DemoCustomer(
                              cardNumber: newCardUid,
                              name: oldCard.name,
                              balance: oldCard.balance,
                              points: oldCard.points,
                              visits: oldCard.visits,
                            );
                            _existingCards[index] = newCard;
                          }
                          Get.back();
                          Get.snackbar('✅ Card Replaced!',
                              'New card $newCardUid issued to ${oldCard.name}\nOld card deactivated.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.accent,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 3),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12);
                          setState(() {});
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            disabledBackgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.white,
                            minimumSize: Size.zero,
                            padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.016),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text('REPLACE CARD',
                            style: TextStyle(
                                fontSize: size.width * 0.033,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteCard(_DemoCustomer card) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Card?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete this card?'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card: ${card.cardNumber}',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold)),
                  Text('Owner: ${card.name}'),
                  Text(
                      'Balance: ${Formatters.currency(card.balance)} | Points: ${card.points}'),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text('⚠️ This cannot be undone.',
                style: TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _existingCards
                    .removeWhere((c) => c.cardNumber == card.cardNumber);
              });
              Get.back();
              Get.snackbar('🗑️ Card Deleted',
                  'Card ${card.cardNumber} has been removed.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: Text('DELETE',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(Size size, String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(emoji, style: TextStyle(fontSize: size.width * 0.05)),
          SizedBox(height: size.height * 0.005),
          Text(value, style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }
}