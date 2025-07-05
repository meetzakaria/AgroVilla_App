import 'package:agrovilla/screens/auth/register_acreen.dart';
import 'package:agrovilla/screens/buyer/buyer_home_screen.dart';
import 'package:agrovilla/screens/seller/seller_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const AgroVillaApp());
}

class AgroVillaApp extends StatelessWidget {
  const AgroVillaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroVilla App',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      // home: SellerDashboardScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/buyerHome': (context) =>  BuyerHomeScreen(),
        '/sellerDashboard': (context) => const SellerDashboardScreen(),
      },
    );
  }
}
