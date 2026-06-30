import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String description;
  final double priceCfa;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCfa,
    required this.imageUrl,
    this.quantity = 1,
  });

  CartItem copy() {
    return CartItem(
      id: id,
      name: name,
      description: description,
      priceCfa: priceCfa,
      imageUrl: imageUrl,
      quantity: quantity,
    );
  }
}

class TransactionItem {
  final String title;
  final String date;
  final double amountBtc;
  final String status; // 'Success', 'Confirmed', 'Pending'
  final bool isReceived;

  TransactionItem({
    required this.title,
    required this.date,
    required this.amountBtc,
    required this.status,
    this.isReceived = false,
  });
}

class OrderHistoryItem {
  final String id;
  final String restaurantName;
  final String date;
  final double amountCfa;
  final String paymentMethod; // 'Lightning', 'Mobile Money', 'Bitcoin'
  final String status; // 'Completed', 'Pending', 'Cancelled'
  final String imageUrl;

  OrderHistoryItem({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.amountCfa,
    required this.paymentMethod,
    required this.status,
    required this.imageUrl,
  });
}

class AppState extends ChangeNotifier {
  // Conversions
  double btcPriceUsd = 64231.50;
  double usdToCfa = 608.0;

  // Toggle for display
  bool useCfa = true;

  // Cart
  List<CartItem> cartItems = [];
  double deliveryFeeCfa = 1200.0;

  // Wallet
  double walletBalanceBtc = 0.024810;
  List<TransactionItem> transactions = [
    TransactionItem(
      title: "Mama Rose's Grill",
      date: "May 24 • Dinner",
      amountBtc: -0.00015,
      status: "Success",
    ),
    TransactionItem(
      title: "Received Bitcoin",
      date: "May 22 • P2P Deposit",
      amountBtc: 0.00500,
      status: "Confirmed",
      isReceived: true,
    ),
    TransactionItem(
      title: "Central Market Groceries",
      date: "May 21 • Weekly Supply",
      amountBtc: -0.00082,
      status: "Success",
    ),
    TransactionItem(
      title: "Withdrawal to External",
      date: "Just now • Mining Fee: 12 sats",
      amountBtc: -0.00120,
      status: "Pending...",
    ),
  ];

  // Orders
  List<OrderHistoryItem> orders = [
    OrderHistoryItem(
      id: "ord_1",
      restaurantName: "Burger House Elite",
      date: "Oct 24, 2023 • 14:20",
      amountCfa: 1500 * 608.0 / 100, // custom conversions
      paymentMethod: "Lightning",
      status: "Completed",
      imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400",
    ),
    OrderHistoryItem(
      id: "ord_2",
      restaurantName: "Zen Sushi Bar",
      date: "Oct 22, 2023 • 19:45",
      amountCfa: 18500.0,
      paymentMethod: "Mobile Money",
      status: "Completed",
      imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400",
    ),
    OrderHistoryItem(
      id: "ord_3",
      restaurantName: "Pasta & Basta",
      date: "Oct 18, 2023 • 12:30",
      amountCfa: 16500.0,
      paymentMethod: "Bitcoin",
      status: "Completed",
      imageUrl: "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400",
    ),
  ];

  // Conversion Helpers
  double get btcPriceCfa => btcPriceUsd * usdToCfa; // ~ 39,052,752 CFA
  
  double convertCfaToBtc(double cfa) {
    return cfa / btcPriceCfa;
  }

  int convertCfaToSats(double cfa) {
    return (convertCfaToBtc(cfa) * 100000000).round();
  }

  double convertCfaToUsd(double cfa) {
    return cfa / usdToCfa;
  }

  // Set Currency Toggle
  void setCurrencyMode(bool cfaMode) {
    useCfa = cfaMode;
    notifyListeners();
  }

  // Cart Operations
  void addToCart(String id, String name, String description, double priceCfa, String imageUrl) {
    int index = cartItems.indexWhere((element) => element.id == id);
    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(CartItem(
        id: id,
        name: name,
        description: description,
        priceCfa: priceCfa,
        imageUrl: imageUrl,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String id, int delta) {
    int index = cartItems.indexWhere((element) => element.id == id);
    if (index >= 0) {
      cartItems[index].quantity += delta;
      if (cartItems[index].quantity <= 0) {
        cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  double get cartSubtotalCfa {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.priceCfa * item.quantity;
    }
    return subtotal;
  }

  double get cartTotalCfa {
    if (cartItems.isEmpty) return 0;
    return cartSubtotalCfa + deliveryFeeCfa;
  }

  // Place Order Simulation
  void completePayment(String paymentMethod) {
    if (cartItems.isEmpty) return;

    double totalCfaPaid = cartTotalCfa;
    double totalBtcPaid = convertCfaToBtc(totalCfaPaid);

    // Subtract from balance
    walletBalanceBtc -= totalBtcPaid;

    // Add transaction to history
    transactions.insert(
      0,
      TransactionItem(
        title: "L'Artiste Gourmet",
        date: "Just now • Order Payment",
        amountBtc: -totalBtcPaid,
        status: "Success",
      ),
    );

    // Add order to history
    orders.insert(
      0,
      OrderHistoryItem(
        id: "ord_${DateTime.now().millisecondsSinceEpoch}",
        restaurantName: "L'Artiste Gourmet",
        date: "Just now",
        amountCfa: totalCfaPaid,
        paymentMethod: paymentMethod,
        status: "Completed",
        imageUrl: "https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
      ),
    );

    // Clear cart
    clearCart();
  }
}
