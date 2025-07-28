// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SafeLend';

  @override
  String get profile => 'Profile';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get registrationDate => 'Registration Date';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get languageInterface => 'Interface Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed to English';

  @override
  String get security => 'Security';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get biometricEnabled => 'Biometric authentication enabled';

  @override
  String get biometricDisabled => 'Biometric authentication disabled';

  @override
  String get sessionManagement => 'Session Management';

  @override
  String get activeSessions => 'Active sessions and devices';

  @override
  String get documents => 'Documents';

  @override
  String get myDocuments => 'My Documents';

  @override
  String documentsCount(int count) {
    return '$count documents';
  }

  @override
  String get downloadedFiles => 'Downloaded Files';

  @override
  String get manageLocalFiles => 'Manage local files';

  @override
  String get legalInfo => 'Legal Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'Federal Law No. 152-FZ on personal data';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get userAgreement => 'User agreement';

  @override
  String get legalDisclaimer => 'Legal Disclaimer';

  @override
  String get disclaimerDescription => 'The app does not issue loans';

  @override
  String get support => 'Support';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get faqDescription => 'FAQ and user guide';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get supportDescription => 'Email and phone support service';

  @override
  String get appVersion => 'App Version';

  @override
  String get logout => 'Logout';

  @override
  String get close => 'Close';

  @override
  String get understand => 'Understand';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get latestVersion => 'You have the latest version of the app';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get loanRequests => 'Loan Requests';

  @override
  String get statusUpdates => 'Status Updates';

  @override
  String get marketing => 'Marketing';

  @override
  String get currentDevice => 'Current Device';

  @override
  String get active => 'Active';

  @override
  String get privacyPolicyContent => 'The privacy policy in accordance with Federal Law No. 152-FZ will be displayed here.';

  @override
  String get termsContent => 'The terms of use of the SafeLend application will be displayed here.';

  @override
  String get disclaimerContent => 'SafeLend is a platform for document management between individuals. The application does not issue loans and is not a credit organization.';

  @override
  String get supportEmail => 'Email: support@safelend.ru';

  @override
  String get supportPhone => 'Phone: +7 (800) 123-45-67';

  @override
  String get supportHours => 'Working hours: Mon-Fri 9:00-18:00 MSK';

  @override
  String get faqQuestion1 => 'Q: How to create a loan?';

  @override
  String get faqAnswer1 => 'A: Go to the \"Create Loan\" section and fill in the required fields.';

  @override
  String get faqQuestion2 => 'Q: How to verify identity?';

  @override
  String get faqAnswer2 => 'A: Use integration with Gosuslugi for verification.';

  @override
  String get encryptedStorage => 'All downloaded documents are stored encrypted on your device.';
}
