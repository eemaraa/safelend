import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onCreateLoan;

  const EmptyStateWidget({
    super.key,
    this.onCreateLoan,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'Создайте свой первый\nзапрос на займ',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Оформляйте займы между частными лицами\nс юридической защитой и верификацией\nчерез Госуслуги',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 4.h),
            _buildBenefitsList(),
            SizedBox(height: 6.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCreateLoan,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Создать запрос на займ',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': 'security',
        'title': 'Юридическая защита',
        'description': 'Соответствие ФЗ-152 о персональных данных',
      },
      {
        'icon': 'verified_user',
        'title': 'Верификация личности',
        'description': 'Подтверждение через Госуслуги',
      },
      {
        'icon': 'description',
        'title': 'Цифровые договоры',
        'description': 'Автоматическое создание и хранение',
      },
    ];

    return Column(
      children: benefits
          .map((benefit) => _buildBenefitItem(
                benefit['icon'] as String,
                benefit['title'] as String,
                benefit['description'] as String,
              ))
          .toList(),
    );
  }

  Widget _buildBenefitItem(String iconName, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
