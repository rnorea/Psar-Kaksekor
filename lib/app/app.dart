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

class PsarKaksekorApp extends StatelessWidget {
  const PsarKaksekorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create providers
    final authProvider    = AuthProvider();
    final cartProvider    = CartProvider();
    final productProvider = ProductProvider();
    final orderProvider   = OrderProvider();
    final userProvider    = UserProvider();

    // Seed dummy data
    seedMockData(
      productProvider: productProvider,
      orderProvider:   orderProvider,
      authProvider:    authProvider,
      userProvider:    userProvider,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider.value(value: productProvider),
        ChangeNotifierProvider.value(value: orderProvider),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: MaterialApp(
        title: 'Psar Kaksekor',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        onGenerateRoute: generateRoute,
        initialRoute: routeBuyerHome,
      ),
    );
  }
}
