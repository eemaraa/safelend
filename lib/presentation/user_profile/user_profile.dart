import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/localization_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/logout_button_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final LocalizationService _localizationService = LocalizationService();

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": "12345",
    "name": "Александр Петров",
    "email": "aleksandr.petrov@example.com",
    "phone": "+7 (999) 123-45-67",
    "isVerified": true,
    "registrationDate": "15.03.2024",
    "documentsCount": 3,
    "activeLoans": 2,
  };

  // App settings
  bool _biometricEnabled = true;
  bool _loanRequestsNotifications = true;
  bool _statusUpdatesNotifications = true;
  bool _marketingNotifications = false;
  String _appVersion = "1.2.3";

  void _onLanguageChanged(String languageCode) async {
    await _localizationService.changeLanguage(languageCode);

    if (mounted) {
      // Show confirmation with proper localization
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.languageChanged,
            textDirection: _localizationService.isRTL()
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onNotificationSettingChanged(String setting, bool value) {
    setState(() {
      switch (setting) {
        case 'loan_requests':
          _loanRequestsNotifications = value;
          break;
        case 'status_updates':
          _statusUpdatesNotifications = value;
          break;
        case 'marketing':
          _marketingNotifications = value;
          break;
      }
    });
  }

  void _toggleBiometric() {
    setState(() {
      _biometricEnabled = !_biometricEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _biometricEnabled
              ? AppLocalizations.of(context)!.biometricEnabled
              : AppLocalizations.of(context)!.biometricDisabled,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onLogout() {
    // Clear user data and navigate to authentication
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/authentication-screen',
      (route) => false,
    );
  }

  void _navigateToDocuments() {
    Navigator.pushNamed(context, '/contract-management');
  }

  void _navigateToPrivacyPolicy() {
    // Navigate to privacy policy screen or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
        content: Text(AppLocalizations.of(context)!.privacyPolicyContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _navigateToTermsOfService() {
    // Navigate to terms of service screen or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.termsOfService),
        content: Text(AppLocalizations.of(context)!.termsContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showFAQ() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.faq),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.faqQuestion1,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)!.faqAnswer1,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                AppLocalizations.of(context)!.faqQuestion2,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)!.faqAnswer2,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.contactSupport),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.supportEmail,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              AppLocalizations.of(context)!.supportPhone,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              AppLocalizations.of(context)!.supportHours,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.latestVersion),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userName: _userData["name"] as String,
              userEmail: _userData["email"] as String,
              isVerified: _userData["isVerified"] as bool,
            ),

            SizedBox(height: 3.h),

            // Account Information Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.accountInformation,
              children: [
                SettingsItemWidget(
                  iconName: 'person',
                  title: AppLocalizations.of(context)!.name,
                  subtitle: _userData["name"] as String,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'email',
                  title: AppLocalizations.of(context)!.email,
                  subtitle: _userData["email"] as String,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'phone',
                  title: AppLocalizations.of(context)!.phone,
                  subtitle: _userData["phone"] as String,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'calendar_today',
                  title: AppLocalizations.of(context)!.registrationDate,
                  subtitle: _userData["registrationDate"] as String,
                  isLast: true,
                ),
              ],
            ),

            // App Preferences Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.appPreferences,
              children: [
                SettingsItemWidget(
                  iconName: 'language',
                  title: AppLocalizations.of(context)!.languageInterface,
                  subtitle: _localizationService.getCurrentLanguageName(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.w),
                        ),
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
                                color: AppTheme.lightTheme.dividerColor,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              AppLocalizations.of(context)!.selectLanguage,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            LanguageSelectorWidget(
                              currentLanguage: _localizationService
                                  .currentLocale.languageCode,
                              onLanguageChanged: (language) {
                                _onLanguageChanged(language);
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    );
                  },
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'notifications',
                  title: AppLocalizations.of(context)!.notifications,
                  subtitle: AppLocalizations.of(context)!.notificationSettings,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.w),
                        ),
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
                                color: AppTheme.lightTheme.dividerColor,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              AppLocalizations.of(context)!
                                  .notificationSettings,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            NotificationSettingsWidget(
                              loanRequestsEnabled: _loanRequestsNotifications,
                              statusUpdatesEnabled: _statusUpdatesNotifications,
                              marketingEnabled: _marketingNotifications,
                              onSettingChanged: _onNotificationSettingChanged,
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),

            // Security Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.security,
              children: [
                SettingsItemWidget(
                  iconName: 'fingerprint',
                  title: AppLocalizations.of(context)!.biometricAuth,
                  subtitle: _biometricEnabled
                      ? AppLocalizations.of(context)!.enabled
                      : AppLocalizations.of(context)!.disabled,
                  trailing: Switch(
                    value: _biometricEnabled,
                    onChanged: (value) => _toggleBiometric(),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'security',
                  title: AppLocalizations.of(context)!.sessionManagement,
                  subtitle: AppLocalizations.of(context)!.activeSessions,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            AppLocalizations.of(context)!.sessionManagement),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: CustomIconWidget(
                                iconName: 'phone_android',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 6.w,
                              ),
                              title: Text(
                                  AppLocalizations.of(context)!.currentDevice),
                              subtitle: const Text('Android • Москва'),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.active,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.close),
                          ),
                        ],
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),

            // Documents Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.documents,
              children: [
                SettingsItemWidget(
                  iconName: 'folder',
                  title: AppLocalizations.of(context)!.myDocuments,
                  subtitle: AppLocalizations.of(context)!
                      .documentsCount(_userData["documentsCount"]),
                  onTap: _navigateToDocuments,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'download',
                  title: AppLocalizations.of(context)!.downloadedFiles,
                  subtitle: AppLocalizations.of(context)!.manageLocalFiles,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:
                            Text(AppLocalizations.of(context)!.downloadedFiles),
                        content: Text(
                            AppLocalizations.of(context)!.encryptedStorage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child:
                                Text(AppLocalizations.of(context)!.clearCache),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.close),
                          ),
                        ],
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),

            // Legal Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.legalInfo,
              children: [
                SettingsItemWidget(
                  iconName: 'privacy_tip',
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  subtitle:
                      AppLocalizations.of(context)!.privacyPolicyDescription,
                  onTap: _navigateToPrivacyPolicy,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'description',
                  title: AppLocalizations.of(context)!.termsOfService,
                  subtitle: AppLocalizations.of(context)!.userAgreement,
                  onTap: _navigateToTermsOfService,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'info',
                  title: AppLocalizations.of(context)!.legalDisclaimer,
                  subtitle: AppLocalizations.of(context)!.disclaimerDescription,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:
                            Text(AppLocalizations.of(context)!.legalDisclaimer),
                        content: Text(
                            AppLocalizations.of(context)!.disclaimerContent),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child:
                                Text(AppLocalizations.of(context)!.understand),
                          ),
                        ],
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),

            // Support Section
            SettingsSectionWidget(
              title: AppLocalizations.of(context)!.support,
              children: [
                SettingsItemWidget(
                  iconName: 'help',
                  title: AppLocalizations.of(context)!.faq,
                  subtitle: AppLocalizations.of(context)!.faqDescription,
                  onTap: _showFAQ,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'support',
                  title: AppLocalizations.of(context)!.contactSupport,
                  subtitle: AppLocalizations.of(context)!.supportDescription,
                  onTap: _contactSupport,
                  isLast: false,
                ),
                SettingsItemWidget(
                  iconName: 'system_update',
                  title: AppLocalizations.of(context)!.appVersion,
                  subtitle: 'v$_appVersion',
                  onTap: _checkForUpdates,
                  isLast: true,
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Logout Button
            LogoutButtonWidget(
              onLogout: _onLogout,
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
