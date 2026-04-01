import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(title, style: sectionTitle),
    );
  }
}