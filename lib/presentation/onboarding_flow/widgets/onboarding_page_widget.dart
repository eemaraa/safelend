import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isRTL;

  const OnboardingPageWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isRTL = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            // Illustration container
            Expanded(
              flex: 3,
              child: Container(
                width: 85.w,
                margin: EdgeInsets.only(top: 8.h),
                child: CustomImageWidget(
                  imageUrl: imagePath,
                  width: 85.w,
                  height: 40.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Content section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Container(
                    width: 90.w,
                    child: Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Container(
                    width: 85.w,
                    child: Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
