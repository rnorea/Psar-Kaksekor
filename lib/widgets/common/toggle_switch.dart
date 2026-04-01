import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';

class ToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ToggleSwitch({super.key, required this.value, this.onChanged});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  @override
  void didUpdateWidget(ToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isOn = widget.value;
  }

  void _toggle() {
    setState(() => _isOn = !_isOn);
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: kToggleWidth,
        height: kToggleHeight,
        decoration: BoxDecoration(
          color: _isOn ? colorAccent : colorG200,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: 3,
              right: _isOn ? 3 : null,
              left: _isOn ? null : 3,
              child: Container(
                width: kToggleThumb,
                height: kToggleThumb,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}