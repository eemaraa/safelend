import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoanAmountInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;

  const LoanAmountInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<LoanAmountInputWidget> createState() => _LoanAmountInputWidgetState();
}

class _LoanAmountInputWidgetState extends State<LoanAmountInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сумма займа',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: widget.errorText != null
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: widget.errorText != null ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
              _RussianRubleFormatter(),
            ],
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: '0',
              prefixIcon: Container(
                width: 12.w,
                alignment: Alignment.center,
                child: Text(
                  '₽',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              suffixText: 'RUB',
              suffixStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              errorStyle: TextStyle(height: 0),
            ),
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        widget.errorText != null
            ? Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 2.w),
                child: Text(
                  widget.errorText!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              )
            : SizedBox.shrink(),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Сумма будет отформатирована автоматически',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RussianRubleFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all spaces and non-digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with spaces for thousands
    String formatted = _addThousandsSeparator(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addThousandsSeparator(String value) {
    if (value.length <= 3) return value;

    String result = '';
    int counter = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      if (counter == 3) {
        result = ' $result';
        counter = 0;
      }
      result = value[i] + result;
      counter++;
    }

    return result;
  }
}
