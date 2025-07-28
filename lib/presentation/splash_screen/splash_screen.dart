import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/government_badge_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  String _loadingText = 'Инициализация...';
  bool _showRetryButton = false;
  bool _isLoading = true;
  bool _logoAnimationComplete = false;

  // Mock initialization states
  bool _authStatusChecked = false;
  bool _languagePreferencesLoaded = false;
  bool _loanDataCached = false;

  @override
  void initState() {
    super.initState();
    _initializeBackgroundAnimation();
    _setSystemUIOverlay();
    _startInitializationProcess();
  }

  void _initializeBackgroundAnimation() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _startInitializationProcess() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _checkAuthenticationStatus();
    });
  }

  void _checkAuthenticationStatus() {
    setState(() {
      _loadingText = 'Проверка статуса аутентификации...';
    });

    // Simulate Госуслуги authentication check
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _authStatusChecked = true;
        });
        _loadLanguagePreferences();
      }
    });
  }

  void _loadLanguagePreferences() {
    setState(() {
      _loadingText = 'Загрузка языковых настроек...';
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _languagePreferencesLoaded = true;
        });
        _cacheLoanData();
      }
    });
  }

  void _cacheLoanData() {
    setState(() {
      _loadingText = 'Подготовка данных займов...';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _loanDataCached = true;
          _loadingText = 'Завершение инициализации...';
        });
        _completeInitialization();
      }
    });
  }

  void _completeInitialization() {
    if (_authStatusChecked &&
        _languagePreferencesLoaded &&
        _loanDataCached &&
        _logoAnimationComplete) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _navigateToNextScreen();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    // Mock authentication status - in real app, check actual auth state
    final bool isAuthenticated = DateTime.now().millisecondsSinceEpoch % 3 == 0;
    final bool isFirstTime = DateTime.now().millisecondsSinceEpoch % 4 == 0;

    String nextRoute;
    if (isAuthenticated) {
      nextRoute = '/loan-dashboard';
    } else if (isFirstTime) {
      nextRoute = '/onboarding-flow';
    } else {
      nextRoute = '/authentication-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handleNetworkTimeout() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showRetryButton = true;
        _loadingText = '';
      });
    }
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _showRetryButton = false;
      _authStatusChecked = false;
      _languagePreferencesLoaded = false;
      _loanDataCached = false;
      _logoAnimationComplete = false;
    });
    _startInitializationProcess();
  }

  void _onLogoAnimationComplete() {
    setState(() {
      _logoAnimationComplete = true;
    });

    if (_authStatusChecked && _languagePreferencesLoaded && _loanDataCached) {
      _completeInitialization();
    }

    // Start timeout timer after logo animation
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isLoading) {
        _handleNetworkTimeout();
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.scaffoldBackgroundColor,
                  _backgroundAnimation.value ??
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                  AppTheme.lightTheme.scaffoldBackgroundColor,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedLogoWidget(
                          onAnimationComplete: _onLogoAnimationComplete,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isLoading
                              ? LoadingIndicatorWidget(
                                  loadingText: _loadingText,
                                  showProgress: true,
                                )
                              : RetryButtonWidget(
                                  onRetry: _retryInitialization,
                                  isVisible: _showRetryButton,
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GovernmentBadgeWidget(
                            isVisible: _logoAnimationComplete,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Приложение не выдает займы.\nТолько документооборот между частными лицами.',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
