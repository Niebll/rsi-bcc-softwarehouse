import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_font_weight.dart';

class ProjectRequestDetailBox extends StatelessWidget {
  final String title, description;
  const ProjectRequestDetailBox({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: AppFontWeight.medium, fontSize: 20.sp)),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.greyText)
          ),
          child: Text(description),
        ),

      ],
    );
  }
}
