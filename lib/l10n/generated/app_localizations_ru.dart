// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SafeLend';

  @override
  String get profile => 'Профиль';

  @override
  String get accountInformation => 'Информация об аккаунте';

  @override
  String get name => 'Имя';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Телефон';

  @override
  String get registrationDate => 'Дата регистрации';

  @override
  String get appPreferences => 'Настройки приложения';

  @override
  String get languageInterface => 'Язык интерфейса';

  @override
  String get notifications => 'Уведомления';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get languageChanged => 'Язык изменен на русский';

  @override
  String get security => 'Безопасность';

  @override
  String get biometricAuth => 'Биометрическая аутентификация';

  @override
  String get enabled => 'Включена';

  @override
  String get disabled => 'Отключена';

  @override
  String get biometricEnabled => 'Биометрическая аутентификация включена';

  @override
  String get biometricDisabled => 'Биометрическая аутентификация отключена';

  @override
  String get sessionManagement => 'Управление сессиями';

  @override
  String get activeSessions => 'Активные устройства и сессии';

  @override
  String get documents => 'Документы';

  @override
  String get myDocuments => 'Мои документы';

  @override
  String documentsCount(int count) {
    return '$count документов';
  }

  @override
  String get downloadedFiles => 'Загруженные файлы';

  @override
  String get manageLocalFiles => 'Управление локальными файлами';

  @override
  String get legalInfo => 'Правовая информация';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyDescription => 'ФЗ № 152-ФЗ о персональных данных';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get userAgreement => 'Пользовательское соглашение';

  @override
  String get legalDisclaimer => 'Правовой дисклеймер';

  @override
  String get disclaimerDescription => 'Приложение не выдает займы';

  @override
  String get support => 'Поддержка';

  @override
  String get faq => 'Часто задаваемые вопросы';

  @override
  String get faqDescription => 'FAQ и руководство пользователя';

  @override
  String get contactSupport => 'Связаться с поддержкой';

  @override
  String get supportDescription => 'Email и телефон службы поддержки';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get logout => 'Выйти';

  @override
  String get close => 'Закрыть';

  @override
  String get understand => 'Понятно';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get latestVersion => 'У вас установлена последняя версия приложения';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get loanRequests => 'Заявки на займы';

  @override
  String get statusUpdates => 'Обновления статуса';

  @override
  String get marketing => 'Маркетинг';

  @override
  String get currentDevice => 'Текущее устройство';

  @override
  String get active => 'Активна';

  @override
  String get privacyPolicyContent => 'Здесь будет отображена политика конфиденциальности в соответствии с Федеральным законом № 152-ФЗ.';

  @override
  String get termsContent => 'Здесь будут отображены условия использования приложения SafeLend.';

  @override
  String get disclaimerContent => 'SafeLend является платформой для документооборота между частными лицами. Приложение не выдает займы и не является кредитной организацией.';

  @override
  String get supportEmail => 'Email: support@safelend.ru';

  @override
  String get supportPhone => 'Телефон: +7 (800) 123-45-67';

  @override
  String get supportHours => 'Время работы: Пн-Пт 9:00-18:00 МСК';

  @override
  String get faqQuestion1 => 'В: Как создать займ?';

  @override
  String get faqAnswer1 => 'О: Перейдите в раздел \"Создать займ\" и заполните необходимые поля.';

  @override
  String get faqQuestion2 => 'В: Как подтвердить личность?';

  @override
  String get faqAnswer2 => 'О: Используйте интеграцию с Госуслугами для верификации.';

  @override
  String get encryptedStorage => 'Все загруженные документы хранятся в зашифрованном виде на вашем устройстве.';
}
