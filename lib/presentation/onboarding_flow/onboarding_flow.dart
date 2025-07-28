import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector_widget.dart';
import './widgets/navigation_buttons_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import '../../l10n/generated/app_localizations.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  String _selectedLanguage = 'ru';
  bool _showLanguageSelector = false;

  // Mock onboarding data with Russian cultural context
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'image':
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'titleRu': 'Безопасные займы через Госуслуги',
      'titleEn': 'Secure Loans via Government Services',
      'titleAr': 'قروض آمنة عبر الخدمات الحكومية',
      'descriptionRu':
          'Создавайте и управляйте личными займами с проверкой личности через официальную систему Госуслуги России',
      'descriptionEn':
          'Create and manage personal loans with identity verification through Russia\'s official Government Services system',
      'descriptionAr':
          'إنشاء وإدارة القروض الشخصية مع التحقق من الهوية من خلال نظام الخدمات الحكومية الرسمي في روسيا',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'titleRu': 'Простое создание заявок',
      'titleEn': 'Easy Loan Request Creation',
      'titleAr': 'إنشاء طلبات القروض بسهولة',
      'descriptionRu':
          'Укажите сумму, срок возврата и процентную ставку за просрочку. Отправьте заявку конкретному получателю одним касанием',
      'descriptionEn':
          'Specify amount, repayment date, and late interest rate. Send requests to specific recipients with one tap',
      'descriptionAr':
          'حدد المبلغ وتاريخ السداد ومعدل الفائدة المتأخرة. أرسل الطلبات إلى مستلمين محددين بلمسة واحدة',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'titleRu': 'Цифровые договоры и PDF',
      'titleEn': 'Digital Contracts & PDF Export',
      'titleAr': 'العقود الرقمية وتصدير PDF',
      'descriptionRu':
          'Автоматическое создание юридически значимых договоров при принятии заявки. Скачивайте подписанные соглашения в PDF',
      'descriptionEn':
          'Automatic generation of legally binding contracts upon request acceptance. Download signed agreements as PDF',
      'descriptionAr':
          'إنشاء تلقائي للعقود الملزمة قانونياً عند قبول الطلب. تحميل الاتفاقيات الموقعة بصيغة PDF',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'titleRu': 'Защита данных по ФЗ-152',
      'titleEn': 'Data Protection & Security',
      'titleAr': 'حماية البيانات والأمان',
      'descriptionRu':
          'Полное соответствие Федеральному закону №152-ФЗ о защите персональных данных. Шифрование документов и безопасное хранение',
      'descriptionEn':
          'Full compliance with Russian Federal Law No. 152-FZ on personal data protection. Document encryption and secure storage',
      'descriptionAr':
          'امتثال كامل للقانون الفيدرالي الروسي رقم 152-FZ حول حماية البيانات الشخصية. تشفير المستندات والتخزين الآمن',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Haptic feedback on iOS
    HapticFeedback.lightImpact();
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
      _showLanguageSelector = false;
    });

    // Animate content change
    _fadeController.reset();
    _fadeController.forward();
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/authentication-screen');
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _getStarted() {
    // Mark onboarding as completed (would use SharedPreferences in real app)
    Navigator.pushReplacementNamed(context, '/authentication-screen');
  }

  String _getLocalizedText(Map<String, dynamic> data, String key) {
    switch (_selectedLanguage) {
      case 'ru':
        return data['${key}Ru'] ?? '';
      case 'en':
        return data['${key}En'] ?? '';
      case 'ar':
        return data['${key}Ar'] ?? '';
      default:
        return data['${key}Ru'] ?? '';
    }
  }

  Map<String, String> get _localizedStrings {
    switch (_selectedLanguage) {
      case 'ru':
        return {
          'skip': 'Пропустить',
          'next': 'Далее',
          'getStarted': 'Начать',
        };
      case 'en':
        return {
          'skip': 'Skip',
          'next': 'Next',
          'getStarted': 'Get Started',
        };
      case 'ar':
        return {
          'skip': 'تخطي',
          'next': 'التالي',
          'getStarted': 'ابدأ',
        };
      default:
        return {
          'skip': 'Пропустить',
          'next': 'Далее',
          'getStarted': 'Начать',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _selectedLanguage == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Top bar with language selector
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SafeLend logo
                      Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: CustomIconWidget(
                              iconName: 'account_balance',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 6.w,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'SafeLend',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      // Language selector button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showLanguageSelector = !_showLanguageSelector;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'language',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 5.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                _selectedLanguage.toUpperCase(),
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page view
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _onboardingData.length,
                      itemBuilder: (context, index) {
                        final data = _onboardingData[index];
                        return OnboardingPageWidget(
                          imagePath: data['image'],
                          title: _getLocalizedText(data, 'title'),
                          description: _getLocalizedText(data, 'description'),
                          isRTL: isRTL,
                        );
                      },
                    ),
                  ),
                ),

                // Page indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),
                ),

                // Navigation buttons
                NavigationButtonsWidget(
                  currentPage: _currentPage,
                  totalPages: _onboardingData.length,
                  onSkip: _skipOnboarding,
                  onNext: _nextPage,
                  onGetStarted: _getStarted,
                  skipText: _localizedStrings['skip']!,
                  nextText: _localizedStrings['next']!,
                  getStartedText: _localizedStrings['getStarted']!,
                ),
              ],
            ),

            // Language selector overlay
            if (_showLanguageSelector)
              Positioned(
                top: 12.h,
                right: 4.w,
                child: Material(
                  color: Colors.transparent,
                  child: LanguageSelectorWidget(
                    selectedLanguage: _selectedLanguage,
                    onLanguageChanged: _onLanguageChanged,
                  ),
                ),
              ),

            // Tap outside to close language selector
            if (_showLanguageSelector)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showLanguageSelector = false;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
