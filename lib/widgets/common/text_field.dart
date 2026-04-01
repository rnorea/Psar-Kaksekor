import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';

/// Standard single-line text field.
class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? label;

  const CustomTextField({
    super.key,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.label,
  });

  InputDecoration get _decoration => InputDecoration(
    hintText: hint,
    hintStyle: hintText,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: inputText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _decoration,
    );
  }
}

/// Dropdown / select field that matches the text-field visual style.
class CustomDropdownField<T> extends StatelessWidget {
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const CustomDropdownField({
    super.key,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      style: inputText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintText,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      ),
    );
  }
}