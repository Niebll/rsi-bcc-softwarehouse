import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProjectBillPage extends StatefulWidget {
  const ProjectBillPage({Key? key}) : super(key: key);

  @override
  State<ProjectBillPage> createState() => _ProjectBillPageState();
}

class _ProjectBillPageState extends State<ProjectBillPage> {
  int _selectedIndex = 0;
  int currentTabIndex = 0;

  final List<String> tabs = [
    "Pending",
    "Approved",
    "Declined",
  ];

  final List<Map<String, dynamic>> _data = [
    {
      'id': 1,
      'project': 'Redesign Website A',
      'jatuhTempo': DateTime(2024, 5, 20),
      'nominal': 25000000,
      'bukti': 'bukti_invoice_A.png',
      'status': 'Pending',
    },
    {
      'id': 2,
      'project': 'Mobile App Project B',
      'jatuhTempo': DateTime(2024, 6, 10),
      'nominal': 40000000,
      'bukti': 'bukti_invoice_B.png',
      'status': 'Approved',
    },
    {
      'id': 3,
      'project': 'System Integration C',
      'jatuhTempo': DateTime(2024, 7, 1),
      'nominal': 18000000,
      'bukti': 'bukti_invoice_C.png',
      'status': 'Declined',
    },
  ];

  List<Map<String, dynamic>> get _filteredData {
    switch (currentTabIndex) {
      case 0:
        return _data.where((e) => e['status'] == 'Pending').toList();
      case 1:
        return _data.where((e) => e['status'] == 'Approved').toList();
      case 2:
        return _data.where((e) => e['status'] == 'Declined').toList();
      default:
        return _data;
    }
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
                  SizedBox(height: 24.h),
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tagihan Proyek",
                              style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 16.h),
                          // === TAB BAR ===
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
                                    color: isActive
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: isActive
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: isActive
                                          ? Colors.blue
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 24.h),

                          // === TABLE ===
                          Expanded(
                            child: PaginatedDataTable2(
                              columnSpacing: 12.w,
                              horizontalMargin: 12.w,
                              minWidth: 700.w,
                              headingRowHeight: 56.h,
                              dataRowHeight: 64.h,
                              dividerThickness: 0.2,
                              columns: [
                                DataColumn2(
                                  label: Text('ID',
                                      style: textTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w600)),
                                  size: ColumnSize.S,
                                ),
                                DataColumn(label: Text('Project')),
                                DataColumn(label: Text('Jatuh Tempo')),
                                DataColumn(label: Text('Nominal')),
                                DataColumn(label: Text('Lihat Bukti')),
                                DataColumn(label: Text('Status')),
                                // Tambah kolom aksi hanya kalau tab = Pending
                                if (currentTabIndex == 0)
                                  DataColumn(label: Text('Aksi')),
                              ],
                              source:
                              ProjectBillDataSource(_filteredData, currentTabIndex),
                              rowsPerPage: 7,
                              showCheckboxColumn: false,
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

class ProjectBillDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final int currentTabIndex;
  final void Function(int id, String newStatus)? onStatusChanged;

  ProjectBillDataSource(this._data, this.currentTabIndex, {this.onStatusChanged});

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final bill = _data[index];
    final dateFormat = DateFormat('dd MMM yyyy');

    Color statusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Approved':
          return Colors.green;
        case 'Declined':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String? selectedStatus = bill['status'];

    return DataRow(
      cells: [
        DataCell(Text(bill['id'].toString())),
        DataCell(Text(bill['project'])),
        DataCell(Text(dateFormat.format(bill['jatuhTempo']))),
        DataCell(Text('Rp ${bill['nominal']}')),
        DataCell(Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            bill['bukti'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        )),

        // === STATUS (Dropdown kalau pending) ===
        DataCell(
          currentTabIndex == 0
              ? StatefulBuilder(
            builder: (context, setStateRow) => DropdownButton<String>(
              value: selectedStatus,
              items: ['Pending', 'Approved', 'Declined']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setStateRow(() => selectedStatus = value);
                }
              },
            ),
          )
              : Container(
            padding:
            EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor(bill['status']).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              bill['status'],
              style: TextStyle(
                color: statusColor(bill['status']),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // === AKSI (Simpan kalau pending) ===
        if (currentTabIndex == 0)
          DataCell(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r)),
              ),
              onPressed: () {
                if (onStatusChanged != null) {
                  onStatusChanged!(bill['id'], selectedStatus ?? 'Pending');
                }
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
