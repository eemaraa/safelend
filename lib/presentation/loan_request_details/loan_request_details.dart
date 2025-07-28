import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons.dart';
import './widgets/loan_summary_card.dart';
import './widgets/participant_info_card.dart';
import './widgets/terms_section.dart';
import './widgets/timeline_section.dart';

class LoanRequestDetails extends StatefulWidget {
  const LoanRequestDetails({Key? key}) : super(key: key);

  @override
  State<LoanRequestDetails> createState() => _LoanRequestDetailsState();
}

class _LoanRequestDetailsState extends State<LoanRequestDetails> {
  late Map<String, dynamic> loanData;
  late List<Map<String, dynamic>> timelineData;
  final String currentUserId = "user_123"; // Mock current user ID

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    loanData = {
      "id": "loan_001",
      "amount": "50 000",
      "interestRate": "12",
      "returnDate": "15.03.2025",
      "createdDate": "28.01.2025",
      "status": "pending", // pending, accepted, rejected, expired
      "creatorId": "user_456",
      "recipientId": "user_123",
      "lateFee": "0.5",
      "additionalTerms":
          """Заемщик обязуется вернуть полную сумму займа в указанный срок. При просрочке платежа начисляется штраф в размере 0.5% от суммы займа за каждый день просрочки. 

Договор составлен в соответствии с Гражданским кодексом РФ, статьи 807-823. Все споры решаются в соответствии с действующим законодательством Российской Федерации.

Стороны подтверждают свою дееспособность и понимание всех условий договора.""",
      "borrower": {
        "id": "user_123",
        "name": "Александр Петров",
        "phone": "+7 (999) 123-45-67",
        "avatar":
            "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
        "verified": true,
      },
      "lender": {
        "id": "user_456",
        "name": "Мария Сидорова",
        "phone": "+7 (999) 987-65-43",
        "avatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "verified": true,
      },
    };

    timelineData = [
      {
        "type": "created",
        "title": "Запрос создан",
        "description": "Мария Сидорова создала запрос на займ",
        "timestamp": "28.01.2025, 14:30",
      },
      {
        "type": "sent",
        "title": "Запрос отправлен",
        "description": "Запрос отправлен Александру Петрову",
        "timestamp": "28.01.2025, 14:32",
      },
      {
        "type": "reminder",
        "title": "Напоминание отправлено",
        "description": "Автоматическое напоминание о рассмотрении запроса",
        "timestamp": "30.01.2025, 10:00",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Детали займа',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'ID: ${loanData["id"]}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showMoreOptions,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            LoanSummaryCard(loanData: loanData),
            ParticipantInfoCard(
              loanData: loanData,
              currentUserId: currentUserId,
            ),
            TermsSection(loanData: loanData),
            TimelineSection(timeline: timelineData),
            ActionButtons(
              loanData: loanData,
              currentUserId: currentUserId,
              onAccept: _handleAcceptLoan,
              onReject: _handleRejectLoan,
              onEdit: _handleEditLoan,
              onCancel: _handleCancelLoan,
              onDownloadPdf: _handleDownloadPdf,
              onShare: _handleShareLoan,
              onSendReminder: _handleSendReminder,
            ),
            SizedBox(height: 10.h), // Space for floating action button
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    final String status = loanData["status"] as String;

    if (status == "accepted") {
      return FloatingActionButton.extended(
        onPressed: _handleDownloadPdf,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'download',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Скачать договор',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return null;
  }

  Future<void> _refreshData() async {
    // Simulate network refresh
    await Future.delayed(Duration(seconds: 1));

    // Update timeline with new data
    setState(() {
      if (timelineData.length < 4) {
        timelineData.insert(0, {
          "type": "reminder",
          "title": "Данные обновлены",
          "description": "Информация о займе обновлена",
          "timestamp":
              "28.01.2025, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        });
      }
    });
  }

  void _handleAcceptLoan() {
    HapticFeedback.mediumImpact();

    setState(() {
      loanData["status"] = "accepted";
      timelineData.insert(0, {
        "type": "accepted",
        "title": "Займ принят",
        "description": "Александр Петров принял условия займа",
        "timestamp":
            "28.01.2025, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Займ успешно принят! Договор будет сформирован.'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRejectLoan() {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Отклонить займ?'),
        content: Text('Вы уверены, что хотите отклонить этот запрос на займ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                loanData["status"] = "rejected";
                timelineData.insert(0, {
                  "type": "rejected",
                  "title": "Займ отклонен",
                  "description": "Александр Петров отклонил запрос на займ",
                  "timestamp":
                      "28.01.2025, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                });
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Займ отклонен'),
                  backgroundColor: AppTheme.errorLight,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Отклонить'),
          ),
        ],
      ),
    );
  }

  void _handleEditLoan() {
    Navigator.pushNamed(context, '/create-loan-request');
  }

  void _handleCancelLoan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Отменить запрос?'),
        content: Text('Вы уверены, что хотите отменить этот запрос на займ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Нет'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Да, отменить'),
          ),
        ],
      ),
    );
  }

  void _handleDownloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Договор скачивается...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Simulate PDF download
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Договор успешно скачан в папку "Загрузки"'),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _handleShareLoan() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Поделиться займом',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Скопировать ссылку'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(
                    text: 'https://safelend.ru/loan/${loanData["id"]}'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ссылка скопирована в буфер обмена'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Отправить в мессенджере'),
              onTap: () {
                Navigator.pop(context);
                // Implement messenger sharing
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Отправить по email'),
              onTap: () {
                Navigator.pop(context);
                // Implement email sharing
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleSendReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Напоминание отправлено получателю'),
        backgroundColor: AppTheme.warningLight,
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      timelineData.insert(0, {
        "type": "reminder",
        "title": "Напоминание отправлено",
        "description":
            "Мария Сидорова отправила напоминание о рассмотрении запроса",
        "timestamp":
            "28.01.2025, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
      });
    });
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Дополнительные действия',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Дублировать займ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/create-loan-request');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Посмотреть историю'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to history screen
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'support',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Связаться с поддержкой'),
              onTap: () {
                Navigator.pop(context);
                // Open support chat
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
