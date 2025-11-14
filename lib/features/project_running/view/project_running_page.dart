import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/themes/app_font_weight.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:bcc_rsi/features/project_running/widgets/project_running_box_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectRunningPage extends StatefulWidget {
  const ProjectRunningPage({Key? key}) : super(key: key);

  @override
  State<ProjectRunningPage> createState() => _ProjectRunningPageState();
}

class _ProjectRunningPageState extends State<ProjectRunningPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideDashboard(selectedIndex: 0, onItemSelected: (_) {}),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              width: double.infinity,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      'Daftar project berjalan',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      children: [
                        Expanded(
                          child: ProjectRunningBoxWidgets(
                            titleProject: "Mantap",
                            client: "haha",
                            log: "2323",
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: ProjectRunningBoxWidgets(
                            titleProject: "Mantap",
                            client: "haha",
                            log: "2323",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: ProjectRunningBoxWidgets(
                            titleProject: "Mantap",
                            client: "haha",
                            log: "2323",
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: ProjectRunningBoxWidgets(
                            titleProject: "Mantap",
                            client: "haha",
                            log: "2323",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
