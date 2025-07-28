import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/contract_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/search_bar_widget.dart';

class ContractManagement extends StatefulWidget {
  const ContractManagement({Key? key}) : super(key: key);

  @override
  State<ContractManagement> createState() => _ContractManagementState();
}

class _ContractManagementState extends State<ContractManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // State variables
  List<Map<String, dynamic>> _allContracts = [];
  List<Map<String, dynamic>> _filteredContracts = [];
  Map<String, dynamic> _currentFilters = {};
  String _searchQuery = '';
  bool _isOffline = false;
  bool _isSyncing = false;
  bool _showFilters = false;

  // Mock data for contracts
  final List<Map<String, dynamic>> _mockContracts = [
    {
      "contractId": "SL-2025-001",
      "lenderName": "Александр Петров",
      "borrowerName": "Мария Иванова",
      "amount": "150,000",
      "signingDate": "15.01.2025",
      "status": "Active",
      "lenderVerified": true,
      "borrowerVerified": true,
      "terms": {
        "interestRate": "12.5",
        "repaymentPeriod": "12 месяцев",
        "lateFee": "2.0"
      },
      "paymentSchedule": [
        {"date": "15.02.2025", "amount": "13,500", "isPaid": true},
        {"date": "15.03.2025", "amount": "13,500", "isPaid": false},
        {"date": "15.04.2025", "amount": "13,500", "isPaid": false},
      ]
    },
    {
      "contractId": "SL-2025-002",
      "lenderName": "Елена Смирнова",
      "borrowerName": "Дмитрий Козлов",
      "amount": "75,000",
      "signingDate": "22.01.2025",
      "status": "Completed",
      "lenderVerified": true,
      "borrowerVerified": false,
      "terms": {
        "interestRate": "10.0",
        "repaymentPeriod": "6 месяцев",
        "lateFee": "1.5"
      },
      "paymentSchedule": [
        {"date": "22.02.2025", "amount": "13,125", "isPaid": true},
        {"date": "22.03.2025", "amount": "13,125", "isPaid": true},
        {"date": "22.04.2025", "amount": "13,125", "isPaid": true},
      ]
    },
    {
      "contractId": "SL-2025-003",
      "lenderName": "Игорь Волков",
      "borrowerName": "Анна Федорова",
      "amount": "300,000",
      "signingDate": "10.01.2025",
      "status": "Overdue",
      "lenderVerified": true,
      "borrowerVerified": true,
      "terms": {
        "interestRate": "15.0",
        "repaymentPeriod": "24 месяца",
        "lateFee": "3.0"
      },
      "paymentSchedule": [
        {"date": "10.02.2025", "amount": "14,375", "isPaid": false},
        {"date": "10.03.2025", "amount": "14,375", "isPaid": false},
        {"date": "10.04.2025", "amount": "14,375", "isPaid": false},
      ]
    },
    {
      "contractId": "SL-2025-004",
      "lenderName": "Ольга Морозова",
      "borrowerName": "Сергей Новиков",
      "amount": "45,000",
      "signingDate": "28.01.2025",
      "status": "Active",
      "lenderVerified": false,
      "borrowerVerified": true,
      "terms": {
        "interestRate": "8.5",
        "repaymentPeriod": "3 месяца",
        "lateFee": "1.0"
      },
      "paymentSchedule": [
        {"date": "28.02.2025", "amount": "15,283", "isPaid": true},
        {"date": "28.03.2025", "amount": "15,283", "isPaid": false},
        {"date": "28.04.2025", "amount": "15,283", "isPaid": false},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _allContracts = List.from(_mockContracts);
      _filteredContracts = List.from(_allContracts);
    });
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // In real app, use connectivity_plus package
    });
  }

  void _syncData() async {
    setState(() {
      _isSyncing = true;
    });

    // Simulate sync delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSyncing = false;
      _isOffline = false;
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allContracts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((contract) {
        final searchLower = _searchQuery.toLowerCase();
        return (contract['contractId'] as String? ?? '')
                .toLowerCase()
                .contains(searchLower) ||
            (contract['lenderName'] as String? ?? '')
                .toLowerCase()
                .contains(searchLower) ||
            (contract['borrowerName'] as String? ?? '')
                .toLowerCase()
                .contains(searchLower) ||
            (contract['amount'] as String? ?? '')
                .toLowerCase()
                .contains(searchLower);
      }).toList();
    }

    // Apply status filter
    if (_currentFilters['status'] != null) {
      final statusFilter = _currentFilters['status'] as String;
      filtered = filtered.where((contract) {
        final status = (contract['status'] as String? ?? '').toLowerCase();
        return status == statusFilter;
      }).toList();
    }

    // Apply date range filter
    if (_currentFilters['dateRange'] != null) {
      final dateFilter = _currentFilters['dateRange'] as String;
      final now = DateTime.now();

      filtered = filtered.where((contract) {
        try {
          final dateParts =
              (contract['signingDate'] as String? ?? '').split('.');
          if (dateParts.length == 3) {
            final contractDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );

            switch (dateFilter) {
              case 'today':
                return contractDate.day == now.day &&
                    contractDate.month == now.month &&
                    contractDate.year == now.year;
              case 'week':
                final weekAgo = now.subtract(const Duration(days: 7));
                return contractDate.isAfter(weekAgo);
              case 'month':
                return contractDate.month == now.month &&
                    contractDate.year == now.year;
              case 'year':
                return contractDate.year == now.year;
              default:
                return true;
            }
          }
          return true;
        } catch (e) {
          return true;
        }
      }).toList();
    }

    // Apply amount range filter
    if (_currentFilters['amountRange'] != null) {
      final amountFilter = _currentFilters['amountRange'] as String;
      filtered = filtered.where((contract) {
        try {
          final amountStr =
              (contract['amount'] as String? ?? '').replaceAll(',', '');
          final amount = double.tryParse(amountStr) ?? 0;

          switch (amountFilter) {
            case 'small':
              return amount < 50000;
            case 'medium':
              return amount >= 50000 && amount <= 500000;
            case 'large':
              return amount > 500000;
            default:
              return true;
          }
        } catch (e) {
          return true;
        }
      }).toList();
    }

    setState(() {
      _filteredContracts = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
    });
    _applyFilters();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  // PDF Generation and Download
  Future<void> _downloadContractPDF(Map<String, dynamic> contract) async {
    try {
      final contractContent = _generateContractPDF(contract);
      final fileName = 'contract_${contract['contractId']}.pdf';

      // For mobile platforms, would use path_provider and share_plus
      // This is a simplified version for demo
      print('PDF downloaded: $fileName');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF договора успешно скачан'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при скачивании PDF'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  String _generateContractPDF(Map<String, dynamic> contract) {
    return '''
ДОГОВОР ЗАЙМА №${contract['contractId']}

Дата подписания: ${contract['signingDate']}

СТОРОНЫ:
Займодавец: ${contract['lenderName']}
Заемщик: ${contract['borrowerName']}

УСЛОВИЯ:
Сумма займа: ${contract['amount']} ₽
Процентная ставка: ${contract['terms']['interestRate']}%
Срок погашения: ${contract['terms']['repaymentPeriod']}
Штраф за просрочку: ${contract['terms']['lateFee']}%

Статус: ${contract['status']}

Документ создан через SafeLend
''';
  }

  void _shareContract(Map<String, dynamic> contract) {
    // In real implementation, would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Функция поделиться договором'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _setReminder(Map<String, dynamic> contract) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Установить напоминание'),
        content: Text('Напоминание для договора #${contract['contractId']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Напоминание установлено')),
              );
            },
            child: Text('Установить'),
          ),
        ],
      ),
    );
  }

  void _archiveContract(Map<String, dynamic> contract) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Договор #${contract['contractId']} архивирован'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _duplicateContract(Map<String, dynamic> contract) {
    Navigator.pushNamed(context, '/create-loan-request');
  }

  void _reportIssue(Map<String, dynamic> contract) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Сообщить о проблеме'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Опишите проблему с договором #${contract['contractId']}'),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Описание проблемы...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Сообщение отправлено')),
              );
            },
            child: Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _createLoanRequest() {
    Navigator.pushNamed(context, '/create-loan-request');
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Все'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Активные'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'task_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Завершенные'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Просроченные'),
              ],
            ),
          ),
        ],
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
      ),
    );
  }

  Widget _buildContractsList() {
    if (_filteredContracts.isEmpty) {
      return _searchQuery.isNotEmpty || _currentFilters.isNotEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'search_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Договоры не найдены',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Попробуйте изменить параметры поиска или фильтры',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : EmptyStateWidget(onCreateLoanRequest: _createLoanRequest);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: _filteredContracts.length,
      itemBuilder: (context, index) {
        final contract = _filteredContracts[index];
        return ContractCardWidget(
          contract: contract,
          onDownload: () => _downloadContractPDF(contract),
          onShare: () => _shareContract(contract),
          onSetReminder: () => _setReminder(contract),
          onArchive: () => _archiveContract(contract),
          onDuplicate: () => _duplicateContract(contract),
          onReportIssue: () => _reportIssue(contract),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Управление договорами',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _syncData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: _buildTabBar(),
        ),
      ),
      body: Column(
        children: [
          OfflineIndicatorWidget(
            isOffline: _isOffline,
            isSyncing: _isSyncing,
            onRetrySync: _syncData,
          ),
          SearchBarWidget(
            onSearchChanged: _onSearchChanged,
            initialQuery: _searchQuery,
            onFilterTap: _toggleFilters,
          ),
          if (_showFilters)
            FilterChipsWidget(
              onFiltersChanged: _onFiltersChanged,
              initialFilters: _currentFilters,
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContractsList(), // All contracts
                _buildContractsList(), // Active contracts
                _buildContractsList(), // Completed contracts
                _buildContractsList(), // Overdue contracts
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createLoanRequest,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Новый займ',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
