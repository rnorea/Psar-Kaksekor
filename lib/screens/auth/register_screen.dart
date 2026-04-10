import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../app/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _farmCtrl     = TextEditingController();
  final _produceCtrl  = TextEditingController();
  final _provinceCtrl = TextEditingController();

  UserRole _selectedRole = UserRole.buyer;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _farmCtrl.dispose();
    _produceCtrl.dispose();
    _provinceCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      name:        _nameCtrl.text,
      email:       _emailCtrl.text,
      password:    _passwordCtrl.text,
      role:        _selectedRole,
      farmName:    _selectedRole == UserRole.seller ? _farmCtrl.text : null,
      produceType: _selectedRole == UserRole.seller ? _produceCtrl.text : null,
      province:    _selectedRole == UserRole.seller ? _provinceCtrl.text : null,
    );
    if (!mounted) return;
    if (ok) {
      final route = _selectedRole == UserRole.seller
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
              const SizedBox(height: 16),

              // ── Back + title ───────────────────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      auth.clearError();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorG100,
                        borderRadius: BorderRadius.circular(kRadiusSmall),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 14, color: colorG600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Create Account', style: titleMed),
                ],
              ),

              const SizedBox(height: 24),

              // ── Role picker ───────────────────────────────────────────
              Text('I want to', style: labelText),
              const SizedBox(height: 8),
              Row(
                children: [
                  _RoleCard(
                    emoji: '🛒',
                    title: 'Buy',
                    subtitle: 'Shop fresh produce',
                    isSelected: _selectedRole == UserRole.buyer,
                    onTap: () => setState(() => _selectedRole = UserRole.buyer),
                  ),
                  const SizedBox(width: 10),
                  _RoleCard(
                    emoji: '🌾',
                    title: 'Sell',
                    subtitle: 'List my farm products',
                    isSelected: _selectedRole == UserRole.seller,
                    onTap: () => setState(() => _selectedRole = UserRole.seller),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ── Basic fields ──────────────────────────────────────────
              _FormGroup(
                label: 'Full Name *',
                child: TextField(
                  controller: _nameCtrl,
                  style: inputText,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecor('e.g. Vanuth Sok',
                      icon: Icons.person_outline),
                ),
              ),
              _FormGroup(
                label: 'Email *',
                child: TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: inputText,
                  decoration: _inputDecor('you@example.com',
                      icon: Icons.email_outlined),
                ),
              ),
              _FormGroup(
                label: 'Password *',
                child: TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  style: inputText,
                  decoration: _inputDecor('Min. 6 characters',
                      icon: Icons.lock_outline,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorG400,
                          size: 18,
                        ),
                      )),
                ),
              ),

              // ── Seller-only fields ────────────────────────────────────
              if (_selectedRole == UserRole.seller) ...[
                const Divider(color: colorG200, height: 24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Text('🌾', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text('Farm Details', style: labelText),
                    ],
                  ),
                ),
                _FormGroup(
                  label: 'Farm Name *',
                  child: TextField(
                    controller: _farmCtrl,
                    style: inputText,
                    decoration: _inputDecor('e.g. Green Valley Farm',
                        icon: Icons.storefront_outlined),
                  ),
                ),
                _FormGroup(
                  label: 'Produce Type',
                  child: TextField(
                    controller: _produceCtrl,
                    style: inputText,
                    decoration: _inputDecor('e.g. Vegetables & Herbs',
                        icon: Icons.grass_outlined),
                  ),
                ),
                _FormGroup(
                  label: 'Province',
                  child: TextField(
                    controller: _provinceCtrl,
                    style: inputText,
                    decoration: _inputDecor('e.g. Kampong Speu',
                        icon: Icons.location_on_outlined),
                  ),
                ),
              ],

              // ── Error ─────────────────────────────────────────────────
              if (auth.error != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAEA),
                    borderRadius: BorderRadius.circular(kRadiusInput),
                  ),
                  child: Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(auth.error!,
                            style: bodySmall.copyWith(color: colorRed)),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 22),

              // ── Register button ───────────────────────────────────────
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
                onPressed: auth.isLoading ? null : _register,
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(_selectedRole == UserRole.seller
                        ? '🌾 Create Seller Account'
                        : '🛒 Create Buyer Account'),
              ),

              const SizedBox(height: 16),

              // ── Login link ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: bodySmall),
                  GestureDetector(
                    onTap: () {
                      auth.clearError();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
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

  InputDecoration _inputDecor(String hint,
      {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintText,
      prefixIcon:
          icon != null ? Icon(icon, color: colorG400, size: 18) : null,
      suffixIcon: suffix,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

// ── Role card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorPale : Colors.white,
            border: Border.all(
              color: isSelected ? colorAccent : colorG200,
              width: isSelected ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(kRadiusCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: isSelected ? colorDark : colorTextDark,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 9.5,
                  color: isSelected ? colorAccent : colorG400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form group ────────────────────────────────────────────────────────────────

class _FormGroup extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: colorTextMid,
              )),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}