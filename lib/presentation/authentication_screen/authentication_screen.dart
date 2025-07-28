import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/government_logo_widget.dart';
import './widgets/language_switcher_widget.dart';
import './widgets/legal_compliance_widget.dart';
import './widgets/primary_auth_button_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isLoading = false;
  bool _isBiometricAvailable = true;
  String _currentLanguage = 'ru';

  // Mock authentication data
  final Map<String, Map<String, String>> _mockCredentials = {
    'government': {
      'username': 'ivan.petrov@gosuslugi.ru',
      'password': 'GosPass2024!',
      'snils': '123-456-789 01',
    },
    'biometric': {
      'user_id': 'bio_user_12345',
      'device_id': 'device_abc123',
    },
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate biometric availability check
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isBiometricAvailable = true; // Mock availability
      });
    }
  }

  Future<void> _handleGovernmentAuth() async {
    setState(() => _isLoading = true);

    try {
      // Simulate government authentication process
      await Future.delayed(Duration(seconds: 2));

      // Mock OAuth 2.0 flow simulation
      final bool authSuccess = await _simulateGovernmentAuth();

      if (authSuccess) {
        HapticFeedback.lightImpact();
        _showSuccessMessage('Аутентификация через Госуслуги успешна');
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/loan-dashboard');
        }
      } else {
        _showErrorMessage('Неверные учетные данные Госуслуги');
      }
    } catch (e) {
      _showErrorMessage('Ошибка подключения к Госуслугам');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _simulateGovernmentAuth() async {
    // Simulate network delay and authentication
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock authentication logic - in real app this would be OAuth 2.0
    return true; // Mock successful authentication
  }

  Future<void> _handleBiometricAuth() async {
    try {
      // Simulate biometric authentication
      await Future.delayed(Duration(milliseconds: 800));

      final bool biometricSuccess = await _simulateBiometricAuth();

      if (biometricSuccess) {
        HapticFeedback.lightImpact();
        _showSuccessMessage('Биометрическая аутентификация успешна');
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/loan-dashboard');
        }
      } else {
        _showErrorMessage('Биометрическая аутентификация не удалась');
      }
    } catch (e) {
      _showErrorMessage('Биометрическая аутентификация недоступна');
    }
  }

  Future<bool> _simulateBiometricAuth() async {
    // Simulate biometric verification
    await Future.delayed(Duration(milliseconds: 600));
    return true; // Mock successful biometric authentication
  }

  void _handleLanguageChange(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });

    String languageName = '';
    switch (languageCode) {
      case 'ru':
        languageName = 'Русский';
        break;
      case 'en':
        languageName = 'English';
        break;
      case 'ar':
        languageName = 'العربية';
        break;
    }

    _showSuccessMessage('Язык изменен на $languageName');
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successLight,
      textColor: Colors.white,
      fontSize: 12.sp.clamp(14.0, 16.0),
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.errorLight,
      textColor: Colors.white,
      fontSize: 12.sp.clamp(14.0, 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Top section with language switcher
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // App title
                        Text(
                          'SafeLend',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontSize: 18.sp.clamp(20.0, 24.0),
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                        // Language switcher
                        LanguageSwitcherWidget(
                          currentLanguage: _currentLanguage,
                          onLanguageChanged: _handleLanguageChange,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Government logo section
                  GovernmentLogoWidget(),

                  SizedBox(height: 6.h),

                  // Welcome text
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Text(
                          'Добро пожаловать в SafeLend',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontSize: 16.sp.clamp(22.0, 26.0),
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textHighEmphasisLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Безопасное оформление займов между частными лицами с государственной верификацией личности',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 12.sp.clamp(14.0, 16.0),
                            color: AppTheme.textMediumEmphasisLight,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Primary authentication button
                  PrimaryAuthButtonWidget(
                    onPressed: _handleGovernmentAuth,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Biometric authentication option
                  BiometricAuthWidget(
                    onBiometricPressed: _handleBiometricAuth,
                    isAvailable: _isBiometricAvailable,
                  ),

                  SizedBox(height: 6.h),

                  // Legal compliance section
                  LegalComplianceWidget(),

                  SizedBox(height: 4.h),

                  // Footer with additional info
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'shield',
                              color: AppTheme.successLight,
                              size: 4.w.clamp(16.0, 20.0),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Защищено государственной системой',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 10.sp.clamp(11.0, 13.0),
                                color: AppTheme.successLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Версия 1.0.0 • © 2024 SafeLend',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 9.sp.clamp(10.0, 12.0),
                            color: AppTheme.textDisabledLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}