import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../widgets/assign_member_modal.dart';
import '../widgets/member_model.dart';

// Halaman detail project yang muncul sebagai dialog
class ProjectRunningDetail extends StatefulWidget {
  final Map<String, dynamic> project; // data project yang dikirim dari halaman sebelumnya
  const ProjectRunningDetail({super.key, required this.project});

  @override
  State<ProjectRunningDetail> createState() => _ProjectRunningDetailState();
}

class _ProjectRunningDetailState extends State<ProjectRunningDetail>
    with SingleTickerProviderStateMixin {

  late TabController tabController; // controller untuk tabbar

  List<Map<String, dynamic>> logs = []; // menyimpan riwayat progress
  bool loadingLogs = true; // indikator loading riwayat

  // controller input form progress baru
  final TextEditingController progressTitle = TextEditingController();
  final TextEditingController progressDesc = TextEditingController();

  String statusDropdown = "on Progress"; // default status progress
  bool isSubmitting = false; // loading ketika tekan tombol simpan

  List<Member> assignedMembers = []; // list member yang sudah diassign
  bool loadingMembers = true; // loading indikator fetch member

  final String baseUrl = "https://pg-vincent.bccdev.id/rsi/api/project/";

  @override
  void initState() {
    super.initState();

    // Tab berisi 2 halaman
    tabController = TabController(length: 2, vsync: this);

    // Listener supaya saat pindah tab, data direload sesuai tab
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (tabController.index == 0) {
          loadExistingLogs(); // Tab riwayat
        } else if (tabController.index == 1) {
          fetchAssignedMembers(); // Tab assign member
        }
      }
    });

    // Load awal
    loadExistingLogs();
    fetchAssignedMembers();
  }

  // Mengambil progressList dari project lalu konversi ke format log
  void loadExistingLogs() {
    logs = (widget.project["progressList"] as List)
        .map((e) => {
      "id": e["id"],
      "tanggal": DateTime.parse(e["updatedAt"]),
      "pesan": "${e["title"]} - ${e["description"]} (${e["status"]})"
    })
        .toList()
        .reversed
        .toList(); // dibalik supaya terbaru di atas

    setState(() => loadingLogs = false);
  }

  // Fetch member yang sudah diassign ke project
  Future<void> fetchAssignedMembers() async {
    final projectId = widget.project['id'];
    final url =
        "https://pg-vincent.bccdev.id/rsi/api/assign/$projectId/members";

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        // Mapping JSON → Model Member
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

  // Update progress ke API
  Future<void> updateProgress() async {
    final title = progressTitle.text.trim();
    final desc = progressDesc.text.trim();

    // Validasi
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

      // 201 = Created
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);

        // Tambahkan progress baru ke list log lokal
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

  // Modal assign member
  void openAssignMemberModal() async {
    final result = await showDialog<List<Member>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AssignMemberModal(
        existingMembers: assignedMembers,
        projectId: widget.project['id'],
      ),
    );

    // Jika modal mengembalikan hasil
    if (result != null) {
      setState(() {
        assignedMembers = result;
      });
    }

    fetchAssignedMembers(); // refresh ulang
  }

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final horizontalMargin = width > 1200 ? 125.w : 40.w;

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent, // supaya background dialog transparan
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
              // Header dialog
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

              // Tab bar
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

              // Isi tab bar
              Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      _buildLogTab(text), // Tab log progress
                      _buildAssignMember(text), // Tab assign member
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 1 — Riwayat progress dan form tambah progress
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

        // FORM TAMBAH PROGRESS
        SizedBox(height: 12),
        Text("Tambah Progress Baru",
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // Input judul
        TextField(
          controller: progressTitle,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Judul progress (ex: Slicing Register)"),
        ),
        SizedBox(height: 10),

        // Input deskripsi
        TextField(
          controller: progressDesc,
          maxLines: 3,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Deskripsi progress"),
        ),
        SizedBox(height: 10),

        // Dropdown status
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

        // Tombol submit
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

  // TAB 2 — List member + tombol tambah member
  Widget _buildAssignMember(TextTheme textTheme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Tombol untuk membuka modal assign member
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

          // Title
          Text("Assigned Members",
              style:
              textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          if (loadingMembers)
            const Center(child: CircularProgressIndicator()),

          if (!loadingMembers && assignedMembers.isEmpty)
            Text("Belum ada member yang diassign",
                style: textTheme.bodyMedium!.copyWith(color: Colors.grey)),

          // Tampilkan list member
          if (!loadingMembers)
            ...assignedMembers.map(
                  (m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(child: Text(m.name[0])), // avatar huruf awal
                    const SizedBox(width: 12),

                    // Detail member
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

// DataSource untuk tabel log progress
class _LogSource extends DataTableSource {
  final List<Map<String, dynamic>> logs;
  _LogSource(this.logs);

  @override
  DataRow? getRow(int index) {
    if (index >= logs.length) return null;

    final df = DateFormat("dd MMM yyyy HH:mm"); // format tanggal

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
