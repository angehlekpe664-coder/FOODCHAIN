import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // Dynamic calculations from app state
    final balanceBtc = state.walletBalanceBtc;
    final balanceCfa = balanceBtc * state.btcPriceCfa;
    final balanceUsd = balanceBtc * state.btcPriceUsd;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: FoodChainTheme.creamGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Location Header
                  Row(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deliver to",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: FoodChainTheme.greyText.withOpacity(0.8),
                                ),
                              ),
                              const Text(
                                "Downtown, Dakar",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 20),

                  // Total Balance Card (Wallet mockup style)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey.shade100, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL BALANCE",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: FoodChainTheme.greyText.withOpacity(0.8),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF5EC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFF5E4D2), width: 1),
                              ),
                              child: const Text(
                                "BTC Mainnet",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B5E3C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              balanceBtc.toStringAsFixed(6),
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: FoodChainTheme.darkCharcoal,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              " BTC",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: FoodChainTheme.greyText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: FoodChainTheme.inputBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "≈ ${_formatCfa(balanceCfa)} CFA",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal.withOpacity(0.9),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: FoodChainTheme.inputBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "≈ USD \$${_formatUsd(balanceUsd)}",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate()
                      .fadeIn(delay: 50.ms, duration: 400.ms)
                      .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
                  const SizedBox(height: 20),

                  // Three buttons grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.south_west,
                          label: "Receive",
                          color: const Color(0xFF7A4B00),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.send_outlined,
                          label: "Send",
                          color: const Color(0xFF232323),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.flash_on,
                          label: "Lightning",
                          color: FoodChainTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                  const SizedBox(height: 20),

                  // Promos banner (Instant Lightning Payments)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF006B4D), // dark green
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006B4D).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Instant Lightning Payments",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Pay for groceries and local street food instantly with near-zero fees.",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF006B4D),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text("Get Started"),
                          ),
                        ),
                      ],
                    ),
                  ).animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
                  const SizedBox(height: 24),

                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: FoodChainTheme.darkCharcoal,
                        ),
                      ),
                      Text(
                        "View all >",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: FoodChainTheme.secondaryBrown,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
                  const SizedBox(height: 16),

                  // Transactions list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final tx = state.transactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Icon Circle
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _getTxBg(tx.title),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getTxIcon(tx.title),
                                    color: _getTxColor(tx.title),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.title,
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: FoodChainTheme.darkCharcoal,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        tx.date,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: FoodChainTheme.greyText.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Amount & Status
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${tx.amountBtc > 0 ? '+' : ''}${tx.amountBtc.toStringAsFixed(5)} BTC",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: tx.amountBtc > 0
                                            ? FoodChainTheme.successGreen
                                            : FoodChainTheme.darkCharcoal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(tx.status),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          tx.status,
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(tx.status),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate()
                          .fadeIn(delay: (index * 50).ms, duration: 300.ms)
                          .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bottom Metrics Row (Monthly spent & Savings)
                  Row(
                    children: [
                      // Monthly Spent Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EFE9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MONTHLY SPENT",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: FoodChainTheme.greyText.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "0.0034 BTC",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // underline indicator bar
                              Container(
                                width: 56,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7A4B00),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Fee Savings Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EFE9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "FEE SAVINGS",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: FoodChainTheme.greyText.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "4.2k Sats",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.successGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "via Lightning",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: FoodChainTheme.greyText.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color}) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTxIcon(String title) {
    if (title.contains("Grill") || title.contains("Gourmet") || title.contains("Order")) {
      return Icons.restaurant;
    } else if (title.contains("Received")) {
      return Icons.account_balance_wallet;
    } else if (title.contains("Central")) {
      return Icons.shopping_cart;
    } else {
      return Icons.sync_alt;
    }
  }

  Color _getTxColor(String title) {
    if (title.contains("Grill") || title.contains("Gourmet") || title.contains("Order")) {
      return const Color(0xFF006B4D);
    } else if (title.contains("Received")) {
      return const Color(0xFF7A4B00);
    } else if (title.contains("Central")) {
      return const Color(0xFF707070);
    } else {
      return const Color(0xFF8B5E3C);
    }
  }

  Color _getTxBg(String title) {
    if (title.contains("Grill") || title.contains("Gourmet") || title.contains("Order")) {
      return const Color(0xFFE6F3EF);
    } else if (title.contains("Received")) {
      return const Color(0xFFFAF2E8);
    } else if (title.contains("Central")) {
      return const Color(0xFFF2F2F2);
    } else {
      return const Color(0xFFF2EEEA);
    }
  }

  Color _getStatusColor(String status) {
    if (status == "Success" || status == "Confirmed") {
      return FoodChainTheme.successGreen;
    } else if (status.contains("Pending")) {
      return const Color(0xFFE88A1A);
    } else {
      return FoodChainTheme.dangerRed;
    }
  }

  String _formatCfa(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatUsd(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
