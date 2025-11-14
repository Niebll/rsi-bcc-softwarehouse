import 'package:bcc_rsi/features/portofolio/view/portofolio_page.dart';
import 'package:bcc_rsi/features/project_bill/view/project_bill_page.dart';
import 'package:bcc_rsi/features/project_request/view/project_request_page.dart';
import 'package:bcc_rsi/features/project_running/view/project_running_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/view/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const ProjectRequestPage(),
    ),
    GoRoute(path: '/projects/running',
      builder: (context, state) => const ProjectRunningPage(),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/projects/billing',
      builder: (context, state) => const ProjectBillPage(),
    ),
    GoRoute(
      path: '/portofolio',
      builder: (context, state) => const PortofolioPage(),
    ),


  ],
);
