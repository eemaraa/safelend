import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OfflineIndicatorWidget extends StatefulWidget {
  final bool isOffline;
  final bool isSyncing;
  final VoidCallback? onRetrySync;

  const OfflineIndicatorWidget({
    Key? key,
    required this.isOffline,
    this.isSyncing = false,
    this.onRetrySync,
  }) : super(key: key);

  @override
  State<OfflineIndicatorWidget> createState() => _OfflineIndicatorWidgetState();
}

class _OfflineIndicatorWidgetState extends State<OfflineIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.isSyncing) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(OfflineIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSyncing && !oldWidget.isSyncing) {
      _animationController.repeat();
    } else if (!widget.isSyncing && oldWidget.isSyncing) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOffline && !widget.isSyncing) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: widget.isOffline
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isOffline
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          widget.isSyncing
              ? AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: CustomIconWidget(
                        iconName: 'sync',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    );
                  },
                )
              : CustomIconWidget(
                  iconName: widget.isOffline ? 'wifi_off' : 'wifi',
                  color: widget.isOffline
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isSyncing
                      ? 'Синхронизация...'
                      : widget.isOffline
                          ? 'Автономный режим'
                          : 'Подключено',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: widget.isOffline
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.isOffline) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Показаны кэшированные договоры. Некоторые функции недоступны.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (widget.isSyncing) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Обновление данных договоров...',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.isOffline &&
              !widget.isSyncing &&
              widget.onRetrySync != null)
            TextButton(
              onPressed: widget.onRetrySync,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Повторить',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
