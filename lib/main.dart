import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ejrmrgflrgbmuyusionm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqcm1yZ2ZscmdibXV5dXNpb25tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4NTQ1MjAsImV4cCI6MjA5ODQzMDUyMH0.Q_IGEtrcmB2dHVmY7ylF3PozweSUvmfqasaT7R6r4SY',
  );

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
