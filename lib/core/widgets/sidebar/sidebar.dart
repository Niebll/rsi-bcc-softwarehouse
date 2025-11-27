import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../themes/app_colors.dart';
import 'sidebar_item.dart';

class SideDashboard extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideDashboard({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SideDashboard> createState() => _SideDashboardState();
}

class _SideDashboardState extends State<SideDashboard> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80.w : 240.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header logo + toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  child: Image.asset('assets/images/BCC.png', height: 24.w),
                ),

                if (!_isCollapsed) ...[
                  SizedBox(width: 12.w),
                ],

              ],
            ),
          ),

          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),

          // Menu items
          Expanded(
            child: ListView(
              children: [
                SidebarItem(
                  icon: Icons.home_filled,
                  title: "Dashboard",
                  isActive:
                      GoRouterState.of(context).uri.toString() == '/dashboard',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/dashboard'),
                ),
                // SidebarItem(
                //   icon: Icons.file_open,
                //   isActive:
                //       GoRouterState.of(context).uri.toString() == '/portofolio',
                //   title: "Portofolio",
                //   isCollapsed: _isCollapsed,
                //   onTap: () => context.go('/portofolio'),
                // ),
                SidebarItem(
                  icon: Icons.circle_outlined,
                  title: "Progress",
                  isActive:
                      GoRouterState.of(context).uri.toString() == '/projects/running',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/projects/running'),
                ),
                SidebarItem(
                  icon: Icons.analytics,
                  title: "Analytics",
                  isActive:
                      GoRouterState.of(context).uri.toString() == '/analytics',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/analytics'),
                ),
                SidebarItem(
                  icon: Icons.add_card_outlined,
                  title: "Payment",
                  isActive:
                  GoRouterState.of(context).uri.toString() == '/projects/billing',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/projects/billing'),
                ),
                SidebarItem(
                  icon: Icons.queue,
                  title: "Requesting",
                  isActive:
                  GoRouterState.of(context).uri.toString() == '/requesting',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/requesting'),
                ),
                Spacer(),
                SidebarItem(
                  icon: Icons.logout,
                  title: "Logout",
                  isActive:
                  GoRouterState.of(context).uri.toString() == '/logout',
                  isCollapsed: _isCollapsed,
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
