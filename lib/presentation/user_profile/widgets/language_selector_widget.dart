import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../services/localization_service.dart';
import '../../../theme/app_theme.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService();

    final languages = [
      {
        'code': 'ru',
        'name': AppLocalizations.of(context)!.russian,
        'flag': localizationService.languageFlags['ru']!,
      },
      {
        'code': 'en',
        'name': AppLocalizations.of(context)!.english,
        'flag': localizationService.languageFlags['en']!,
      },
      {
        'code': 'ar',
        'name': AppLocalizations.of(context)!.arabic,
        'flag': localizationService.languageFlags['ar']!,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: languages.map((language) {
          final isSelected = language['code'] == currentLanguage;
          final isLast = language == languages.last;

          return InkWell(
            onTap: () => onLanguageChanged(language['code']!),
            borderRadius: BorderRadius.circular(4.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4.w),
                border: !isLast
                    ? Border(
                        bottom: BorderSide(
                          color: AppTheme.lightTheme.dividerColor
                              .withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.dividerColor
                                .withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        language['flag']!,
                        style: TextStyle(fontSize: 5.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      language['name']!,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        letterSpacing: 0.25,
                      ),
                      textDirection: language['code'] == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
