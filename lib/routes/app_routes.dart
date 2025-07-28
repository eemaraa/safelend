import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/loan_dashboard/loan_dashboard.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/loan_request_details/loan_request_details.dart';
import '../presentation/create_loan_request/create_loan_request.dart';
import '../presentation/contract_management/contract_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String authenticationScreen = '/authentication-screen';
  static const String loanDashboard = '/loan-dashboard';
  static const String userProfile = '/user-profile';
  static const String loanRequestDetails = '/loan-request-details';
  static const String createLoanRequest = '/create-loan-request';
  static const String contractManagement = '/contract-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    authenticationScreen: (context) => const AuthenticationScreen(),
    loanDashboard: (context) => const LoanDashboard(),
    userProfile: (context) => const UserProfile(),
    loanRequestDetails: (context) => const LoanRequestDetails(),
    createLoanRequest: (context) => const CreateLoanRequest(),
    contractManagement: (context) => const ContractManagement(),
    // TODO: Add your other routes here
  };
}
