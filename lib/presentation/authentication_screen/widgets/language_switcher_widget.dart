import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSwitcherWidget extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;

  const LanguageSwitcherWidget({
    super.key,
    required this.onLanguageChanged,
    this.currentLanguage = 'ru',
  });

  @override
  State<LanguageSwitcherWidget> createState() => _LanguageSwitcherWidgetState();
}

class _LanguageSwitcherWidgetState extends State<LanguageSwitcherWidget> {
  final List<Map<String, String>> _languages = [
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              // Title
              Text(
                'Выберите язык',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontSize: 16.sp.clamp(18.0, 22.0),
                ),
              ),
              SizedBox(height: 2.h),
              // Language options
              ..._languages
                  .map((language) => ListTile(
                        leading: Text(
                          language['flag']!,
                          style: TextStyle(fontSize: 6.w.clamp(24.0, 32.0)),
                        ),
                        title: Text(
                          language['name']!,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontSize: 14.sp.clamp(14.0, 16.0),
                            fontWeight:
                                widget.currentLanguage == language['code']
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                          ),
                        ),
                        trailing: widget.currentLanguage == language['code']
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 5.w.clamp(20.0, 24.0),
                              )
                            : null,
                        onTap: () {
                          widget.onLanguageChanged(language['code']!);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  String get _currentLanguageFlag {
    return _languages.firstWhere(
      (lang) => lang['code'] == widget.currentLanguage,
      orElse: () => _languages.first,
    )['flag']!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w.clamp(48.0, 64.0),
      height: 12.w.clamp(48.0, 64.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLanguageSelector,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.dividerLight,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _currentLanguageFlag,
                style: TextStyle(
                  fontSize: 6.w.clamp(20.0, 28.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
