import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/app_colors.dart';

class SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final Color bgColor = widget.isActive
        ? AppColors.primary.withOpacity(0.15)
        : _isHovered
        ? AppColors.primary.withOpacity(0.08)
        : Colors.transparent;

    final Color iconColor =
    widget.isActive ? Colors.white : AppColors.iconColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isActive ? AppColors.secondary : bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.white, size: 32.w,),
                if (!widget.isCollapsed) ...[
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      // style: TextStyle(
                      //   color: widget.isActive
                      //       ? Colors.white
                      //       : AppColors.textSecondary,
                      //   fontWeight: FontWeight.w500,
                      // ),

                      style: textTheme.bodyMedium?.copyWith(
                        color: widget.isActive
                            ? Colors.white
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
