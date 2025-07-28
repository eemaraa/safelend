import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LegalComplianceWidget extends StatelessWidget {
  const LegalComplianceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security icon and title
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w.clamp(20.0, 24.0),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Защита персональных данных',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp.clamp(14.0, 16.0),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHighEmphasisLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          // Compliance text
          Text(
            'Приложение SafeLend соблюдает требования Федерального закона № 152-ФЗ "О персональных данных". Ваши данные защищены и используются только для оформления займов.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp.clamp(11.0, 13.0),
              color: AppTheme.textMediumEmphasisLight,
              height: 1.4,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 1.5.h),
          // Disclaimer
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningLight.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.warningLight,
                  size: 4.w.clamp(16.0, 20.0),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Важно: Приложение не выдает займы. Мы предоставляем платформу для оформления договоров между частными лицами.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 10.sp.clamp(10.0, 12.0),
                      color: AppTheme.warningLight,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
