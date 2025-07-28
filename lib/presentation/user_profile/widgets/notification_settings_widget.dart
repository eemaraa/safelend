import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final bool loanRequestsEnabled;
  final bool statusUpdatesEnabled;
  final bool marketingEnabled;
  final Function(String, bool) onSettingChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.loanRequestsEnabled,
    required this.statusUpdatesEnabled,
    required this.marketingEnabled,
    required this.onSettingChanged,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  late bool _loanRequestsEnabled;
  late bool _statusUpdatesEnabled;
  late bool _marketingEnabled;

  @override
  void initState() {
    super.initState();
    _loanRequestsEnabled = widget.loanRequestsEnabled;
    _statusUpdatesEnabled = widget.statusUpdatesEnabled;
    _marketingEnabled = widget.marketingEnabled;
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isLast,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildNotificationItem(
            title: 'Запросы займов',
            subtitle: 'Уведомления о новых запросах займов',
            value: _loanRequestsEnabled,
            onChanged: (value) {
              setState(() => _loanRequestsEnabled = value);
              widget.onSettingChanged('loan_requests', value);
            },
            isLast: false,
          ),
          _buildNotificationItem(
            title: 'Обновления статуса',
            subtitle: 'Изменения статуса займов и договоров',
            value: _statusUpdatesEnabled,
            onChanged: (value) {
              setState(() => _statusUpdatesEnabled = value);
              widget.onSettingChanged('status_updates', value);
            },
            isLast: false,
          ),
          _buildNotificationItem(
            title: 'Маркетинговые уведомления',
            subtitle: 'Новости и предложения от SafeLend',
            value: _marketingEnabled,
            onChanged: (value) {
              setState(() => _marketingEnabled = value);
              widget.onSettingChanged('marketing', value);
            },
            isLast: true,
          ),
        ],
      ),
    );
  }
}
