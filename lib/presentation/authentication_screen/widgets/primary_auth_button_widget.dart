import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrimaryAuthButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryAuthButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<PrimaryAuthButtonWidget> createState() =>
      _PrimaryAuthButtonWidgetState();
}

class _PrimaryAuthButtonWidgetState extends State<PrimaryAuthButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 6.h.clamp(48.0, 64.0),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    widget.onPressed();
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLoading
                    ? AppTheme.textDisabledLight
                    : (_isPressed
                        ? AppTheme.primaryVariantLight
                        : AppTheme.lightTheme.primaryColor),
                foregroundColor: Colors.white,
                elevation: _isPressed ? 1.0 : 3.0,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h)),
            child: widget.isLoading
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                        width: 5.w.clamp(20.0, 24.0),
                        height: 5.w.clamp(20.0, 24.0),
                        child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))),
                    SizedBox(width: 3.w),
                    Flexible(
                        child: Text('Проверка личности...',
                            style: TextStyle(
                                fontSize: 14.sp.clamp(14.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis)),
                  ])
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CustomIconWidget(
                        iconName: 'verified_user',
                        color: Colors.white,
                        size: 5.w.clamp(20.0, 24.0)),
                    SizedBox(width: 3.w),
                    Flexible(
                        child: Text('Войти через Госуслуги',
                            style: TextStyle(
                                fontSize: 14.sp.clamp(14.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis)),
                  ])));
  }
}
