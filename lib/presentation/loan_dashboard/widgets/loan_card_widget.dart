import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoanCardWidget extends StatelessWidget {
  final Map<String, dynamic> loanData;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onSendReminder;
  final VoidCallback? onArchive;

  const LoanCardWidget({
    super.key,
    required this.loanData,
    this.onTap,
    this.onViewDetails,
    this.onDownloadPdf,
    this.onSendReminder,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final String status = loanData['status'] ?? 'pending';
    final String amount = loanData['amount'] ?? '0';
    final String counterparty = loanData['counterparty'] ?? 'Unknown';
    final DateTime? dueDate = loanData['dueDate'];
    final bool isUrgent = loanData['isUrgent'] ?? false;
    final bool hasNotification = loanData['hasNotification'] ?? false;

    return Dismissible(
      key: Key(loanData['id'].toString()),
      background: _buildSwipeBackground(isLeft: false),
      secondaryBackground: _buildSwipeBackground(isLeft: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right - Quick actions
          _showQuickActions(context);
        } else {
          // Swipe left - Archive
          onArchive?.call();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '₽ ${_formatAmount(amount)}',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            counterparty,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (dueDate != null) ...[
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: isUrgent
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _formatDueDate(dueDate),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isUrgent
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'archive' : 'more_horiz',
                color: isLeft
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Архив' : 'Действия',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.secondary;
        statusText = 'Одобрено';
        break;
      case 'pending':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        statusText = 'Ожидание';
        break;
      case 'rejected':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.error;
        statusText = 'Отклонено';
        break;
      case 'active':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        statusText = 'Активно';
        break;
      default:
        backgroundColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        statusText = 'Неизвестно';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatAmount(String amount) {
    try {
      final double value = double.parse(amount);
      return value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]} ',
          );
    } catch (e) {
      return amount;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return 'Просрочено на ${(-difference)} дн.';
    } else if (difference == 0) {
      return 'Сегодня';
    } else if (difference == 1) {
      return 'Завтра';
    } else if (difference <= 7) {
      return 'Через $difference дн.';
    } else {
      return '${dueDate.day}.${dueDate.month.toString().padLeft(2, '0')}.${dueDate.year}';
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Просмотр деталей',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onViewDetails?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Скачать PDF',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onDownloadPdf?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'send',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text(
                'Отправить напоминание',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onSendReminder?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            if (loanData['status'] == 'pending') ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Редактировать',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Дублировать',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text(
                'Поделиться PDF',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
