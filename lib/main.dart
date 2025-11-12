import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/initial_home_screen.dart';
import 'services/cart_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51RGXZPRUa9NyDGbuZGx7n03IXkEO7RVKhTchTZdkTo2AVOiqVYRziYPEBCT0zajYrY1a3BEmbjuBLbbpZJPzSzbm00hWaZ3znP';
  await Stripe.instance.applySettings();
  final cartService = CartService();
  await cartService.loadCartFromLocalStorage(); //  Cargar al inicio

  runApp(
    ChangeNotifierProvider.value(
      value: cartService,
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitialHomeScreen(),
    );
  }
}
