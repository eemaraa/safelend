import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContractCardWidget extends StatefulWidget {
  final Map<String, dynamic> contract;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onSetReminder;
  final VoidCallback? onArchive;
  final VoidCallback? onDuplicate;
  final VoidCallback? onReportIssue;

  const ContractCardWidget({
    Key? key,
    required this.contract,
    this.onTap,
    this.onDownload,
    this.onShare,
    this.onSetReminder,
    this.onArchive,
    this.onDuplicate,
    this.onReportIssue,
  }) : super(key: key);

  @override
  State<ContractCardWidget> createState() => _ContractCardWidgetState();
}

class _ContractCardWidgetState extends State<ContractCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onTap?.call();
  }

  Color _getStatusColor() {
    final status = widget.contract['status'] as String? ?? 'Active';
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'overdue':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  Widget _buildStatusBadge() {
    final status = widget.contract['status'] as String? ?? 'Active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVerificationIndicator(bool isVerified) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
      decoration: BoxDecoration(
        color: isVerified
            ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isVerified ? 'verified' : 'warning',
            color: isVerified
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.outline,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            isVerified ? 'Госуслуги' : 'Не верифицирован',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isVerified
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.outline,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: 'download',
            label: 'Скачать PDF',
            onTap: widget.onDownload,
          ),
          _buildActionButton(
            icon: 'share',
            label: 'Поделиться',
            onTap: widget.onShare,
          ),
          _buildActionButton(
            icon: 'alarm',
            label: 'Напоминание',
            onTap: widget.onSetReminder,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final terms = widget.contract['terms'] as Map<String, dynamic>? ?? {};
    final paymentSchedule = widget.contract['paymentSchedule'] as List? ?? [];

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Условия договора',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildTermRow('Процентная ставка',
                    '${terms['interestRate'] ?? 'Не указано'}%'),
                _buildTermRow(
                    'Срок погашения', terms['repaymentPeriod'] ?? 'Не указано'),
                _buildTermRow('Штраф за просрочку',
                    '${terms['lateFee'] ?? 'Не указано'}%'),
                SizedBox(height: 2.h),
                Text(
                  'График платежей',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ...paymentSchedule
                    .map((payment) => _buildPaymentRow(payment))
                    .toList(),
                SizedBox(height: 2.h),
                _buildQuickActions(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(Map<String, dynamic> payment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            payment['date'] ?? '',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          Text(
            '${payment['amount'] ?? '0'} ₽',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: (payment['isPaid'] == true)
                  ? AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              (payment['isPaid'] == true) ? 'Оплачено' : 'Ожидает',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: (payment['isPaid'] == true)
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.outline,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lenderName = widget.contract['lenderName'] as String? ?? 'Неизвестно';
    final borrowerName =
        widget.contract['borrowerName'] as String? ?? 'Неизвестно';
    final amount = widget.contract['amount'] as String? ?? '0';
    final signingDate = widget.contract['signingDate'] as String? ?? '';
    final contractId = widget.contract['contractId'] as String? ?? '';
    final lenderVerified = widget.contract['lenderVerified'] as bool? ?? false;
    final borrowerVerified =
        widget.contract['borrowerVerified'] as bool? ?? false;

    return GestureDetector(
      onTap: _toggleExpansion,
      onLongPress: () {
        _showContextMenu(context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Договор #$contractId',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'account_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Кредитор: $lenderName',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            _buildVerificationIndicator(lenderVerified),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Заемщик: $borrowerName',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            _buildVerificationIndicator(borrowerVerified),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сумма займа',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '$amount ₽',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Дата подписания',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            signingDate,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: _isExpanded
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded) _buildExpandedContent(),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Архивировать',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onArchive?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Дублировать',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onDuplicate?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Сообщить о проблеме',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onReportIssue?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
