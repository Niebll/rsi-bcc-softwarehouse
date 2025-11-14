import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/themes/app_font_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/sidebar/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideDashboard(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 80.w, right: 40.w, top: 50.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Summary Dashboard",
                            style: textTheme.headlineLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text("Halo selamat datang, Client"),
                          SizedBox(height: 34.h),

                        ],
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text(
                            formattedDate,
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),
                          StreamBuilder(
                            stream: Stream.periodic(
                              const Duration(seconds: 5),
                            ),
                            builder: (context, snapshot) {
                              final now = DateTime.now();
                              final formatted = DateFormat(
                                'HH:mm',
                              ).format(now);
                              return Text(
                                formatted,
                                style: textTheme.bodyMedium!
                                    .copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                  fontWeight:
                                  AppFontWeight.semiBold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                    ],
                  ),


                  // ===== MAIN DASHBOARD ROW =====
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========================= LEFT CARD =========================
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: EdgeInsets.all(24.w),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Text(
                                  "Running Progress",
                                  style: textTheme.headlineLarge!.copyWith(
                                    fontWeight: AppFontWeight.semiBold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                // Card isi progress project
                                Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.greyText,
                                      width: 0.35.w,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // --- Left Text ---
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Aplikasi manajemen proyek",
                                              style: textTheme.bodyLarge!
                                                  .copyWith(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        AppFontWeight.medium,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "Sedang dalam tahap pengembangan UI/UX.",
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    color: AppColors.greyText,
                                                    fontWeight:
                                                        AppFontWeight.medium,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 12.w),

                                      // --- Progress Bar + Percentage ---
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value: 0.5,
                                                minHeight: 10.h,
                                                backgroundColor:
                                                    AppColors.background,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.primary),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "50%",
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        AppFontWeight.semiBold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 16.w),

                                      // --- Button ---
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          "Lihat Detail",
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: AppFontWeight.semiBold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 30.w),

                        // ========================= RIGHT CARD =========================
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20.h,
                                          horizontal: 24.w,
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "5",
                                              style: textTheme.headlineLarge!
                                                  .copyWith(
                                                    fontSize: 48.sp,
                                                    fontWeight:
                                                        AppFontWeight.bold,
                                                    color: AppColors.secondary,
                                                  ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Spacer(),
                                            Text(
                                              "Request Baru\n(Pending)  ",
                                              style: textTheme.bodyLarge!
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        AppFontWeight.semiBold,
                                                    color: AppColors.greyText,
                                                  ),
                                            ),
                                            SizedBox(height: 20.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20.h,
                                          horizontal: 24.w,
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "5",
                                              style: textTheme.headlineLarge!
                                                  .copyWith(
                                                    fontSize: 48.sp,
                                                    fontWeight:
                                                        AppFontWeight.bold,
                                                    color: AppColors.secondary,
                                                  ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Spacer(),
                                            Text(
                                              "Total Proyek Aktif",
                                              style: textTheme.bodyLarge!
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        AppFontWeight.semiBold,
                                                    color: AppColors.greyText,
                                                  ),
                                            ),
                                            SizedBox(height: 20.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "Ringkasan Pembayaran",
                                        style: textTheme.bodyLarge!.copyWith(
                                          fontWeight: AppFontWeight.medium,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      Text(
                                        "3",
                                        style: textTheme.headlineLarge!
                                            .copyWith(
                                              fontSize: 48.sp,
                                              fontWeight: AppFontWeight.bold,
                                              color: AppColors.secondary,
                                            ),
                                      ),
                                      Text(
                                        "Proyek telah selesai dan menunggu pembayaran.",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 12.sp,
                                          color: AppColors.greyText,
                                          fontWeight: AppFontWeight.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Info Tambahan",
                                      style: textTheme.bodyLarge!.copyWith(
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
