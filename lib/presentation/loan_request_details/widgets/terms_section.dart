import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TermsSection extends StatefulWidget {
  final Map<String, dynamic> loanData;

  const TermsSection({
    Key? key,
    required this.loanData,
  }) : super(key: key);

  @override
  State<TermsSection> createState() => _TermsSectionState();
}

class _TermsSectionState extends State<TermsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Условия займа',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildTermItem(
              'Сумма займа',
              '${widget.loanData["amount"]} ₽',
              'account_balance_wallet',
            ),
            _buildTermItem(
              'Процентная ставка',
              '${widget.loanData["interestRate"]}% годовых',
              'percent',
            ),
            _buildTermItem(
              'Срок возврата',
              widget.loanData["returnDate"] as String,
              'schedule',
            ),
            _buildTermItem(
              'Штраф за просрочку',
              '${widget.loanData["lateFee"] ?? "0.5"}% в день',
              'warning',
            ),
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              SizedBox(height: 2.h),
              Text(
                'Дополнительные условия',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                widget.loanData["additionalTerms"] as String? ??
                    'Заемщик обязуется вернуть полную сумму займа в указанный срок. При просрочке платежа начисляется штраф в размере 0.5% от суммы займа за каждый день просрочки. Договор составлен в соответствии с Гражданским кодексом РФ.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.warningLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Правовая информация',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.warningLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Данное приложение не выдает займы. Мы предоставляем платформу для оформления договоров между частными лицами в соответствии с ФЗ №152 "О персональных данных".',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
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
