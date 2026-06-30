import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final completedOrders = state.orders.where((o) => o.status == "Completed").toList();
    final pendingOrders = state.orders.where((o) => o.status == "Pending").toList();
    final cancelledOrders = state.orders.where((o) => o.status == "Cancelled").toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: FoodChainTheme.creamGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: FoodChainTheme.primaryOrange,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Orders",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: FoodChainTheme.darkCharcoal,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "FoodChain",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: FoodChainTheme.accentBrownText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        color: FoodChainTheme.darkCharcoal,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 12),

              // Filter Tab Bar Capsule
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE6DF),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: FoodChainTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: FoodChainTheme.greyText,
                    labelStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: "Completed"),
                      Tab(text: "Pending"),
                      Tab(text: "Cancelled"),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 50.ms, duration: 300.ms),
              const SizedBox(height: 16),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrdersList(completedOrders),
                    _buildOrdersList(pendingOrders),
                    _buildOrdersList(cancelledOrders),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderHistoryItem> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No orders found",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Restaurant Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      order.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Order Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.restaurantName,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: FoodChainTheme.darkCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.date,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: FoodChainTheme.greyText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentMethodBadge(order.paymentMethod),
                      ],
                    ),
                  ),

                  // Price & Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatPriceDisplay(order),
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: FoodChainTheme.darkCharcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.status == "Completed" ? "Delivered" : order.status,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: order.status == "Completed"
                              ? FoodChainTheme.greyText
                              : FoodChainTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate()
            .fadeIn(delay: (index * 50).ms, duration: 300.ms)
            .slideX(begin: 0.05, end: 0, curve: Curves.easeOutQuad);
      },
    );
  }

  Widget _buildPaymentMethodBadge(String method) {
    IconData icon;
    Color color;
    Color bg;
    
    if (method == "Lightning") {
      icon = Icons.flash_on;
      color = const Color(0xFFF28F1D);
      bg = const Color(0xFFFEF2E6);
    } else if (method == "Mobile Money") {
      icon = Icons.phone_android;
      color = const Color(0xFF8B5E3C);
      bg = const Color(0xFFF2EEEA);
    } else {
      icon = Icons.currency_bitcoin;
      color = const Color(0xFF7A4B00);
      bg = const Color(0xFFFAF2E8);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            method,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPriceDisplay(OrderHistoryItem order) {
    if (order.paymentMethod == "Lightning") {
      // Show in SATS
      final sats = (order.amountCfa / 608.0 / 64231.50 * 100000000).round();
      return "${_formatNumber(sats.toDouble())} SATS";
    } else if (order.paymentMethod == "Bitcoin") {
      // Show in BTC
      final btc = order.amountCfa / 608.0 / 64231.50;
      return "${btc.toStringAsFixed(5)} BTC";
    } else {
      // Show in CFA
      return "${_formatNumber(order.amountCfa)} CFA";
    }
  }

  String _formatNumber(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
