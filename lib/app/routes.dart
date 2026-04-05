import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/screens/buyers/buyer_home_screen.dart';
import 'package:phsar_kaksekor_app/screens/buyers/browse_screen.dart';
import 'package:phsar_kaksekor_app/screens/buyers/cart_screen.dart';
import 'package:phsar_kaksekor_app/screens/buyers/buyer_profile_screen.dart';
import 'package:phsar_kaksekor_app/screens/seller/seller_dashboard_screen.dart';
import 'package:phsar_kaksekor_app/screens/seller/seller_profile_screen.dart';

const String routeBuyerHome     = '/';
const String routeBrowse        = '/buyer/browse';
const String routeCart          = '/buyer/cart';
const String routeBuyerProfile  = '/buyer/profile';
const String routeSellerDash    = '/seller/dashboard';
const String routeSellerProfile = '/seller/profile';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routeBuyerHome:
      return MaterialPageRoute(builder: (_) => const BuyerHomeScreen());
    case routeBrowse:
      return MaterialPageRoute(builder: (_) => const BrowseScreen());
    case routeCart:
      return MaterialPageRoute(builder: (_) => const CartScreen());
    case routeBuyerProfile:
      return MaterialPageRoute(builder: (_) => const BuyerProfileScreen());
    case routeSellerDash:
      return MaterialPageRoute(builder: (_) => const SellerDashboardScreen());
    case routeSellerProfile:
      return MaterialPageRoute(builder: (_) => const SellerProfileScreen());
    default:
      return MaterialPageRoute(builder: (_) => const BuyerHomeScreen());
  }
}