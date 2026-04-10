import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/themes/app_theme.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/providers/cart_provider.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/user_provider.dart';
import 'package:phsar_kaksekor_app/data/mock_data.dart';
import 'routes.dart';
import 'package:phsar_kaksekor_app/models/user_model.dart';
import 'package:phsar_kaksekor_app/screens/buyers/buyer_home_screen.dart';
import 'package:phsar_kaksekor_app/screens/seller/seller_dashboard_screen.dart';

class PsarKaksekorApp extends StatelessWidget {
  const PsarKaksekorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Psar Kaksekor',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const _RootScreen(),
      ),
    );
  }
}

class _RootScreen extends StatelessWidget {
  const _RootScreen();

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().activeRole;

    return role == UserRole.seller
        ? const SellerDashboardScreen()
        : const BuyerHomeScreen();
  }
}
