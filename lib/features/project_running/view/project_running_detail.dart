import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../widgets/assign_member_modal.dart';
import '../widgets/member_model.dart';

class ProjectRunningDetail extends StatefulWidget {
  final Map<String, dynamic> project;
  const ProjectRunningDetail({super.key, required this.project});

  @override
  State<ProjectRunningDetail> createState() => _ProjectRunningDetailState();
}

class _ProjectRunningDetailState extends State<ProjectRunningDetail>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  List<Map<String, dynamic>> logs = [];
  bool loadingLogs = true;

  final TextEditingController progressTitle = TextEditingController();
  final TextEditingController progressDesc = TextEditingController();
  String statusDropdown = "on Progress";

  bool isSubmitting = false;

  List<Member> assignedMembers = [];
  bool loadingMembers = true;

  final String baseUrl = "https://pg-vincent.bccdev.id/rsi/api/project/";

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (tabController.index == 0) {
          loadExistingLogs();
        } else if (tabController.index == 1) {
          fetchAssignedMembers();
        }
      }
    });

    loadExistingLogs();
    fetchAssignedMembers();
  }

  void loadExistingLogs() {
    logs = (widget.project["progressList"] as List)
        .map((e) => {
      "id": e["id"],
      "tanggal": DateTime.parse(e["updatedAt"]),
      "pesan": "${e["title"]} - ${e["description"]} (${e["status"]})"
    })
        .toList()
        .reversed
        .toList();

    setState(() => loadingLogs = false);
  }

  Future<void> fetchAssignedMembers() async {
    final projectId = widget.project['id'];
    final url =
        "https://pg-vincent.bccdev.id/rsi/api/assign/$projectId/members";

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        assignedMembers = data.map((e) {
          return Member(
            e["id"],
            e["name"],
            email: e["email"],
            role: e["role"],
          );
        }).toList();
      } else {
        print("FAILED FETCH MEMBERS: ${res.body}");
      }
    } catch (e) {
      print("ERROR FETCH MEMBERS: $e");
    }

    setState(() => loadingMembers = false);
  }

  Future<void> updateProgress() async {
    final title = progressTitle.text.trim();
    final desc = progressDesc.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final url = "$baseUrl${widget.project['id']}/progress";
    final body = {"title": title, "description": desc, "status": statusDropdown};

    try {
      final res = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);

        logs.insert(0, {
          "id": data["id"],
          "tanggal": DateTime.now(),
          "pesan": "$title - $desc ($statusDropdown)",
        });

        progressTitle.clear();
        progressDesc.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Progress berhasil diupdate")),
        );

        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update progress: ${res.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isSubmitting = false);
  }

  void openAssignMemberModal() async {
    final result = await showDialog<List<Member>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AssignMemberModal(
        existingMembers: assignedMembers,
        projectId: widget.project['id'],
      ),
    );

    if (result != null) {
      setState(() {
        assignedMembers = result;
      });
    }

    fetchAssignedMembers(); // refresh setelah modal
  }

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final horizontalMargin = width > 1200 ? 125.w : 40.w;

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin, vertical: 68.h),
          constraints: BoxConstraints(
              maxWidth: 1200.w,
              maxHeight: MediaQuery.of(context).size.height - 120.h),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 16,
                  spreadRadius: 4)
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Detail Project Running",
                      style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 28.sp)),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ],
              ),
              SizedBox(height: 16.h),

              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r)),
                child: TabBar(
                  controller: tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey.shade600,
                  tabs: const [
                    Tab(text: "Riwayat & Update"),
                    Tab(text: "Assign Member"),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      _buildLogTab(text),
                      _buildAssignMember(text),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogTab(TextTheme text) {
    return Column(
      children: [
        Expanded(
          child: loadingLogs
              ? const Center(child: CircularProgressIndicator())
              : PaginatedDataTable2(
            rowsPerPage: 2,
            columns: const [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Tanggal")),
              DataColumn(label: Text("Progress")),
            ],
            source: _LogSource(logs),
          ),
        ),
        SizedBox(height: 12),
        Text("Tambah Progress Baru",
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(
          controller: progressTitle,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Judul progress (ex: Slicing Register)"),
        ),
        SizedBox(height: 10),
        TextField(
          controller: progressDesc,
          maxLines: 3,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Deskripsi progress"),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: statusDropdown,
          items: const [
            DropdownMenuItem(value: "on Progress", child: Text("On Progress")),
            DropdownMenuItem(value: "Done", child: Text("Done")),
          ],
          onChanged: (v) => setState(() => statusDropdown = v!),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : updateProgress,
            child: isSubmitting
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text("Simpan Progress"),
          ),
        )
      ],
    );
  }

  Widget _buildAssignMember(TextTheme textTheme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: openAssignMemberModal,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.white),
                  const SizedBox(width: 8),
                  Text("Tambah Member",
                      style:
                      textTheme.bodyMedium!.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text("Assigned Members",
              style:
              textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          if (loadingMembers)
            const Center(child: CircularProgressIndicator()),

          if (!loadingMembers && assignedMembers.isEmpty)
            Text("Belum ada member yang diassign",
                style: textTheme.bodyMedium!.copyWith(color: Colors.grey)),

          if (!loadingMembers)
            ...assignedMembers.map(
                  (m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(child: Text(m.name[0])),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: textTheme.bodyLarge),
                        Text(m.role!,
                            style: textTheme.bodySmall!
                                .copyWith(color: Colors.grey.shade600)),
                        Text(m.email!,
                            style: textTheme.bodySmall!
                                .copyWith(color: Colors.grey.shade600)),
                      ],
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

class _LogSource extends DataTableSource {
  final List<Map<String, dynamic>> logs;
  _LogSource(this.logs);

  @override
  DataRow? getRow(int index) {
    if (index >= logs.length) return null;
    final df = DateFormat("dd MMM yyyy HH:mm");

    return DataRow(cells: [
      DataCell(Text(logs[index]["id"].toString())),
      DataCell(Text(df.format(logs[index]["tanggal"]))),
      DataCell(Text(logs[index]["pesan"])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => logs.length;
  @override
  int get selectedRowCount => 0;
}
