import 'dart:convert';
import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/themes/app_font_weight.dart';
import 'package:bcc_rsi/features/project_request/widgets/project_request_detail_box.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ProjectRequestDetail extends StatefulWidget {
  final Map<String, dynamic> project;
  const ProjectRequestDetail({super.key, required this.project});

  @override
  State<ProjectRequestDetail> createState() => _ProjectRequestDetailState();
}

class _ProjectRequestDetailState extends State<ProjectRequestDetail> {
  late GroupController _controller;
  List<int> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _controller = GroupController(isMultipleSelection: true);
  }

  Future<void> _submitDecision(String decision) async {
    final String baseUrl = "https://pg-vincent.bccdev.id/rsi/"; // <- ISI DI SINI
    final url = Uri.parse("${baseUrl}api/analysis/analyze");

    final body = {
      "requestId": widget.project["id"] ?? 0,
      "analysis_notes": "",
      "analyzed_by": 1,
      "decision": decision,
    };
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.pop(context); // Tutup modal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil di$decision")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: ${res.body}")),
        );
        print("Response status: ${res.statusCode}");
        print("Response body: ${res.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.project;
    final textTheme = Theme.of(context).textTheme;

    final isAllChecked = _selectedValues.length == 3;

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
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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

              SizedBox(height: 16.h),

              /// DATA DETAIL
              ProjectRequestDetailBox(
                title: "Project",
                description: data["project"] ?? "-",
              ),
              SizedBox(height: 12.h),

              ProjectRequestDetailBox(
                title: "Client",
                description: data["client"] ?? "-",
              ),
              SizedBox(height: 12.h),

              ProjectRequestDetailBox(
                title: "Deadline",
                description: data["deadline"] ?? "-",
              ),
              SizedBox(height: 12.h),

              ProjectRequestDetailBox(
                title: "Budget",
                description: "Rp ${data['budget'] ?? '-'}",
              ),

              SizedBox(height: 24.h),

              Text(
                "Kecocokan Project:",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: AppFontWeight.medium,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),

              /// CHECKLIST
              SimpleGroupedChips<int>(
                controller: _controller,
                values: const [1, 2, 3],
                itemsTitle: [
                  "Tenggat: ${data['deadline'] ?? '-'}",
                  "Budget: Rp ${data['budget'] ?? '-'}",
                  "Resource: - ",
                ],
                chipGroupStyle: ChipGroupStyle.minimize(
                  selectedTextColor: Colors.white,
                  backgroundColorItem: Colors.white,
                  selectedColorItem: AppColors.secondary,
                  itemTitleStyle: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  selectedIcon: Icons.check_circle,
                ),
                onItemSelected: (values) {
                  setState(() {
                    _selectedValues = List<int>.from(values);
                  });
                },
              ),

              const Spacer(),

              /// BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// REJECT
                  ElevatedButton(
                    onPressed: () => _submitDecision("Rejected"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Reject",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  /// APPROVE
                  ElevatedButton(
                    onPressed: isAllChecked
                        ? () => _submitDecision("Approved")
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAllChecked ? AppColors.secondary : Colors.grey.shade300,
                      foregroundColor:
                      isAllChecked ? Colors.white : Colors.grey.shade600,
                      padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
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
