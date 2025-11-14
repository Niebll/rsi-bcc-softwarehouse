import 'package:bcc_rsi/features/auth/view/login_page.dart';
import 'package:bcc_rsi/features/home/view/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/router.dart';
import 'core/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Dashboard Web',
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
        );
      },
    );
  }
}
