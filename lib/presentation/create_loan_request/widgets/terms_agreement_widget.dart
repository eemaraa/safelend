import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsAgreementWidget extends StatefulWidget {
  final bool isAgreed;
  final Function(bool) onChanged;

  const TermsAgreementWidget({
    Key? key,
    required this.isAgreed,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TermsAgreementWidget> createState() => _TermsAgreementWidgetState();
}

class _TermsAgreementWidgetState extends State<TermsAgreementWidget> {
  bool _isExpanded = false;

  final String _legalDisclaimer = """
ПРАВОВАЯ ИНФОРМАЦИЯ

1. ОБЩИЕ ПОЛОЖЕНИЯ
Приложение SafeLend является нейтральной третьей стороной, предоставляющей платформу для документирования личных займов между частными лицами. Мы НЕ выдаем займы и НЕ являются кредитной организацией.

2. СООТВЕТСТВИЕ ЗАКОНОДАТЕЛЬСТВУ РФ
• Соблюдение Федерального закона № 152-ФЗ "О персональных данных"
• Интеграция с системой Госуслуги для верификации личности
• Соответствие требованиям гражданского законодательства РФ

3. ОГРАНИЧЕНИЯ ПРОЦЕНТНЫХ СТАВОК
Согласно российскому законодательству, максимальная процентная ставка по займам между физическими лицами не может превышать 20% годовых.

4. ОТВЕТСТВЕННОСТЬ СТОРОН
• Займодавец и заемщик несут полную ответственность за исполнение договора
• SafeLend не несет ответственности за неисполнение обязательств сторонами
• Все споры решаются в соответствии с законодательством РФ

5. ЗАЩИТА ПЕРСОНАЛЬНЫХ ДАННЫХ
• Все данные шифруются и хранятся в соответствии с требованиями безопасности
• Передача данных третьим лицам осуществляется только с согласия пользователя
• Пользователи имеют право на удаление своих данных

6. ТЕХНИЧЕСКАЯ ПОДДЕРЖКА
При возникновении вопросов обращайтесь в службу поддержки через приложение или на сайт support.safelend.ru

Используя приложение, вы подтверждаете, что ознакомились с данными условиями и согласны с ними.
""";

  void _showFullTerms() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Правовая информация',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Закрыть'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  _legalDisclaimer,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
            ),
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
              child: ElevatedButton(
                onPressed: () {
                  widget.onChanged(true);
                  Navigator.pop(context);
                },
                child: Text('Согласиться с условиями'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Правовые условия',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: CustomIconWidget(
                      iconName: 'gavel',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'ВАЖНО: Правовая информация',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isExpanded ? null : 15.h,
                child: SingleChildScrollView(
                  physics: _isExpanded ? null : NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SafeLend НЕ является кредитной организацией и НЕ выдает займы. Мы предоставляем платформу для документирования займов между частными лицами.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Приложение соответствует требованиям:',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      _buildBulletPoint(
                          'Федеральный закон № 152-ФЗ "О персональных данных"'),
                      _buildBulletPoint('Интеграция с системой Госуслуги'),
                      _buildBulletPoint('Гражданское законодательство РФ'),
                      _buildBulletPoint('Максимальная ставка: 20% годовых'),
                      SizedBox(height: 1.h),
                      Text(
                        'Стороны несут полную ответственность за исполнение договора. SafeLend не несет ответственности за неисполнение обязательств.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                      if (!_isExpanded) ...[
                        SizedBox(height: 1.h),
                        Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.lightTheme.colorScheme.surface
                                    .withValues(alpha: 0.0),
                                AppTheme.lightTheme.colorScheme.surface,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: _showFullTerms,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'article',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Читать полный текст',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
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
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => widget.onChanged(!widget.isAgreed),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: widget.isAgreed
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isAgreed
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: widget.isAgreed
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 16,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Я ознакомился с правовой информацией и согласен с условиями использования приложения SafeLend',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h, left: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
