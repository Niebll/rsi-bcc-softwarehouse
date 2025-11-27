import 'dart:convert';
import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:bcc_rsi/features/project_running/view/project_running_detail.dart';
import 'package:bcc_rsi/features/project_running/widgets/project_running_box_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ProjectRunningPage extends StatefulWidget {
  const ProjectRunningPage({super.key});

  @override
  State<ProjectRunningPage> createState() => _ProjectRunningPageState();
}

class _ProjectRunningPageState extends State<ProjectRunningPage> {
  List<dynamic> _projects = [];
  bool _isLoading = true;

  final String baseUrl =
      "https://pg-vincent.bccdev.id/rsi/api/project/"; // <--- GANTI DI SINI

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          _projects = data["data"];   // <-- FIX DI SINI
          _isLoading = false;
        });

        print("PROJECTS : $_projects");
      } else {
        print("FAILED GET: ${res.statusCode}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("ERROR GET PROJECT: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideDashboard(selectedIndex: 0, onItemSelected: (_) {}),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  Text(
                    'Daftar Project Berjalan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  SizedBox(height: 40.h),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: _projects.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Belum ada project berjalan.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              : GridView.builder(
                                  itemCount: _projects.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0.h,
                                        crossAxisSpacing: 20.w,
                                        childAspectRatio: 1.8,
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = _projects[index];

                                    final title = item["name"] ?? "-";
                                    final client =
                                        "Request ID: ${item["requestId"]}";
                                    final log =
                                        (item["progressList"] as List).isEmpty
                                        ? "Belum ada progress"
                                        : "${item["progressList"].length} progress update";

                                    return ProjectRunningBoxWidgets(
                                      titleProject: title,
                                      client: client,
                                      log: log,
                                      onTap: () {
                                        showGeneralDialog(
                                          context: context,
                                          pageBuilder: (context, anim1, anim2) {
                                            return ProjectRunningDetail(project: item,);
                                          },
                                          transitionBuilder: (context, anim1, anim2, child) {
                                            return FadeTransition(
                                              opacity: anim1,
                                              child: ScaleTransition(
                                                scale: CurvedAnimation(
                                                  parent: anim1,
                                                  curve: Curves.easeOut,
                                                ),
                                                child: child,
                                              ),
                                            );
                                          },
                                        );

                                      },
                                    );
                                  },
                                ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
