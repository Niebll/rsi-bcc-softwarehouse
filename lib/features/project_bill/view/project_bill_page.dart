import 'dart:convert';
import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// Base URL API utama
const String BaseUrl = "https://pg-vincent.bccdev.id/rsi/";

class ProjectBillPage extends StatefulWidget {
  const ProjectBillPage({Key? key}) : super(key: key);

  @override
  State<ProjectBillPage> createState() => _ProjectBillPageState();
}

class _ProjectBillPageState extends State<ProjectBillPage> {
  int _selectedIndex = 0;        // index sidebar
  int currentTabIndex = 0;       // index tab (Pending / Verified / Rejected)

  // Nama tab filter
  final List<String> tabs = [
    "Pending",
    "Verified",
    "Rejected",
  ];

  List<Map<String, dynamic>> _data = []; // data tagihan

  bool isLoading = true; // indikator loading API

  @override
  void initState() {
    super.initState();
    fetchBills(); // mengambil data saat halaman dibuka
  }

  /// Fetch seluruh data pembayaran (payment) dari API
  Future<void> fetchBills() async {
    try {
      final url = Uri.parse("${BaseUrl}api/payment/all");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List rows = jsonData["data"]["rows"];

        // Normalisasi data API ke bentuk Map mudah digunakan UI
        setState(() {
          _data = rows.map((item) {
            final rp = item["RequestProjectDatum"];

            return {
              "id": item["paymentId"],
              "project": rp?["projectName"] ?? "-",
              "jatuhTempo": DateTime.parse(rp?["deadline"]),
              "nominal": rp?["budget"] ?? 0,
              "bukti": item["fileUrl"] ?? "-",
              "status": item["status"] ?? "Pending",
            };
          }).toList();

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// Filter data berdasarkan tab
  List<Map<String, dynamic>> get _filteredData {
    switch (currentTabIndex) {
      case 0:
        return _data.where((e) => e['status'] == 'Pending').toList();
      case 1:
        return _data.where((e) => e['status'] == 'Verified').toList();
      case 2:
        return _data.where((e) => e['status'] == 'Rejected').toList();
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
          // Sidebar kiri
          SideDashboard(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),

          // Bagian kanan (konten utama)
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40.w, horizontal: 68.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),

                  // Jika masih loading → tampilkan spinner
                  if (isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                  // Jika data sudah siap
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

                        // Isi konten
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul halaman
                            Text("Tagihan Proyek",
                                style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 16.h),

                            // TAB FILTER (Pending, Verified, Rejected)
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

                            // TABEL DATA
                            Expanded(
                              child: PaginatedDataTable2(
                                columnSpacing: 12.w,
                                horizontalMargin: 12.w,
                                minWidth: 700.w,
                                headingRowHeight: 56.h,
                                dataRowHeight: 64.h,
                                dividerThickness: 0.2,

                                // Header tabel
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

                                  // Kolom aksi hanya muncul di tab Pending
                                  if (currentTabIndex == 0)
                                    DataColumn(label: Text('Aksi')),
                                ],

                                // Data source tabel
                                source: ProjectBillDataSource(
                                  _filteredData,
                                  currentTabIndex,
                                  context,
                                  refreshParent: fetchBills,
                                ),

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

// =======================================================================
// DATA SOURCE UNTUK DATATABLE2
// =======================================================================

class ProjectBillDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final int currentTabIndex;
  final Function refreshParent;
  final BuildContext context;

  ProjectBillDataSource(
      this._data,
      this.currentTabIndex,
      this.context, {
        required this.refreshParent,
      });

  /// Update status pembayaran (Pending → Verified / Rejected)
  Future<void> updatePaymentStatus(int paymentId, String status) async {
    final url =
    Uri.parse("${BaseUrl}api/payment/update-status/$paymentId");

    final body = {
      "status": status,
      "validatedBy": 1, // validator admin ID (sementara hardcode)
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Updated successfully");
      } else {
        print("Failed: ${response.body}");
      }
    } catch (e) {
      print("Error update: $e");
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;

    final bill = _data[index];
    final dateFormat = DateFormat('dd MMM yyyy');

    // Warna badge status
    Color statusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Verified':
          return Colors.green;
        case 'Rejected':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    // Variable supaya dropdown per row bisa berubah
    String selectedStatus = bill['status'];

    return DataRow(
      cells: [
        DataCell(Text(bill['id'].toString())),
        DataCell(Text(bill['project'] ?? "-")),
        DataCell(Text(dateFormat.format(bill['jatuhTempo']))),
        DataCell(Text('Rp ${bill['nominal']}')),

        // Tombol untuk melihat gambar bukti transfer
        DataCell(GestureDetector(
          onTap: () {
            final imageUrl = bill['bukti'];

            if (imageUrl == null || imageUrl.isEmpty) return;

            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.all(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // tombol close
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),

                        SizedBox(height: 10),

                        // preview gambar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            height: 400,
                            errorBuilder: (context, error, stackTrace) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "Gambar tidak dapat dimuat",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },

          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              bill['bukti'] ?? "-",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        )),

        // Kolom STATUS
        DataCell(
          currentTabIndex == 0
          // Jika tab Pending → status bisa diganti via dropdown
              ? StatefulBuilder(
            builder: (context, setRowState) => DropdownButton<String>(
              value: selectedStatus,
              items: ['Pending', 'Verified', 'Rejected']
                  .map(
                    (status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setRowState(() => selectedStatus = value);
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

        // Tombol SIMPAN hanya muncul jika masih Pending
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
              onPressed: () async {
                await updatePaymentStatus(bill['id'], selectedStatus);
                refreshParent(); // refresh tabel setelah update
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
