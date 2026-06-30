import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'complete_payment_screen.dart';

class ReviewOrderScreen extends StatefulWidget {
  const ReviewOrderScreen({Key? key}) : super(key: key);

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  String _selectedMethod = "Lightning"; // 'Lightning', 'Mobile Money', 'Bitcoin'

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

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
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: FoodChainTheme.darkCharcoal),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Review Order",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: FoodChainTheme.darkCharcoal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // spacer balance
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Scrollable Details
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    // Itemized Order Summary Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: FoodChainTheme.darkCharcoal,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...state.cartItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.quantity}x ${item.name}",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: FoodChainTheme.darkCharcoal.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _formatPrice(state, item.priceCfa * item.quantity),
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: FoodChainTheme.darkCharcoal,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(height: 24, thickness: 1),
                          _buildBillingDetailRow("Subtotal", state.cartSubtotalCfa, state),
                          const SizedBox(height: 8),
                          _buildBillingDetailRow("Delivery Fee", state.deliveryFeeCfa, state),
                          const SizedBox(height: 12),
                          const Divider(height: 1, thickness: 1.5),
                          const SizedBox(height: 12),
                          _buildBillingDetailRow("Total", state.cartTotalCfa, state, isTotal: true),
                        ],
                      ),
                    ).animate().fadeIn(delay: 50.ms, duration: 350.ms),
                    const SizedBox(height: 20),

                    // Payment Method Header
                    Text(
                      "Select Payment Method",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: FoodChainTheme.darkCharcoal,
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                    const SizedBox(height: 14),

                    // Payment Selection Cards
                    _buildPaymentMethodCard(
                      id: "Lightning",
                      title: "Lightning Network",
                      subtitle: "Instant confirmation • Near-zero fees",
                      icon: Icons.flash_on,
                      badge: "RECOMMENDED",
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethodCard(
                      id: "Mobile Money",
                      title: "Mobile Money (Wave/Orange)",
                      subtitle: "Local carrier authentication",
                      icon: Icons.phone_android,
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethodCard(
                      id: "Bitcoin",
                      title: "Bitcoin On-Chain",
                      subtitle: "10-30 mins confirmation time",
                      icon: Icons.currency_bitcoin,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Bottom Proceed Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CompletePaymentScreen(paymentMethod: _selectedMethod),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FoodChainTheme.primaryOrange,
                      elevation: 4,
                      shadowColor: FoodChainTheme.primaryOrange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Proceed to Payment",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ).animate().slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    String? badge,
  }) {
    final isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? FoodChainTheme.primaryOrange : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFEF2E6) : FoodChainTheme.inputBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? FoodChainTheme.primaryOrange : FoodChainTheme.greyText,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: FoodChainTheme.darkCharcoal,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: FoodChainTheme.successGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "RECOMMENDED",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: FoodChainTheme.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: FoodChainTheme.greyText.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),

            // Radio Bullet
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? FoodChainTheme.primaryOrange : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: FoodChainTheme.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: 150.ms, duration: 300.ms)
        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildBillingDetailRow(String label, double amountCfa, AppState state, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? FoodChainTheme.darkCharcoal : FoodChainTheme.greyText,
          ),
        ),
        Text(
          _formatPrice(state, amountCfa),
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? FoodChainTheme.accentBrownText : FoodChainTheme.darkCharcoal,
          ),
        ),
      ],
    );
  }

  String _formatPrice(AppState state, double amountCfa) {
    if (state.useCfa) {
      return "${amountCfa.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} CFA";
    } else {
      final sats = state.convertCfaToSats(amountCfa);
      if (sats >= 1000) {
        return "${(sats / 1000).toStringAsFixed(1)}k Sats";
      }
      return "$sats Sats";
    }
  }
}
