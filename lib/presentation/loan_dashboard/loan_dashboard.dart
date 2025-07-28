import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/loan_card_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/section_header_widget.dart';

class LoanDashboard extends StatefulWidget {
  const LoanDashboard({super.key});

  @override
  State<LoanDashboard> createState() => _LoanDashboardState();
}

class _LoanDashboardState extends State<LoanDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  bool _isOffline = false;
  DateTime? _lastUpdated;

  // Mock data for loan dashboard
  final List<Map<String, dynamic>> _loanData = [
    {
      "id": 1,
      "amount": "50000.00",
      "counterparty": "Иван Петров",
      "status": "pending",
      "dueDate": DateTime.now().add(const Duration(days: 15)),
      "isUrgent": false,
      "hasNotification": true,
      "interestRate": 12.5,
      "createdDate": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "id": 2,
      "amount": "25000.00",
      "counterparty": "Мария Сидорова",
      "status": "approved",
      "dueDate": DateTime.now().add(const Duration(days: 7)),
      "isUrgent": true,
      "hasNotification": false,
      "interestRate": 15.0,
      "createdDate": DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      "id": 3,
      "amount": "100000.00",
      "counterparty": "Алексей Козлов",
      "status": "active",
      "dueDate": DateTime.now().add(const Duration(days: 30)),
      "isUrgent": false,
      "hasNotification": true,
      "interestRate": 10.0,
      "createdDate": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "id": 4,
      "amount": "15000.00",
      "counterparty": "Елена Волкова",
      "status": "rejected",
      "dueDate": DateTime.now().subtract(const Duration(days: 2)),
      "isUrgent": false,
      "hasNotification": false,
      "interestRate": 18.0,
      "createdDate": DateTime.now().subtract(const Duration(days: 7)),
    },
  ];

  final String _userName = "Александр Николаевич";
  final bool _isVerified = true;

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
    _checkConnectivity();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // Set to true to test offline mode
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _lastUpdated = DateTime.now();
        _isOffline = false;
      });
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/create-loan-request');
        break;
      case 2:
        Navigator.pushNamed(context, '/contract-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _createNewLoan() {
    Navigator.pushNamed(context, '/create-loan-request');
  }

  void _viewLoanDetails(Map<String, dynamic> loan) {
    Navigator.pushNamed(
      context,
      '/loan-request-details',
      arguments: loan,
    );
  }

  void _downloadPdf(Map<String, dynamic> loan) {
    // Implement PDF download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Скачивание PDF для займа ₽${loan['amount']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendReminder(Map<String, dynamic> loan) {
    // Implement reminder functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Напоминание отправлено ${loan['counterparty']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _archiveLoan(Map<String, dynamic> loan) {
    setState(() {
      _loanData.removeWhere((item) => item['id'] == loan['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Займ архивирован'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _loanData.add(loan);
            });
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _activeLoans {
    return _loanData
        .where((loan) =>
            loan['status'] == 'active' || loan['status'] == 'approved')
        .toList();
  }

  List<Map<String, dynamic>> get _pendingLoans {
    return _loanData.where((loan) => loan['status'] == 'pending').toList();
  }

  List<Map<String, dynamic>> get _recentContracts {
    return _loanData
        .where((loan) =>
            loan['status'] == 'approved' || loan['status'] == 'active')
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          DashboardHeaderWidget(
            userName: _userName,
            isVerified: _isVerified,
            onProfileTap: () => Navigator.pushNamed(context, '/user-profile'),
          ),
          OfflineIndicatorWidget(
            isOffline: _isOffline,
            lastUpdated: _lastUpdated,
          ),
          Expanded(
            child: _loanData.isEmpty
                ? EmptyStateWidget(onCreateLoan: _createNewLoan)
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),

                          // Active Loans Section
                          if (_activeLoans.isNotEmpty) ...[
                            SectionHeaderWidget(
                              title: 'Активные займы',
                              subtitle: '${_activeLoans.length} активных',
                              showSeeAll: _activeLoans.length > 2,
                              onSeeAll: () => Navigator.pushNamed(
                                  context, '/contract-management'),
                            ),
                            SizedBox(height: 1.h),
                            ..._activeLoans
                                .take(2)
                                .map((loan) => LoanCardWidget(
                                      loanData: loan,
                                      onTap: () => _viewLoanDetails(loan),
                                      onViewDetails: () =>
                                          _viewLoanDetails(loan),
                                      onDownloadPdf: () => _downloadPdf(loan),
                                      onSendReminder: () => _sendReminder(loan),
                                      onArchive: () => _archiveLoan(loan),
                                    )),
                            SizedBox(height: 2.h),
                          ],

                          // Pending Approvals Section
                          if (_pendingLoans.isNotEmpty) ...[
                            SectionHeaderWidget(
                              title: 'Ожидают одобрения',
                              subtitle: '${_pendingLoans.length} запросов',
                              showSeeAll: _pendingLoans.length > 2,
                            ),
                            SizedBox(height: 1.h),
                            ..._pendingLoans
                                .take(2)
                                .map((loan) => LoanCardWidget(
                                      loanData: loan,
                                      onTap: () => _viewLoanDetails(loan),
                                      onViewDetails: () =>
                                          _viewLoanDetails(loan),
                                      onDownloadPdf: () => _downloadPdf(loan),
                                      onSendReminder: () => _sendReminder(loan),
                                      onArchive: () => _archiveLoan(loan),
                                    )),
                            SizedBox(height: 2.h),
                          ],

                          // Recent Contracts Section
                          if (_recentContracts.isNotEmpty) ...[
                            SectionHeaderWidget(
                              title: 'Недавние договоры',
                              subtitle: 'Последние подписанные',
                              showSeeAll: true,
                              onSeeAll: () => Navigator.pushNamed(
                                  context, '/contract-management'),
                            ),
                            SizedBox(height: 1.h),
                            ..._recentContracts.map((loan) => LoanCardWidget(
                                  loanData: loan,
                                  onTap: () => _viewLoanDetails(loan),
                                  onViewDetails: () => _viewLoanDetails(loan),
                                  onDownloadPdf: () => _downloadPdf(loan),
                                  onSendReminder: () => _sendReminder(loan),
                                  onArchive: () => _archiveLoan(loan),
                                )),
                          ],

                          SizedBox(height: 10.h), // Bottom padding for FAB
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Создать',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Профиль',
          ),
        ],
      ),
      floatingActionButton: _loanData.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _createNewLoan,
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 24,
              ),
              label: Text(
                'Новый займ',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
