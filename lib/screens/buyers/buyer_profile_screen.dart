import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/providers/user_provider.dart';
import 'package:phsar_kaksekor_app/models/user_model.dart';
import 'package:phsar_kaksekor_app/widgets/common/profile_section.dart';
import 'package:phsar_kaksekor_app/widgets/common/action_row.dart';
import 'package:phsar_kaksekor_app/widgets/common/toggle_switch.dart';
import 'package:phsar_kaksekor_app/widgets/common/toast_message.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorOff,
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, auth, user, _) {
          final profile = auth.currentUser;
          if (profile == null) return const SizedBox();
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(profile),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kScreenPadding, kSectionGap, kScreenPadding, 0),
                  child: Column(
                    children: [
                      _buildAccountInfo(profile),
                      _buildPreferences(context, user),
                      _buildAccountActions(context),
                      const SizedBox(height: kSectionGap),
                      _buildSwitchRoleButton(context, auth),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel profile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusProfile),
          bottomRight: Radius.circular(kRadiusProfile),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 22),
      child: Column(
        children: [
          // Large avatar
          Container(
            width: kAvatarLarge,
            height: kAvatarLarge,
            decoration: const BoxDecoration(
              color: colorLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              profile.avatarInitial,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(profile.name, style: titleXL.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(profile.email, style: metaText.copyWith(color: colorG400)),
          const SizedBox(height: 10),
          // Role chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(kRadiusBadge),
            ),
            child: const Text(
              '🛒 Buyer',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(UserModel profile) {
    return ProfileSection(
      title: 'Account Info',
      rows: [
        _profileRow('👤', 'Name', profile.name),
        _profileRow('✉️', 'Email', profile.email),
        _profileRow('📞', 'Phone', profile.phone),
        _profileRow('📍', 'Location', profile.location, isLast: true),
      ],
    );
  }

  Widget _buildPreferences(BuildContext context, UserProvider user) {
    return ProfileSection(
      title: 'Preferences',
      rows: [
        _toggleRow('🔔', 'Notifications', user.notificationsEnabled, (v) {
          user.toggleNotifications(v);
        }),
        _arrowRow('🌐', 'Language', 'English', isLast: true, onTap: () {}),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return ProfileSection(
      title: 'Account',
      rows: [
        ActionRow(
          icon: '❓',
          label: 'Help & Support',
          iconBg: const Color(0xFFF0F9FF),
          onTap: () {},
        ),
        ActionRow(
          icon: '📄',
          label: 'Terms & Privacy',
          iconBg: const Color(0xFFF5F5FF),
          onTap: () {},
        ),
        ActionRow(
          icon: '🎁',
          label: 'Invite Friends',
          iconBg: const Color(0xFFFFF5E8),
          onTap: () {},
        ),
        ActionRow(
          icon: '🚪',
          label: 'Log Out',
          iconBg: const Color(0xFFFFEAEA),
          isDanger: true,
          isLast: true,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  Widget _buildSwitchRoleButton(BuildContext context, AuthProvider auth) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorAccent,
        minimumSize: const Size(double.infinity, 42),
        side: const BorderSide(color: colorG200, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusBtn)),
        elevation: 0,
        textStyle: const TextStyle(
            fontFamily: 'DM Sans', fontWeight: FontWeight.w700, fontSize: 12),
      ),
      onPressed: () {
        auth.switchRole(UserRole.seller);
        showToast(context, '🌾 Switched to Seller mode');
      },
      child: const Text('Switch to Seller Mode'),
    );
  }

  // Helper row builders
  Widget _profileRow(String icon, String label, String value,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kRowPaddingV),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: colorG100, width: 1),
              ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(label, style: bodySmall.copyWith(color: colorG600)),
          const Spacer(),
          Text(value,
              style: bodyMed.copyWith(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _toggleRow(
      String icon, String label, bool value, ValueChanged<bool> onChange,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kRowPaddingV),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: colorG100, width: 1),
              ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(label, style: bodySmall.copyWith(color: colorG600)),
          const Spacer(),
          ToggleSwitch(isOn: value, onChanged: onChange),
        ],
      ),
    );
  }

  Widget _arrowRow(String icon, String label, String value,
      {bool isLast = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kRowPaddingV),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: colorG100, width: 1),
                ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(label, style: bodySmall.copyWith(color: colorG600)),
            const Spacer(),
            Text(value, style: bodySmall),
            const SizedBox(width: 4),
            const Text('›',
                style: TextStyle(fontSize: 11, color: colorG400)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: colorG200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Log Out?', style: titleMed),
            const SizedBox(height: 6),
            Text('Are you sure you want to log out?', style: metaText),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusBtn)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
              child: const Text('Yes, Log Out'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: colorG600,
                minimumSize: const Size(double.infinity, 44),
                side: const BorderSide(color: colorG200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusBtn)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
