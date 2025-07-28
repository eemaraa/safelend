import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GovernmentLogoWidget extends StatelessWidget {
  const GovernmentLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 20.h,
      constraints: BoxConstraints(
        maxWidth: 320,
        maxHeight: 160,
        minWidth: 200,
        minHeight: 100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Government Services Logo
          Container(
            width: 25.w,
            height: 8.h,
            constraints: BoxConstraints(
              maxWidth: 100,
              maxHeight: 64,
              minWidth: 60,
              minHeight: 40,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'account_balance',
                color: Colors.white,
                size: 12.sp.clamp(24.0, 40.0),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Government Services Text
          Text(
            'Госуслуги',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp.clamp(20.0, 28.0),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Единый портал государственных услуг',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontSize: 10.sp.clamp(10.0, 14.0),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
