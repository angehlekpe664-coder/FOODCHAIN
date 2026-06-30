import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: FoodChainTheme.creamGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Header
                  Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: FoodChainTheme.darkCharcoal,
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 24),

                  // Profile Header Info Card
                  Center(
                    child: Column(
                      children: [
                        // User Avatar
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FoodChainTheme.primaryOrange,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/user_profile_avatar.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Alex Sterling",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: FoodChainTheme.darkCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "FoodChain Explorer since Oct 2023",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: FoodChainTheme.greyText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Bitcoin Address Capsule
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(const ClipboardData(text: "bc1q9x4y2u88jshw77s292ldns72gfh3k328hjl28x"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Address copied to clipboard!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF5EC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF5E4D2), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.currency_bitcoin,
                                  color: FoodChainTheme.primaryOrange,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "bc1q9...8x4y",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: FoodChainTheme.darkCharcoal.withOpacity(0.85),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.copy,
                                  color: FoodChainTheme.greyText.withOpacity(0.6),
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate()
                      .fadeIn(delay: 50.ms, duration: 450.ms)
                      .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
                  const SizedBox(height: 32),

                  // Preferred Currency Toggle Card
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preferred Currency",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: FoodChainTheme.darkCharcoal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.useCfa ? "Pricing shown in CFA Franc" : "Pricing shown in BTC & Sats",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: FoodChainTheme.greyText,
                              ),
                            ),
                          ],
                        ),
                        // Premium Dual Sliding Switch
                        GestureDetector(
                          onTap: () {
                            state.setCurrencyMode(!state.useCfa);
                          },
                          child: Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FoodChainTheme.inputBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                // Sliding Background Highlight
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: state.useCfa ? Alignment.centerLeft : Alignment.centerRight,
                                  child: Container(
                                    width: 60,
                                    height: 36,
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: FoodChainTheme.primaryOrange,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: FoodChainTheme.primaryOrange.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Text options
                                Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "CFA",
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: state.useCfa ? Colors.white : FoodChainTheme.greyText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "BTC",
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: !state.useCfa ? Colors.white : FoodChainTheme.greyText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 20),

                  // Settings list container
                  Container(
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
                        _buildSettingItem(Icons.account_balance_wallet_outlined, "Linked Wallet"),
                        _buildDivider(),
                        _buildSettingItem(Icons.security_outlined, "Security & Backup"),
                        _buildDivider(),
                        _buildSettingItem(Icons.payment_outlined, "Payment Methods"),
                        _buildDivider(),
                        _buildSettingItem(Icons.help_outline, "Support & FAQs"),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                  const SizedBox(height: 24),

                  // Logout button
                  Container(
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
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const AuthScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                                color: FoodChainTheme.dangerRed,
                              ),
                              SizedBox(width: 14),
                              Text(
                                "Log Out",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.dangerRed,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: FoodChainTheme.greyText.withOpacity(0.8),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FoodChainTheme.darkCharcoal,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(
        height: 1,
        color: Colors.grey.shade100,
        thickness: 1,
      ),
    );
  }
}
