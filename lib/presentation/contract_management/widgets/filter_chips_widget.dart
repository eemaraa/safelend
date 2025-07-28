import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> initialFilters;

  const FilterChipsWidget({
    Key? key,
    required this.onFiltersChanged,
    this.initialFilters = const {},
  }) : super(key: key);

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  late Map<String, dynamic> _currentFilters;
  int _activeFilterCount = 0;

  final List<Map<String, dynamic>> _statusFilters = [
    {'key': 'active', 'label': 'Активные', 'icon': 'check_circle'},
    {'key': 'completed', 'label': 'Завершенные', 'icon': 'task_alt'},
    {'key': 'overdue', 'label': 'Просроченные', 'icon': 'warning'},
  ];

  final List<Map<String, dynamic>> _dateFilters = [
    {'key': 'today', 'label': 'Сегодня', 'icon': 'today'},
    {'key': 'week', 'label': 'Неделя', 'icon': 'date_range'},
    {'key': 'month', 'label': 'Месяц', 'icon': 'calendar_month'},
    {'key': 'year', 'label': 'Год', 'icon': 'event'},
  ];

  final List<Map<String, dynamic>> _amountFilters = [
    {'key': 'small', 'label': '< 50,000 ₽', 'icon': 'attach_money'},
    {'key': 'medium', 'label': '50,000 - 500,000 ₽', 'icon': 'payments'},
    {'key': 'large', 'label': '> 500,000 ₽', 'icon': 'account_balance'},
  ];

  @override
  void initState() {
    super.initState();
    _currentFilters = Map.from(widget.initialFilters);
    _updateActiveFilterCount();
  }

  void _updateActiveFilterCount() {
    _activeFilterCount = 0;
    _currentFilters.forEach((key, value) {
      if (value is bool && value) {
        _activeFilterCount++;
      } else if (value is String && value.isNotEmpty) {
        _activeFilterCount++;
      } else if (value is List && value.isNotEmpty) {
        _activeFilterCount++;
      }
    });
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _currentFilters[key] = value;
      _updateActiveFilterCount();
    });
    widget.onFiltersChanged(_currentFilters);
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      _activeFilterCount = 0;
    });
    widget.onFiltersChanged(_currentFilters);
  }

  Widget _buildFilterChip({
    required String label,
    required String iconName,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
                  .withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Map<String, dynamic>> filters,
    required String filterKey,
    Color? selectedColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(
          height: 6.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = _currentFilters[filterKey] == filter['key'];

              return _buildFilterChip(
                label: filter['label'],
                iconName: filter['icon'],
                isSelected: isSelected,
                selectedColor: selectedColor,
                onTap: () {
                  if (isSelected) {
                    _updateFilter(filterKey, null);
                  } else {
                    _updateFilter(filterKey, filter['key']);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFiltersBadge() {
    if (_activeFilterCount == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Активных фильтров: $_activeFilterCount',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
            child: Text(
              'Очистить все',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
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
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveFiltersBadge(),
          _buildFilterSection(
            title: 'По статусу',
            filters: _statusFilters,
            filterKey: 'status',
            selectedColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
          SizedBox(height: 1.h),
          _buildFilterSection(
            title: 'По дате',
            filters: _dateFilters,
            filterKey: 'dateRange',
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 1.h),
          _buildFilterSection(
            title: 'По сумме',
            filters: _amountFilters,
            filterKey: 'amountRange',
            selectedColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
