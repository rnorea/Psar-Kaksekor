import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text, _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      final route = auth.activeRole == UserRole.seller
          ? routeSellerDash
          : routeBuyerHome;
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: colorOff,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // ── Logo / brand ────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colorDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🌿', style: TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Psar Kaksekor',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: colorDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fresh from farm to your door',
                      style: metaText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── Form ────────────────────────────────────────────────────
              Text('Welcome back 👋', style: titleMed),
              const SizedBox(height: 4),
              Text('Sign in to continue', style: bodySmall),
              const SizedBox(height: 22),

              // Email
              _FormLabel('Email'),
              const SizedBox(height: 5),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: inputText,
                decoration: _inputDecor('you@example.com',
                    prefixIcon: Icons.email_outlined),
              ),
              const SizedBox(height: 13),

              // Password
              _FormLabel('Password'),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                style: inputText,
                onSubmitted: (_) => _login(),
                decoration: _inputDecor('••••••••',
                    prefixIcon: Icons.lock_outline,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: colorG400,
                        size: 18,
                      ),
                    )),
              ),

              // Error
              if (auth.error != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAEA),
                    borderRadius: BorderRadius.circular(kRadiusInput),
                  ),
                  child: Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(auth.error!, style: bodySmall.copyWith(color: colorRed)),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 22),

              // Login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadiusBtn)),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 13),
                ),
                onPressed: auth.isLoading ? null : _login,
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Sign In'),
              ),

              const SizedBox(height: 16),

              // Demo accounts hint
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorPale,
                  borderRadius: BorderRadius.circular(kRadiusCard),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔑 Demo accounts', style: labelText),
                    const SizedBox(height: 6),
                    _demoRow('Buyer', 'vanuth@example.com'),
                    const SizedBox(height: 3),
                    _demoRow('Seller', 'sophea@greenvalley.kh'),
                    const SizedBox(height: 4),
                    Text('(any password works)', style: metaText),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: bodySmall),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().clearError();
                      Navigator.pushNamed(context, routeRegister);
                    },
                    child: Text(
                      'Register',
                      style: bodySmall.copyWith(
                        color: colorAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoRow(String role, String email) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: colorDark,
            borderRadius: BorderRadius.circular(kRadiusBadge),
          ),
          child: Text(role,
              style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  color: Colors.white)),
        ),
        const SizedBox(width: 7),
        Text(email, style: metaText.copyWith(color: colorG600)),
      ],
    );
  }

  InputDecoration _inputDecor(String hint,
      {IconData? prefixIcon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintText,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: colorG400, size: 18)
          : null,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusInput),
        borderSide: const BorderSide(color: colorG200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusInput),
        borderSide: const BorderSide(color: colorAccent, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: labelText);
  }
}