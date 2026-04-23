import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phsar_kaksekor_app/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Supabase.initialize(
    url: 'https://iertierotcybdvsfvbsb.supabase.co',
    anonKey: 'sb_publishable_5Etnp-1sGsYkJiSyz_7Q1A_5v90v1_0'
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()..restoreSession()),
          // other providers
        ],
        child: const PsarKaksekorApp(),
      ),);
}
