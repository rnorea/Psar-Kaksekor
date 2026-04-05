import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/themes/app_theme.dart';
import 'routes.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/providers/cart_provider.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/user_provider.dart';

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
        onGenerateRoute: generateRoute,
        initialRoute: routeBuyerHome,
      ),
    );
  }
}