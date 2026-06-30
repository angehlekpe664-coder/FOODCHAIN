import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'cart_screen.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double priceCfa;
  final String imageUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCfa,
    required this.imageUrl,
  });
}

class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // Mock Menu Items
    final List<MenuItemModel> menuItems = [
      MenuItemModel(
        id: "menu_1",
        name: "Pan-Seared Atlantic Salmon",
        description: "Sautéed asparagus, garlic potato purée, citrus butter glaze.",
        priceCfa: 14500.0,
        imageUrl: "https://images.unsplash.com/photo-1485921325814-a532d8f49d7f?w=400",
      ),
      MenuItemModel(
        id: "menu_2",
        name: "Beef Carpaccio Truffle",
        description: "Thinly sliced beef tenderloin, wild arugula, parmigiano, truffle oil.",
        priceCfa: 12800.0,
        imageUrl: "https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
      ),
      MenuItemModel(
        id: "menu_3",
        name: "Chocolate Lava Decadence",
        description: "Molten dark chocolate core, madagascar vanilla bean gelato.",
        priceCfa: 6500.0,
        imageUrl: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400",
      ),
    ];

    int cartItemCount = state.cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(decoration: const BoxDecoration(gradient: FoodChainTheme.creamGradient)),

          // Scrollable Content
          CustomScrollView(
            slivers: [
              // Top Cover Image & Banner
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: FoodChainTheme.bgCreamEnd,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: FoodChainTheme.darkCharcoal),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: FoodChainTheme.darkCharcoal),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/images/artiste_gourmet.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Restaurant Info Overlay Header
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "L'Artiste Gourmet",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: FoodChainTheme.darkCharcoal,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: FoodChainTheme.inputBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.star, color: Colors.orange, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "4.8 (128)",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: FoodChainTheme.darkCharcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Exquisite French culinary fusion and premium African delicacies with native Lightning network integration.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: FoodChainTheme.greyText.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // delivery metrics row
                      Row(
                        children: [
                          Icon(Icons.access_time_filled, color: Colors.grey.shade400, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "25-35 min",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Icon(Icons.location_on, color: Colors.grey.shade400, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "1.2 km",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Icon(Icons.delivery_dining, color: Colors.grey.shade400, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Free Delivery",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Items List Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = menuItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.01),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Item Detail
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: FoodChainTheme.darkCharcoal,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: FoodChainTheme.greyText.withOpacity(0.85),
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatPrice(state, item.priceCfa),
                                            style: const TextStyle(
                                              fontFamily: 'Outfit',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: FoodChainTheme.accentBrownText,
                                            ),
                                          ),
                                          // Add to cart capsule button
                                          GestureDetector(
                                            onTap: () {
                                              state.addToCart(
                                                item.id,
                                                item.name,
                                                item.description,
                                                item.priceCfa,
                                                item.imageUrl,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("${item.name} added to cart"),
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: FoodChainTheme.primaryOrange,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                "+ Add",
                                                style: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: FoodChainTheme.primaryOrange,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Item Thumbnail image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.fastfood, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate()
                          .fadeIn(delay: (index * 80).ms, duration: 400.ms)
                          .slideX(begin: 0.05, end: 0, curve: Curves.easeOutQuad);
                    },
                    childCount: menuItems.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Sticky View Cart Banner on bottom if items are in cart
          if (cartItemCount > 0)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: FoodChainTheme.primaryOrange,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: FoodChainTheme.primaryOrange.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cartItemCount.toString(),
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "View Cart",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatPrice(state, state.cartSubtotalCfa),
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
            ),
        ],
      ),
    );
  }

  String _formatPrice(AppState state, double amountCfa) {
    if (state.useCfa) {
      return "${amountCfa.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} CFA";
    } else {
      // Convert to Sats
      final sats = state.convertCfaToSats(amountCfa);
      if (sats >= 1000) {
        return "${(sats / 1000).toStringAsFixed(1)}k Sats";
      }
      return "$sats Sats";
    }
  }
}
