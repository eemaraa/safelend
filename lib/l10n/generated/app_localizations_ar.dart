// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'SafeLend';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get name => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get registrationDate => 'تاريخ التسجيل';

  @override
  String get appPreferences => 'إعدادات التطبيق';

  @override
  String get languageInterface => 'لغة الواجهة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get russian => 'الروسية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة إلى العربية';

  @override
  String get security => 'الأمان';

  @override
  String get biometricAuth => 'المصادقة البيومترية';

  @override
  String get enabled => 'مفعل';

  @override
  String get disabled => 'معطل';

  @override
  String get biometricEnabled => 'تم تفعيل المصادقة البيومترية';

  @override
  String get biometricDisabled => 'تم تعطيل المصادقة البيومترية';

  @override
  String get sessionManagement => 'إدارة الجلسات';

  @override
  String get activeSessions => 'الأجهزة والجلسات النشطة';

  @override
  String get documents => 'المستندات';

  @override
  String get myDocuments => 'مستنداتي';

  @override
  String documentsCount(int count) {
    return '$count مستندات';
  }

  @override
  String get downloadedFiles => 'الملفات المحملة';

  @override
  String get manageLocalFiles => 'إدارة الملفات المحلية';

  @override
  String get legalInfo => 'المعلومات القانونية';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyDescription => 'القانون الفيدرالي رقم 152-FZ حول البيانات الشخصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get userAgreement => 'اتفاقية المستخدم';

  @override
  String get legalDisclaimer => 'إخلاء المسؤولية القانوني';

  @override
  String get disclaimerDescription => 'التطبيق لا يصدر قروضاً';

  @override
  String get support => 'الدعم';

  @override
  String get faq => 'الأسئلة المتكررة';

  @override
  String get faqDescription => 'الأسئلة الشائعة ودليل المستخدم';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get supportDescription => 'البريد الإلكتروني وهاتف خدمة الدعم';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get close => 'إغلاق';

  @override
  String get understand => 'مفهوم';

  @override
  String get clearCache => 'مسح التخزين المؤقت';

  @override
  String get checkForUpdates => 'فحص التحديثات';

  @override
  String get latestVersion => 'لديك أحدث إصدار من التطبيق';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get loanRequests => 'طلبات القروض';

  @override
  String get statusUpdates => 'تحديثات الحالة';

  @override
  String get marketing => 'التسويق';

  @override
  String get currentDevice => 'الجهاز الحالي';

  @override
  String get active => 'نشط';

  @override
  String get privacyPolicyContent => 'ستعرض هنا سياسة الخصوصية وفقاً للقانون الفيدرالي رقم 152-FZ.';

  @override
  String get termsContent => 'ستعرض هنا شروط استخدام تطبيق SafeLend.';

  @override
  String get disclaimerContent => 'SafeLend هي منصة لإدارة المستندات بين الأفراد. التطبيق لا يصدر قروضاً وليس مؤسسة ائتمانية.';

  @override
  String get supportEmail => 'البريد الإلكتروني: support@safelend.ru';

  @override
  String get supportPhone => 'الهاتف: +7 (800) 123-45-67';

  @override
  String get supportHours => 'ساعات العمل: الإثنين-الجمعة 9:00-18:00 بتوقيت موسكو';

  @override
  String get faqQuestion1 => 'س: كيفية إنشاء قرض؟';

  @override
  String get faqAnswer1 => 'ج: انتقل إلى قسم \"إنشاء قرض\" واملأ الحقول المطلوبة.';

  @override
  String get faqQuestion2 => 'س: كيفية التحقق من الهوية؟';

  @override
  String get faqAnswer2 => 'ج: استخدم التكامل مع Gosuslugi للتحقق.';

  @override
  String get encryptedStorage => 'جميع المستندات المحملة مخزنة مشفرة على جهازك.';
}
