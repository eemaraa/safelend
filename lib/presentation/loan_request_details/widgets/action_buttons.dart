import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> loanData;
  final String currentUserId;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShare;
  final VoidCallback? onSendReminder;

  const ActionButtons({
    Key? key,
    required this.loanData,
    required this.currentUserId,
    this.onAccept,
    this.onReject,
    this.onEdit,
    this.onCancel,
    this.onDownloadPdf,
    this.onShare,
    this.onSendReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = loanData["status"] as String;
    final String creatorId = loanData["creatorId"] as String;
    final String recipientId = loanData["recipientId"] as String;
    final bool isCreator = currentUserId == creatorId;
    final bool isRecipient = currentUserId == recipientId;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Primary action buttons for recipients
          if (isRecipient && status == "pending") ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleAcceptWithBiometric(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successLight,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Принять',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleRejectWithBiometric(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorLight,
                      side: BorderSide(color: AppTheme.errorLight, width: 1.5),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.errorLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Отклонить',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.errorLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],

          // Creator actions
          if (isCreator && status == "pending") ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Редактировать'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSendReminder,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'notifications',
                          color: AppTheme.warningLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Напомнить',
                          style: TextStyle(color: AppTheme.warningLight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onCancel,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'cancel',
                      color: AppTheme.errorLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Отменить запрос',
                      style: TextStyle(color: AppTheme.errorLight),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Common actions
          Row(
            children: [
              if (status == "accepted") ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDownloadPdf,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Скачать PDF'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: onShare,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text('Поделиться'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAcceptWithBiometric(BuildContext context) {
    HapticFeedback.mediumImpact();
    _showBiometricDialog(
      context,
      'Подтверждение принятия займа',
      'Используйте биометрию для подтверждения принятия займа',
      () {
        if (onAccept != null) onAccept!();
      },
    );
  }

  void _handleRejectWithBiometric(BuildContext context) {
    HapticFeedback.lightImpact();
    _showBiometricDialog(
      context,
      'Подтверждение отклонения займа',
      'Используйте биометрию для подтверждения отклонения займа',
      () {
        if (onReject != null) onReject!();
      },
    );
  }

  void _showBiometricDialog(BuildContext context, String title, String message,
      VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}
