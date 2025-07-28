import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/additional_notes_widget.dart';
import './widgets/interest_rate_input_widget.dart';
import './widgets/loan_amount_input_widget.dart';
import './widgets/recipient_selection_widget.dart';
import './widgets/repayment_date_picker_widget.dart';
import './widgets/terms_agreement_widget.dart';

class CreateLoanRequest extends StatefulWidget {
  const CreateLoanRequest({Key? key}) : super(key: key);

  @override
  State<CreateLoanRequest> createState() => _CreateLoanRequestState();
}

class _CreateLoanRequestState extends State<CreateLoanRequest> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _notesController = TextEditingController();

  // Form state
  DateTime? _selectedDate;
  bool _isTermsAgreed = false;
  bool _isLoading = false;

  // Validation errors
  String? _amountError;
  String? _recipientError;
  String? _dateError;
  String? _interestRateError;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _interestRateController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _amountError = null;
      _recipientError = null;
      _dateError = null;
      _interestRateError = null;
    });

    bool isValid = true;

    // Validate amount
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = 'Укажите сумму займа';
      });
      isValid = false;
    } else {
      final amount =
          double.tryParse(_amountController.text.replaceAll(' ', ''));
      if (amount == null || amount <= 0) {
        setState(() {
          _amountError = 'Введите корректную сумму';
        });
        isValid = false;
      } else if (amount > 5000000) {
        setState(() {
          _amountError = 'Максимальная сумма: 5 000 000 ₽';
        });
        isValid = false;
      }
    }

    // Validate recipient
    if (_recipientController.text.isEmpty) {
      setState(() {
        _recipientError = 'Выберите получателя займа';
      });
      isValid = false;
    }

    // Validate date
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Выберите дату возврата';
      });
      isValid = false;
    } else if (_selectedDate!.isBefore(DateTime.now().add(Duration(days: 1)))) {
      setState(() {
        _dateError = 'Дата возврата должна быть не ранее завтра';
      });
      isValid = false;
    }

    // Validate interest rate
    if (_interestRateController.text.isNotEmpty) {
      final rate =
          double.tryParse(_interestRateController.text.replaceAll(',', '.'));
      if (rate == null || rate < 0) {
        setState(() {
          _interestRateError = 'Введите корректную процентную ставку';
        });
        isValid = false;
      } else if (rate > 20) {
        setState(() {
          _interestRateError = 'Максимальная ставка по закону РФ: 20%';
        });
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _createLoanRequest() async {
    if (!_validateForm() || !_isTermsAgreed) {
      if (!_isTermsAgreed) {
        _showErrorSnackBar('Необходимо согласиться с условиями');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Generate mock request ID
      final requestId =
          'LR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      _showSuccessDialog(requestId);
    } catch (e) {
      _showErrorSnackBar('Произошла ошибка при создании запроса');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String requestId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Запрос создан!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'ID запроса: $requestId',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Запрос отправлен получателю. Вы получите уведомление о статусе.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSharingOptions(requestId);
                  },
                  child: Text('Поделиться'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/loan-dashboard');
                  },
                  child: Text('Готово'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSharingOptions(String requestId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Поделиться запросом',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSharingOption(
                          'sms', 'SMS', () => Navigator.pop(context)),
                      _buildSharingOption(
                          'email', 'Email', () => Navigator.pop(context)),
                      _buildSharingOption(
                          'share', 'Другое', () => Navigator.pop(context)),
                    ],
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharingOption(String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Создать запрос'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'account_balance_wallet',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 32,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Создание запроса на займ',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Заполните форму для создания официального запроса на займ с юридической силой',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Loan amount input
                    LoanAmountInputWidget(
                      controller: _amountController,
                      onChanged: (value) {
                        if (_amountError != null) {
                          setState(() {
                            _amountError = null;
                          });
                        }
                      },
                      errorText: _amountError,
                    ),
                    SizedBox(height: 3.h),

                    // Recipient selection
                    RecipientSelectionWidget(
                      controller: _recipientController,
                      onChanged: (value) {
                        if (_recipientError != null) {
                          setState(() {
                            _recipientError = null;
                          });
                        }
                      },
                      errorText: _recipientError,
                    ),
                    SizedBox(height: 3.h),

                    // Repayment date picker
                    RepaymentDatePickerWidget(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _dateError = null;
                        });
                      },
                      errorText: _dateError,
                    ),
                    SizedBox(height: 3.h),

                    // Interest rate input
                    InterestRateInputWidget(
                      controller: _interestRateController,
                      onChanged: (value) {
                        if (_interestRateError != null) {
                          setState(() {
                            _interestRateError = null;
                          });
                        }
                      },
                      errorText: _interestRateError,
                    ),
                    SizedBox(height: 3.h),

                    // Additional notes
                    AdditionalNotesWidget(
                      controller: _notesController,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 3.h),

                    // Terms agreement
                    TermsAgreementWidget(
                      isAgreed: _isTermsAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isTermsAgreed = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),

            // Bottom action button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed:
                      _isLoading || !_isTermsAgreed ? null : _createLoanRequest,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Создание запроса...',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Отправить запрос',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
