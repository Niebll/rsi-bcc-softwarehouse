import 'dart:convert';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:bcc_rsi/features/project_request/view/project_request_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';

import '../widgets/project_request_box_stats.dart';

class ProjectRequestPage extends StatefulWidget {
  const ProjectRequestPage({Key? key}) : super(key: key);

  @override
  State<ProjectRequestPage> createState() => _ProjectRequestPageState();
}

class _ProjectRequestPageState extends State<ProjectRequestPage> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;
  bool _isStatsLoading = true;

  int currentTabIndex = 0;

  // REAL COUNT
  int totalCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;
  int pendingCount = 0;

  final String baseUrl = "https://pg-vincent.bccdev.id/rsi/";

  @override
  void initState() {
    super.initState();
    fetchProjectRequest();
  }

  // ================= GET =================
  Future<void> fetchProjectRequest() async {
    setState(() {
      _isLoading = true;
      _isStatsLoading = true;
    });

    try {
      final url = "${baseUrl}api/request/form/data";
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final rows = body["data"]["rows"] as List;

        _data = rows.map((e) {
          return {
            "id": e["requestId"],
            "project": e["projectName"],
            "client": e["clientName"],
            "deadline": DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(e["deadline"])),
            "budget": e["budget"],
            "status": _normalizeStatus(e["status"]),
          };
        }).toList();

        // HITUNG STATISTIK
        totalCount = _data.length;
        approvedCount =
            _data.where((e) => e['status'] == 'Approved').length;
        rejectedCount =
            _data.where((e) => e['status'] == 'Rejected').length;
        pendingCount =
            _data.where((e) => e['status'] == 'Pending Review').length;
      }
    } catch (e) {
      print("Error GET: $e");
    }

    setState(() {
      _isLoading = false;
      _isStatsLoading = false;
    });
  }

  String _normalizeStatus(String s) {
    switch (s.toLowerCase()) {
      case "pending":
        return "Pending Review";
      case "approved":
        return "Approved";
      case "declined":
      case "rejected":
        return "Rejected";
      default:
        return s;
    }
  }

  // ================= FILTER =================
  List<Map<String, dynamic>> get _filteredData {
    switch (currentTabIndex) {
      case 1:
        return _data.where((e) => e['status'] == 'Pending Review').toList();
      case 2:
        return _data.where((e) => e['status'] == 'Rejected').toList();
      case 3:
        return _data.where((e) => e['status'] == 'Approved').toList();
      default:
        return _data;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideDashboard(selectedIndex: 0, onItemSelected: (value) {}),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),

                  // ================== STATS BOX ==================
                  Row(
                    children: [
                      _isStatsLoading
                          ? _loadingStatBox()
                          : ProjectRequestBoxStats(
                        title: "Semua",
                        count: "$totalCount",
                        iconPath: "assets/icons/layers.png",
                        bgColor: Color(0xffEBF8FF),
                      ),
                      SizedBox(width: 24.w),

                      _isStatsLoading
                          ? _loadingStatBox()
                          : ProjectRequestBoxStats(
                        title: "Approved",
                        count: "$approvedCount",
                        iconPath: "assets/icons/check_circle.png",
                        bgColor: Color(0xffE6F8F0),
                      ),
                      SizedBox(width: 24.w),

                      _isStatsLoading
                          ? _loadingStatBox()
                          : ProjectRequestBoxStats(
                        title: "Rejected",
                        count: "$rejectedCount",
                        iconPath: "assets/icons/circle_x.png",
                        bgColor: Color(0xffFDEDED),
                      ),
                      SizedBox(width: 24.w),

                      _isStatsLoading
                          ? _loadingStatBox()
                          : ProjectRequestBoxStats(
                        title: "Pending Review",
                        count: "$pendingCount",
                        iconPath: "assets/icons/time.png",
                        bgColor: Color(0xffFFF0E9),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  Text(
                    "Riwayat Request",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  _buildTabFilter(),
                  SizedBox(height: 20.h),

                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _buildPaginatedTable(),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= TAB FILTER =================
  Widget _buildTabFilter() {
    final tabs = ["Semua", "Pending", "Declined", "Approved"];

    return Row(
      children: List.generate(tabs.length, (i) {
        bool selected = currentTabIndex == i;

        return GestureDetector(
          onTap: () {
            setState(() => currentTabIndex = i);
          },
          child: Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                color: selected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ================== PAGINATED DATATABLE2 ==================
  Widget _buildPaginatedTable() {
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Project")),
        DataColumn(label: Text("Client")),
        DataColumn(label: Text("Deadline")),
        DataColumn(label: Text("Budget")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("Actions")),
      ],
      source: _ProjectRequestTableSource(() => _filteredData, (row) {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Detail',
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, anim1, anim2) {
            return ProjectRequestDetail(project: row);
          },
          transitionBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: anim1,
              child: ScaleTransition(
                scale: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
                child: child,
              ),
            );
          },
        );

      }),
      rowsPerPage: 7,
      minWidth: 900,
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
      columnSpacing: 20,
      horizontalMargin: 12,
      renderEmptyRowsInTheEnd: false,
    );
  }

  // ================== SKELETON LOADING BOX ==================
  Widget _loadingStatBox() {
    return Container(
      height: 110.h,
      width: 220.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}

//
// ================= TABLE SOURCE =================
//
class _ProjectRequestTableSource extends DataTableSource {
  final List<Map<String, dynamic>> Function() getData;
  final void Function(Map<String, dynamic> row) onDetail;

  _ProjectRequestTableSource(this.getData, this.onDetail);


  @override
  DataRow? getRow(int index) {
    final data = getData();

    if (index >= data.length) return null;

    final e = data[index];

    return DataRow(cells: [
      DataCell(Text(e["id"].toString())),
      DataCell(Text(e["project"])),
      DataCell(Text(e["client"])),
      DataCell(Text(e["deadline"])),
      DataCell(Text("Rp ${e["budget"]}")),
      DataCell(_statusBadge(e["status"])),
      DataCell(
        e["status"] == "Pending Review"
            ? GestureDetector(
          onTap: () => onDetail(e),    // <- pakai callback
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Detail',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
            : const Text("—"),
      ),

    ]);
  }

  Widget _statusBadge(String status) {
    Color bg, tx;

    if (status == "Pending Review") {
      bg = Colors.orange.withOpacity(0.2);
      tx = Colors.orange;
    } else if (status == "Rejected") {
      bg = Colors.red.withOpacity(0.2);
      tx = Colors.red;
    } else {
      bg = Colors.green.withOpacity(0.2);
      tx = Colors.green;
    }



    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontWeight: FontWeight.bold, color: tx),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => getData().length;

  @override
  int get selectedRowCount => 0;
}
