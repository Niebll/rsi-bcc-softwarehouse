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
  // List untuk menampung data project dari API
  List<dynamic> _projects = [];

  // indikator loading, default true saat pertama kali buka halaman
  bool _isLoading = true;

  // Base URL untuk GET project
  final String baseUrl =
      "https://pg-vincent.bccdev.id/rsi/api/project/";

  @override
  void initState() {
    super.initState();
    fetchProjects(); // Fetch data pertama kali
  }

  // Fungsi mengambil data project dari API
  Future<void> fetchProjects() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          _projects = data["data"]; // Data project berasal dari key "data"
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
          // Sidebar kiri
          SideDashboard(selectedIndex: 0, onItemSelected: (_) {}),

          // Area konten utama
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  // Judul halaman
                  Text(
                    'Daftar Project Berjalan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  SizedBox(height: 40.h),

                  // Jika masih loading → tampilkan spinner
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())

                  // Jika tidak loading → tampilkan konten
                      : Expanded(
                    child: _projects.isEmpty
                    // Jika tidak ada data di API
                        ? const Center(
                      child: Text(
                        "Belum ada project berjalan.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )

                    // Jika ada data → tampilkan dalam bentuk Grid
                        : GridView.builder(
                      itemCount: _projects.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // grid 2 kolom
                        mainAxisSpacing: 0.h,
                        crossAxisSpacing: 20.w,
                        childAspectRatio: 1.8, // bentuk card
                      ),
                      itemBuilder: (context, index) {
                        final item = _projects[index];

                        // Ambil field dari API
                        final title = item["name"] ?? "-";
                        final client =
                            "Request ID: ${item["requestId"]}";
                        final log =
                        (item["progressList"] as List).isEmpty
                            ? "Belum ada progress"
                            : "${item["progressList"].length} progress update";

                        // Widget card project
                        return ProjectRunningBoxWidgets(
                          titleProject: title,
                          client: client,
                          log: log,
                          onTap: () {
                            // Buka dialog detail project
                            showGeneralDialog(
                              context: context,
                              pageBuilder:
                                  (context, anim1, anim2) {
                                return ProjectRunningDetail(
                                  project: item,
                                );
                              },
                              transitionBuilder: (context, anim1,
                                  anim2, child) {
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
