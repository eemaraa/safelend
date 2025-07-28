import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricPressed;
  final bool isAvailable;

  const BiometricAuthWidget({
    super.key,
    required this.onBiometricPressed,
    this.isAvailable = true,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isAvailable) {
      return SizedBox.shrink();
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(children: [
          // Divider with text
          Row(children: [
            Expanded(
                child: Divider(color: AppTheme.dividerLight, thickness: 1.0)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text('или',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                        fontSize: 12.sp.clamp(12.0, 14.0)))),
            Expanded(
                child: Divider(color: AppTheme.dividerLight, thickness: 1.0)),
          ]),
          SizedBox(height: 3.h),
          // Biometric authentication button
          Container(
              width: double.infinity,
              height: 6.h.clamp(48.0, 64.0),
              child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onBiometricPressed();
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor: _isPressed
                          ? AppTheme.primaryVariantLight
                          : AppTheme.lightTheme.primaryColor,
                      side: BorderSide(
                          color: _isPressed
                              ? AppTheme.primaryVariantLight
                              : AppTheme.lightTheme.primaryColor,
                          width: 1.5),
                      backgroundColor: _isPressed
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.05)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                            iconName: 'fingerprint',
                            color: _isPressed
                                ? AppTheme.primaryVariantLight
                                : AppTheme.lightTheme.primaryColor,
                            size: 5.w.clamp(20.0, 24.0)),
                        SizedBox(width: 3.w),
                        Flexible(
                            child: Text('Биометрическая аутентификация',
                                style: TextStyle(
                                    fontSize: 14.sp.clamp(14.0, 18.0),
                                    fontWeight: FontWeight.w500,
                                    color: _isPressed
                                        ? AppTheme.primaryVariantLight
                                        : AppTheme.lightTheme.primaryColor),
                                overflow: TextOverflow.ellipsis)),
                      ]))),
        ]));
  }
}
