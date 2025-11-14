import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:bcc_rsi/features/project_request/view/project_request_detail.dart';
import 'package:bcc_rsi/features/project_request/widgets/project_request_box_stats.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ProjectRequestPage extends StatefulWidget {
  const ProjectRequestPage({Key? key}) : super(key: key);

  @override
  State<ProjectRequestPage> createState() => _ProjectRequestPageState();
}

class _ProjectRequestPageState extends State<ProjectRequestPage> {


  int _selectedIndex = 0;

  int currentTabIndex = 0;

  final List<String> tabs = [
    "Semua",
    "Pending Review",
    "Rejected",
    "Approved",
  ];

  final List<Map<String, dynamic>> _data = [
    {
      'id': 1,
      'project': 'Project A',
      'perusahaan': 'Alice Corp',
      'tanggalMasuk': DateTime(2024, 5, 1),
      'timeline': '3 Bulan',
      'budget': 50000000,
      'status': 'Pending Review',
    },
    {
      'id': 2,
      'project': 'Project B',
      'perusahaan': 'Bob Studio',
      'tanggalMasuk': DateTime(2024, 5, 2),
      'timeline': '2 Bulan',
      'budget': 35000000,
      'status': 'Approved',
    },
  ];

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
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideDashboard(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40.w, horizontal: 68.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      ProjectRequestBoxStats(
                        title: "Semua",
                        count: "100",
                        iconPath: "assets/icons/layers.png",
                        bgColor: Color(0xffEBF8FF),
                      ),
                      SizedBox(width: 24.w),
                      ProjectRequestBoxStats(
                        title: "Approved",
                        count: "20",
                        iconPath: "assets/icons/check_circle.png",
                        bgColor: Color(0xffE6F8F0),
                      ),
                      SizedBox(width: 24.w),
                      ProjectRequestBoxStats(
                        title: "Rejected",
                        count: "20",
                        iconPath: "assets/icons/circle_x.png",
                        bgColor: Color(0xffFDEDED),
                      ),
                      SizedBox(width: 24.w),
                      ProjectRequestBoxStats(
                        title: "Pending Review",
                        count: "20",
                        iconPath: "assets/icons/time.png",
                        bgColor: Color(0xffFFF0E9),
                      ),
                    ],
                  ),
                  SizedBox(height: 38.h),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(tabs.length, (index) {
                              bool isActive = currentTabIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentTabIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive ? Colors.blue.shade50 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: isActive ? Colors.blue : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: isActive ? Colors.blue : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          // === TAB BAR ===
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: PaginatedDataTable2(
                                columnSpacing: 12.w,
                                horizontalMargin: 12.w,
                                minWidth: 800.w,
                                headingRowHeight: 56.h,
                                dataRowHeight: 64.h,
                                dividerThickness: 0.2,
                                columns: [
                                  DataColumn2(
                                    label: Text('ID',
                                        style: textTheme.bodyMedium!
                                            .copyWith(fontWeight: FontWeight.w600)),
                                    size: ColumnSize.S,
                                  ),
                                  DataColumn(label: Text('Project')),
                                  DataColumn(label: Text('Perusahaan')),
                                  DataColumn(label: Text('Tanggal Masuk')),
                                  DataColumn(label: Text('Timeline')),
                                  DataColumn(label: Text('Budget')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('')),
                                ],
                                source: ProjectDataSource(_filteredData, context),
                                rowsPerPage: 7,
                                showCheckboxColumn: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final BuildContext _context;

  ProjectDataSource(this._data, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final project = _data[index];
    final dateFormat = DateFormat('dd MMM yyyy');

    return DataRow(
      cells: [
        DataCell(Text(project['id'].toString())),
        DataCell(Text(project['project'])),
        DataCell(Text(project['perusahaan'])),
        DataCell(Text(dateFormat.format(project['tanggalMasuk']))),
        DataCell(Text(project['timeline'])),
        DataCell(Text('Rp ${project['budget'].toString()}')),
        DataCell(
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: project['status'] == 'Berjalan'
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              project['status'],
              style: TextStyle(
                color: project['status'] == 'Berjalan'
                    ? Colors.orange
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          GestureDetector(
            onTap: () {
              showGeneralDialog(
                context: _context,
                barrierDismissible: true,
                barrierLabel: 'Detail',
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, anim1, anim2) {
                  return ProjectRequestDetail(project: project);
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
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
