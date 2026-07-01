import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'payment_success_screen.dart';

class CompletePaymentScreen extends StatefulWidget {
  final String paymentMethod;
  const CompletePaymentScreen({Key? key, required this.paymentMethod}) : super(key: key);

  @override
  State<CompletePaymentScreen> createState() => _CompletePaymentScreenState();
}

class _CompletePaymentScreenState extends State<CompletePaymentScreen> {
  // Lightning countdown timer
  int _secondsRemaining = 300; // 5 minutes
  Timer? _timer;
  bool _isProcessing = false;
  final _phoneController = TextEditingController(text: "+221 77 123 45 67");
  String _selectedCarrier = "Wave";

  // Supabase states
  bool _isLoadingPayment = true;
  String _paymentUrl = "";
  String _orderId = "";
  RealtimeChannel? _realtimeChannel;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod == "Lightning" || widget.paymentMethod == "Bitcoin") {
      _startCountdown();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiatePayment();
    });
  }

  void _initiatePayment() async {
    final state = Provider.of<AppState>(context, listen: false);
    setState(() {
      _isLoadingPayment = true;
    });

    final paymentData = await state.createRealPayment(widget.paymentMethod);

    if (paymentData != null && paymentData['success'] == true) {
      setState(() {
        _orderId = paymentData['orderId'] ?? "";
        _paymentUrl = paymentData['paymentUrl'] ?? "";
        _isLoadingPayment = false;
      });

      // Souscrire aux modifications en direct pour cette commande spécifique
      _realtimeChannel = state.subscribeToOrder(_orderId, (status) {
        if (status == "paid") {
          if (!mounted) return;
          state.registerPaidOrder(_orderId, widget.paymentMethod, state.cartTotalCfa);
          state.clearCart();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
            (route) => route.isFirst,
          );
        }
      });
    } else {
      setState(() {
        _isLoadingPayment = false;
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _launchPaymentUrl() async {
    if (_paymentUrl.isNotEmpty) {
      final uri = Uri.parse(_paymentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    if (_realtimeChannel != null) {
      Supabase.instance.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _simulateSuccessfulPayment(AppState state) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Appeler l'Edge Function izichange-webhook pour simuler le retour d'IzichangePay
      await Supabase.instance.client.functions.invoke(
        'izichange-webhook',
        body: {
          'event': 'payment_intent.completed',
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'data': {
            'intentId': 'simulated_intent_${_orderId}',
            'merchantReference': _orderId,
            'status': 'completed',
            'amountRequested': state.cartTotalCfa.toString(),
            'currencyRequested': 'XOF',
          }
        }
      );
    } catch (e) {
      debugPrint("Erreur lors de la simulation du webhook: $e");
      // Fallback local direct
      state.registerPaidOrder(_orderId, widget.paymentMethod, state.cartTotalCfa);
      state.clearCart();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
        (route) => route.isFirst,
      );
    }
  }

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
                    Expanded(
                      child: Center(
                        child: Text(
                          _getScreenTitle(),
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: FoodChainTheme.darkCharcoal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Main Payment Screen Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Restaurant details block
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "L'Artiste Gourmet",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: FoodChainTheme.darkCharcoal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Amount to Pay: ${_formatPrice(state, state.cartTotalCfa)}",
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: FoodChainTheme.accentBrownText,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 50.ms, duration: 300.ms),
                      const SizedBox(height: 24),

                      // Conditional layout based on payment method
                      _buildPaymentContent(state),
                    ],
                  ),
                ),
              ),

              // Simulation Button footer
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _simulateSuccessfulPayment(state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FoodChainTheme.primaryOrange,
                      elevation: 4,
                      shadowColor: FoodChainTheme.primaryOrange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _getButtonText(),
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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

  String _getScreenTitle() {
    switch (widget.paymentMethod) {
      case "Lightning":
        return "Lightning Invoice";
      case "Mobile Money":
        return "Mobile Money Checkout";
      default:
        return "Bitcoin On-Chain";
    }
  }

  String _getButtonText() {
    switch (widget.paymentMethod) {
      case "Lightning":
        return "Simulate Wallet Payment";
      case "Mobile Money":
        return "Simulate Prompt Approval";
      default:
        return "Simulate On-Chain Block";
    }
  }

  Widget _buildPaymentContent(AppState state) {
    if (_isLoadingPayment) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: FoodChainTheme.primaryOrange),
              SizedBox(height: 24),
              Text(
                "Génération du paiement IzichangePay...",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  color: FoodChainTheme.greyText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.paymentMethod == "Lightning") {
      // Mock invoice string representation
      final invoiceString = _paymentUrl.isNotEmpty ? _paymentUrl : "lnbc238u1p3x9wjspp5y...d7shw7s292ldns72gfh3k328hjl28x";
      
      return Column(
        children: [
          // QR Code Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: QrImageView(
              data: invoiceString,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: FoodChainTheme.darkCharcoal,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: FoodChainTheme.darkCharcoal,
              ),
            ),
          ).animate().scale(duration: 300.ms),
          const SizedBox(height: 16),

          // Expiry Countdown Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 16, color: FoodChainTheme.greyText),
              const SizedBox(width: 6),
              Text(
                "Invoice expires in ${_formatTimer(_secondsRemaining)}",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: FoodChainTheme.greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action buttons: Copy & Share
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invoice string copied!")),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16, color: FoodChainTheme.darkCharcoal),
                  label: const Text(
                    "Copy Invoice",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: FoodChainTheme.darkCharcoal,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 16, color: FoodChainTheme.darkCharcoal),
                  label: const Text(
                    "Share Invoice",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: FoodChainTheme.darkCharcoal,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (widget.paymentMethod == "Mobile Money") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_paymentUrl.isNotEmpty && !_paymentUrl.startsWith("https://mock.foodchain.com")) ...[
            ElevatedButton.icon(
              onPressed: _launchPaymentUrl,
              icon: const Icon(Icons.open_in_browser, color: Colors.white),
              label: const Text(
                "Payer sur IzichangePay",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: FoodChainTheme.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "OU",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  color: FoodChainTheme.greyText,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Carrier selector row
                const Text(
                  "Choose Carrier",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: FoodChainTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildCarrierButton("Wave", isSelected: _selectedCarrier == "Wave"),
                    const SizedBox(width: 12),
                    _buildCarrierButton("Orange", isSelected: _selectedCarrier == "Orange"),
                    const SizedBox(width: 12),
                    _buildCarrierButton("MTN", isSelected: _selectedCarrier == "MTN"),
                  ],
                ),
                const SizedBox(height: 24),

                // Phone field
                const Text(
                  "Mobile Money Phone Number",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: FoodChainTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: FoodChainTheme.inputBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: FoodChainTheme.secondaryBrown,
                        size: 20,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 16),
          // helper notice info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF8F3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF9ECE0), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: FoodChainTheme.primaryOrange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "You will receive an automatic push prompt on your mobile device to authorize this payment request.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: FoodChainTheme.greyText.withOpacity(0.9),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // On-Chain Bitcoin
      final address = _paymentUrl.isNotEmpty ? _paymentUrl : "bc1q9x4y2u88jshw77s292ldns72gfh3k328hjl28x";
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: QrImageView(
              data: address,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: FoodChainTheme.darkCharcoal,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: FoodChainTheme.darkCharcoal,
              ),
            ),
          ).animate().scale(duration: 300.ms),
          const SizedBox(height: 16),

          // warnings banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FoodChainTheme.dangerBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade100, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: FoodChainTheme.dangerRed, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Ensure you send exact funds. Bitcoin on-chain payments require 1 confirmation.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.red.shade800,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // address label
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Address copied to clipboard!")),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: FoodChainTheme.inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.currency_bitcoin, color: FoodChainTheme.primaryOrange, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: FoodChainTheme.darkCharcoal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.copy, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCarrierButton(String carrier, {required bool isSelected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCarrier = carrier;
          });
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFEF2E6) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FoodChainTheme.primaryOrange : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              carrier,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? FoodChainTheme.primaryOrange : FoodChainTheme.darkCharcoal,
              ),
            ),
          ),
        ),
      ),
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
