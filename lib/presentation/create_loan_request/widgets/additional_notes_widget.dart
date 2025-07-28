import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalNotesWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const AdditionalNotesWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AdditionalNotesWidget> createState() => _AdditionalNotesWidgetState();
}

class _AdditionalNotesWidgetState extends State<AdditionalNotesWidget> {
  bool _isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_isExpanded) {
        setState(() {
          _isExpanded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
            if (_isExpanded) {
              _focusNode.requestFocus();
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _isExpanded
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: _isExpanded ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomIconWidget(
                    iconName: 'note_add',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добавить примечание',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _isExpanded
                            ? 'Укажите дополнительные условия займа'
                            : 'Необязательно • Нажмите для добавления',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isExpanded ? null : 0,
          child: _isExpanded
              ? Column(
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        maxLines: 5,
                        maxLength: 500,
                        onChanged: widget.onChanged,
                        decoration: InputDecoration(
                          hintText:
                              'Например:\n• Способ передачи денег\n• Особые условия возврата\n• Штрафы за просрочку\n• Другие важные детали',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(4.w),
                          counterStyle:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lightbulb_outline',
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Рекомендации:',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          _buildRecommendationItem(
                              'Укажите способ передачи денег (наличные, перевод)'),
                          _buildRecommendationItem(
                              'Опишите условия досрочного погашения'),
                          _buildRecommendationItem(
                              'Укажите штрафы за каждый день просрочки'),
                          _buildRecommendationItem(
                              'Добавьте контактные данные для связи'),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = false;
                              });
                              _focusNode.unfocus();
                            },
                            child: Text('Свернуть'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.controller.text.isNotEmpty
                                ? () {
                                    setState(() {
                                      _isExpanded = false;
                                    });
                                    _focusNode.unfocus();
                                  }
                                : null,
                            child: Text('Сохранить'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
        if (!_isExpanded && widget.controller.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Примечание добавлено',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.controller.text.length > 100
                      ? '${widget.controller.text.substring(0, 100)}...'
                      : widget.controller.text,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h, left: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
