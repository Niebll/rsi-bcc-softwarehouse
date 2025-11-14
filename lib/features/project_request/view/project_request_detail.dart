import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/themes/app_font_weight.dart';
import 'package:bcc_rsi/features/project_request/widgets/project_request_detail_box.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProjectRequestDetail extends StatefulWidget {
  final Map<String, dynamic> project;
  const ProjectRequestDetail({super.key, required this.project});

  @override
  State<ProjectRequestDetail> createState() => _ProjectRequestDetailState();
}

class _ProjectRequestDetailState extends State<ProjectRequestDetail> {
  late GroupController _controller;
  bool _controllerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = GroupController(isMultipleSelection: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _controllerReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final dateFormat = DateFormat('dd MMM yyyy');
    final selectedCount = _controllerReady
        ? _controller.selectedItem.length
        : 0;

    final isAllChecked = selectedCount == 3;


    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 125.w, vertical: 68.h),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 16,
                spreadRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // project['project'],
                    "Detail Project Request",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.sp,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              // Detail Info
              SizedBox(height: 16.h),
              ProjectRequestDetailBox(
                  title: "Project", description: widget.project['project']),
              SizedBox(height: 12.h),
              ProjectRequestDetailBox(title: "Perusahaan",
                  description: widget.project['perusahaan']),
              SizedBox(height: 12.h),
              Text("Deskripsi", style: textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium, fontSize: 20.sp)),
              Row(
                children: [
                  // === Tenggat ===
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tenggat",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.greyText),
                          ),
                          child: Text(
                            widget.project['tenggat'] ?? '-',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // === Budget ===
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Budget",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.greyText),
                          ),
                          child: Text(
                            "Rp ${widget.project['budget']?.toString() ?? '-'}",
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ProjectRequestDetailBox(title: "Detail", description: ""),
              SizedBox(height: 8.h),
              Text("Kecocokan Project:", style: textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium, fontSize: 20.sp)),
              SizedBox(height: 8.h),
              SimpleGroupedChips<int>(
                controller: _controller,
                values: [1, 2, 3],
                chipGroupStyle: ChipGroupStyle.minimize(
                  selectedTextColor: Colors.white,
                  backgroundColorItem: Colors.white,
                  selectedColorItem: AppColors.secondary,
                  itemTitleStyle: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  selectedIcon: Icons.check_circle,

                ),
                onItemSelected: (values) {
                  setState(() {
                    final selectedCount = values.length; // langsung dari parameter
                    final isAllChecked = selectedCount == 3;
                    debugPrint("Selected Count: $selectedCount | All checked: $isAllChecked");
                  });
                },
                itemsTitle: [
                  "Tenggat: ${widget.project['tenggat'] ?? '-'}",
                  "Budget: Rp ${widget.project['budget']?.toString() ?? '-'}",
                  "Resource: ${widget.project['resource'] ?? '-'}",
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Reject
                  ElevatedButton(
                    onPressed: () {
                      // TODO: logic reject di sini
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Reject",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Approve
                  ElevatedButton(
                    onPressed: isAllChecked
                        ? () {
                      // TODO: logic approve di sini
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAllChecked
                          ? AppColors.secondary
                          : Colors.grey.shade300,
                      foregroundColor:
                      isAllChecked ? Colors.white : Colors.grey.shade600,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Approve",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isAllChecked ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

