import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/themes/app_colors.dart';

class ProjectRequestBoxStats extends StatelessWidget {
  final String title, count, iconPath;
  final Color bgColor;

  const ProjectRequestBoxStats({Key? key, required this.title, required this.count, required this.iconPath, required this.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.w, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.greyText, width: 0.35.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                height: 38.h,
                width: 38.w,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: textTheme.headlineLarge?.copyWith(
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
