import 'dart:convert';
import 'package:bcc_rsi/core/themes/app_colors.dart';
import 'package:bcc_rsi/core/themes/app_font_weight.dart';
import 'package:bcc_rsi/core/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProjectRequestUser extends StatefulWidget {
  const ProjectRequestUser({Key? key}) : super(key: key);

  @override
  State<ProjectRequestUser> createState() => _ProjectRequestUserState();
}

class _ProjectRequestUserState extends State<ProjectRequestUser> {
  final TextEditingController projectNameC = TextEditingController();
  final TextEditingController projectDescC = TextEditingController();
  final TextEditingController clientNameC = TextEditingController();
  final TextEditingController budgetC = TextEditingController();
  DateTime? selectedDeadline;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideDashboard(selectedIndex: 0, onItemSelected: (value) {}),

          Expanded(
            child: Material(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        "Request Project Baru",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 32.sp,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      Column(
                        children: [
                          buildInputField(
                            title: "Project Name",
                            controller: projectNameC,
                            textTheme: textTheme,
                          ),
                          SizedBox(height: 24.h),

                          buildInputField(
                            title: "Project Description",
                            controller: projectDescC,
                            maxLines: 5,
                            textTheme: textTheme,
                          ),
                          SizedBox(height: 24.h),

                          buildInputField(
                            title: "Client Name",
                            controller: clientNameC,
                            textTheme: textTheme,
                          ),
                          SizedBox(height: 24.h),

                          buildInputField(
                            title: "Budget",
                            controller: budgetC,
                            keyboardType: TextInputType.number,
                            textTheme: textTheme,
                          ),
                          SizedBox(height: 24.h),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deadline",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: AppFontWeight.medium,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );

                                  if (picked != null) {
                                    setState(() => selectedDeadline = picked);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                  child: Text(
                                    selectedDeadline == null
                                        ? "Pilih tanggal"
                                        : DateFormat('yyyy-MM-dd')
                                        .format(selectedDeadline!),
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: isLoading ? null : submitForm,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                "Submit Request",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 80.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // =====================================================================
  // INPUT FIELD CUSTOM
  // =====================================================================
  Widget buildInputField({
    required String title,
    required TextEditingController controller,
    required TextTheme textTheme,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: AppFontWeight.medium,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Masukkan teks...",
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // SUBMIT FORM — POST API
  // =====================================================================
  void submitForm() async {
    if (projectNameC.text.isEmpty ||
        projectDescC.text.isEmpty ||
        clientNameC.text.isEmpty ||
        budgetC.text.isEmpty ||
        selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi!")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse(
        "https://pg-vincent.bccdev.id/rsi/api/request/form/submit");

    final body = {
      "userId": 1,
      "projectName": projectNameC.text,
      "projectDescription": projectDescC.text,
      "clientName": clientNameC.text,
      "budget": int.tryParse(budgetC.text) ?? 0,
      "deadline": DateFormat('yyyy-MM-dd').format(selectedDeadline!),
      "status": "pending"
    };

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      debugPrint("STATUS CODE: ${res.statusCode}");
      debugPrint("BODY: ${res.body}");

      setState(() => isLoading = false);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Project request berhasil dikirim!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  clearForm();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${res.body}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat mengirim request.")),
      );
    }
  }

  // =====================================================================
  // CLEAR FORM AFTER SUCCESS
  // =====================================================================
  void clearForm() {
    projectNameC.clear();
    projectDescC.clear();
    clientNameC.clear();
    budgetC.clear();
    selectedDeadline = null;
    setState(() {});
  }
}
