import 'package:bcc_rsi/features/project_running/view/project_running_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_font_weight.dart';

class ProjectRunningBoxWidgets extends StatelessWidget {
  final String titleProject, client, log;
  final VoidCallback? onTap;

  const ProjectRunningBoxWidgets({
    super.key,
    required this.titleProject,
    required this.client,
    required this.log, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.r),
              topLeft: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleProject,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: AppFontWeight.semiBold,
                  color: Colors.black,

                ),
                maxLines: 1,
              ),
              SizedBox(height: 4.h),
              Text(
                client,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 36.h),
              Text(
                "Log Terakhir",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: AppFontWeight.semiBold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                log,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 26.w, horizontal: 44.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.greyText, width: 0.35.w),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: onTap,
              // showGeneralDialog(
              //   context: context,
              //   pageBuilder: (context, anim1, anim2) {
              //     return ProjectRunningDetail();
              //   },
              //   transitionBuilder: (context, anim1, anim2, child) {
              //     return FadeTransition(
              //       opacity: anim1,
              //       child: ScaleTransition(
              //         scale: CurvedAnimation(
              //           parent: anim1,
              //           curve: Curves.easeOut,
              //         ),
              //         child: child,
              //       ),
              //     );
              //   },
              // );

            child: Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/pencill.png',
                      width: 32.w,
                      height: 32.h,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Detail Progress",
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: AppFontWeight.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
