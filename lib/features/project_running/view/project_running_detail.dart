import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

class ProjectRunningDetail extends StatefulWidget {
  const ProjectRunningDetail({Key? key}) : super(key: key);

  @override
  State<ProjectRunningDetail> createState() => _ProjectRunningDetailState();
}

class _ProjectRunningDetailState extends State<ProjectRunningDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // === DUMMY RIWAYAT LOG ===
  List<Map<String, dynamic>> logs = [
    {
      "id": 1,
      "tanggal": DateTime(2024, 10, 1),
      "pesan": "Planning selesai disusun"
    },
    {
      "id": 2,
      "tanggal": DateTime(2024, 10, 5),
      "pesan": "Development backend dimulai"
    },
  ];

  // === DUMMY MEMBER LIST ===
  List<Map<String, dynamic>> members = [
    {"id": 1, "nama": "Fahri", "role": "Backend", "assigned": false},
    {"id": 2, "nama": "Aulia", "role": "UI/UX", "assigned": false},
    {"id": 3, "nama": "Dina", "role": "Frontend", "assigned": false},
  ];

  final TextEditingController progressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== HEADER ====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detail Project Running",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              SizedBox(height: 20.h),

              // ==== TABBAR ====
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Riwayat & Update"),
                  Tab(text: "Assign Member"),
                ],
              ),

              SizedBox(height: 16.h),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLogAndUpdate(textTheme),
                    _buildAssignMember(textTheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // =============== TAB 1: RIWAYAT LOG + UPDATE ==================
  // =============================================================
  Widget _buildLogAndUpdate(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === LOG TABLE ===
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: PaginatedDataTable2(
              rowsPerPage: 5,
              headingRowHeight: 48,
              columnSpacing: 12,
              minWidth: 600,
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Tanggal")),
                DataColumn(label: Text("Progress")),
              ],
              source: _LogSource(logs),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        Text(
          "Update Progress",
          style:
          textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),

        TextField(
          controller: progressController,
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: "Masukkan progress terbaru...",
          ),
        ),
        SizedBox(height: 12.h),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              if (progressController.text.isNotEmpty) {
                setState(() {
                  logs.add({
                    "id": logs.length + 1,
                    "tanggal": DateTime.now(),
                    "pesan": progressController.text,
                  });
                });
                progressController.clear();
              }
            },
            child: const Text("Simpan Progress"),
          ),
        )
      ],
    );
  }

  // =============================================================
  // ==================== TAB 2: ASSIGN MEMBER ====================
  // =============================================================
  Widget _buildAssignMember(TextTheme textTheme) {
    return Column(
      children: [
        Expanded(
          child: PaginatedDataTable2(
            rowsPerPage: 5,
            minWidth: 600,
            headingRowHeight: 48,
            columns: const [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Nama")),
              DataColumn(label: Text("Role")),
              DataColumn(label: Text("Assign")),
            ],
            source: _AssignSource(
              members,
              onAssign: (id) {
                setState(() {
                  final m = members.firstWhere((e) => e["id"] == id);
                  m["assigned"] = !m["assigned"];
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =================================================================
// =============== DATA SOURCE FOR LOG TABLE =======================
// =================================================================
class _LogSource extends DataTableSource {
  final List<Map<String, dynamic>> logs;

  _LogSource(this.logs);

  @override
  DataRow? getRow(int index) {
    final log = logs[index];
    final df = DateFormat("dd MMM yyyy");

    return DataRow(
      cells: [
        DataCell(Text(log["id"].toString())),
        DataCell(Text(df.format(log["tanggal"]))),
        DataCell(Text(log["pesan"])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => logs.length;
  @override
  int get selectedRowCount => 0;
}

// =================================================================
// =============== DATA SOURCE FOR ASSIGN MEMBER ===================
// =================================================================
class _AssignSource extends DataTableSource {
  final List<Map<String, dynamic>> members;
  final Function(int) onAssign;

  _AssignSource(this.members, {required this.onAssign});

  @override
  DataRow? getRow(int index) {
    final m = members[index];

    return DataRow(
      cells: [
        DataCell(Text(m["id"].toString())),
        DataCell(Text(m["nama"])),
        DataCell(Text(m["role"])),
        DataCell(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: m["assigned"] ? Colors.red : Colors.green,
            ),
            onPressed: () => onAssign(m["id"]),
            child: Text(m["assigned"] ? "Unassign" : "Assign"),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => members.length;
  @override
  int get selectedRowCount => 0;
}
