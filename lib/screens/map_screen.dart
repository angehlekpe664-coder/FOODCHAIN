import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme.dart';
import 'restaurant_menu_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _bitcoinOnly = true;

  // Center on Accra, Ghana as in mockup
  final LatLng _accraCenter = const LatLng(5.6037, -0.1870);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flutter Map with OpenStreetMap tiles
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _accraCenter,
              initialZoom: 13.5,
              maxZoom: 18.0,
              minZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  // Sats Grill Marker (Mockup: Fork & Knife Icon with Tooltip)
                  Marker(
                    point: const LatLng(5.6047, -0.1870),
                    width: 150,
                    height: 90,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const RestaurantMenuScreen()),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Sats Grill • 4.8",
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
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: FoodChainTheme.primaryOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pizza Marker
                  Marker(
                    point: const LatLng(5.5997, -0.1790),
                    width: 50,
                    height: 50,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBF7F3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.local_pizza_outlined,
                        color: FoodChainTheme.secondaryBrown,
                        size: 20,
                      ),
                    ),
                  ),
                  // Coffee / Bakery Marker
                  Marker(
                    point: const LatLng(5.5907, -0.1990),
                    width: 50,
                    height: 50,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBF7F3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.local_cafe_outlined,
                        color: FoodChainTheme.secondaryBrown,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Header Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: FoodChainTheme.primaryOrange,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "FoodChain",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: FoodChainTheme.darkCharcoal,
                            ),
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
                              color: Colors.black.withOpacity(0.06),
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
                  const SizedBox(height: 16),

                  // Horizontal Filters Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Bitcoin Only filter
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _bitcoinOnly = !_bitcoinOnly;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: _bitcoinOnly ? FoodChainTheme.primaryOrange : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.currency_bitcoin,
                                  color: _bitcoinOnly ? Colors.white : FoodChainTheme.primaryOrange,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Bitcoin Only",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _bitcoinOnly ? Colors.white : FoodChainTheme.darkCharcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Distance filter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "Distance",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: FoodChainTheme.darkCharcoal,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Cuisine filter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "Cuisine",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FoodChainTheme.darkCharcoal,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.close,
                                color: FoodChainTheme.darkCharcoal,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                ],
              ),
            ),
          ),

          // Floating Action Buttons on right side
          Positioned(
            bottom: 24,
            right: 20,
            child: Column(
              children: [
                // Locate Me Button
                FloatingActionButton(
                  heroTag: 'locate_btn',
                  onPressed: () {
                    _mapController.move(_accraCenter, 14.5);
                  },
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  mini: true,
                  child: const Icon(
                    Icons.my_location,
                    color: FoodChainTheme.darkCharcoal,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                // Layers Button
                FloatingActionButton(
                  heroTag: 'layers_btn',
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  mini: true,
                  child: const Icon(
                    Icons.layers_outlined,
                    color: FoodChainTheme.darkCharcoal,
                    size: 20,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
          ),
        ],
      ),
    );
  }
}
