import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const FoodChainApp(),
    ),
  );
}

class FoodChainApp extends StatelessWidget {
  const FoodChainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodChain',
      debugShowCheckedModeBanner: false,
      theme: FoodChainTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
