import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RepaymentDatePickerWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;

  const RepaymentDatePickerWidget({
    Key? key,
    this.selectedDate,
    required this.onDateSelected,
    this.errorText,
  }) : super(key: key);

  @override
  State<RepaymentDatePickerWidget> createState() =>
      _RepaymentDatePickerWidgetState();
}

class _RepaymentDatePickerWidgetState extends State<RepaymentDatePickerWidget> {
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        widget.selectedDate ?? now.add(Duration(days: 30));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          initialDate.isBefore(now) ? now.add(Duration(days: 1)) : initialDate,
      firstDate: now.add(Duration(days: 1)),
      lastDate: DateTime(now.year + 10),
      locale: Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.onPrimary;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
              todayForegroundColor: WidgetStateProperty.all(
                AppTheme.lightTheme.colorScheme.primary,
              ),
              todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
              todayBorder: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата возврата',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: widget.errorText != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
                width: widget.errorText != null ? 2.0 : 1.0,
              ),
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.selectedDate != null
                        ? _formatDate(widget.selectedDate!)
                        : 'Выберите дату',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: widget.selectedDate != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
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
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Минимальный срок возврата - завтра',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
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
