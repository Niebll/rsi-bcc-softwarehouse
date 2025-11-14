import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PortofolioPage extends StatefulWidget {
  const PortofolioPage({Key? key}) : super(key: key);

  @override
  State<PortofolioPage> createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideDashboard(selectedIndex: 0, onItemSelected: (value) {}),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 100.w, vertical: 66.h),
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portofolio BCC Software House',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildPortoCard(textTheme)),
                            SizedBox(width: 16.w),
                            Expanded(child: _buildPortoCard(textTheme)),
                            SizedBox(width: 16.w),
                            Expanded(child: _buildPortoCard(textTheme)),

                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildPortoCard(textTheme)),
                            SizedBox(width: 16.w),
                            Expanded(child: _buildPortoCard(textTheme)),
                            SizedBox(width: 16.w),
                            Expanded(child: _buildPortoCard(textTheme)),

                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPortoCard(TextTheme textTheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Image.asset(
                "assets/images/porto.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aplikasi E-Commerce",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: Text(
                        "Deskripsi singkat mengenai aplikasi e-commerce yang dikembangkan oleh BCC Software House. Aplikasi ini memiliki fitur lengkap untuk mendukung aktivitas jual beli online.",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyText,
                          fontSize: 12.sp
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
