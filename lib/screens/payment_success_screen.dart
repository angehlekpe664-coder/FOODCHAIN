import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import 'main_navigation_holder.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: FoodChainTheme.creamGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Animated Bouncing Success Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: FoodChainTheme.successBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FoodChainTheme.successGreen.withOpacity(0.2),
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: FoodChainTheme.successGreen,
                      size: 64,
                    ),
                  ),
                ).animate()
                    .scale(duration: 400.ms, curve: Curves.bounceOut)
                    .fadeIn(duration: 200.ms),

                const SizedBox(height: 32),

                // Success Title & Text
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Payment Successful!",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: FoodChainTheme.darkCharcoal,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Your order from L'Artiste Gourmet has been placed and is being prepared.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: FoodChainTheme.greyText.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Transaction / Order Reference card details
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      _buildRefRow("Order Reference", "FC-9831A"),
                      const Divider(height: 24, thickness: 1),
                      _buildRefRow("Delivery Address", "Downtown, Dakar"),
                      const Divider(height: 24, thickness: 1),
                      _buildRefRow("Estimated Delivery", "25-35 mins"),
                    ],
                  ),
                ).animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),

                const Spacer(flex: 3),

                // Primary navigation buttons
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainNavigationHolder(initialIndex: 2), // Go to Orders tab
                        ),
                        (route) => false,
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
                    child: const Text(
                      "Track Order",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 300.ms),
                const SizedBox(height: 12),

                // Back to home button text
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainNavigationHolder(initialIndex: 0), // Go to Home tab
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: FoodChainTheme.darkCharcoal,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 550.ms, duration: 300.ms),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: FoodChainTheme.greyText,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: FoodChainTheme.darkCharcoal,
          ),
        ),
      ],
    );
  }
}
