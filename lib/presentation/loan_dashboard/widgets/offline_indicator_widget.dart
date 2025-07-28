import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OfflineIndicatorWidget extends StatelessWidget {
  final DateTime? lastUpdated;
  final bool isOffline;

  const OfflineIndicatorWidget({
    super.key,
    this.lastUpdated,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              lastUpdated != null
                  ? 'Офлайн режим • Обновлено ${_formatLastUpdated(lastUpdated!)}'
                  : 'Офлайн режим • Нет подключения к интернету',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин. назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч. назад';
    } else {
      return '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    }
  }
}
