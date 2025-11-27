import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'member_model.dart';

class AssignMemberModal extends StatefulWidget {
  final int projectId;
  final List<Member> existingMembers;

  const AssignMemberModal({
    Key? key,
    required this.projectId,
    required this.existingMembers,
  }) : super(key: key);

  @override
  _AssignMemberModalState createState() => _AssignMemberModalState();
}

class _AssignMemberModalState extends State<AssignMemberModal> {
  List<Member> allMembers = [];
  List<Member> filteredMembers = [];
  List<int> selectedIds = [];

  bool isLoading = true;
  bool isSubmitting = false;
  bool submitSuccess = false;

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedIds = widget.existingMembers.map((e) => e.id).toList();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    try {
      final res = await http.get(
        Uri.parse("https://pg-vincent.bccdev.id/rsi/api/assign/members"),
      );

      print("RAW RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List rows = decoded["data"]["rows"];

        allMembers = rows.map((e) {
          return Member(
            e['id'],
            e['name'],
            email: e['email'],
            role: e['role'],
          );
        }).toList();

        filteredMembers = List.from(allMembers);

        setState(() => isLoading = false);
      } else {
        throw Exception("Failed to load members");
      }
    } catch (e) {
      print("ERROR FETCH MEMBERS: $e");
      setState(() => isLoading = false);
    }
  }

  void applySearch(String query) {
    final q = query.toLowerCase();

    setState(() {
      filteredMembers = allMembers.where((m) {
        return m.name.toLowerCase().contains(q) ||
            m.role!.toLowerCase().contains(q) ||
            m.email!.toLowerCase().contains(q);
      }).toList();
    });
  }

  List<int> getNewAssignedIds() {
    final existing = widget.existingMembers.map((e) => e.id).toSet();
    return selectedIds.where((id) => !existing.contains(id)).toList();
  }

  Future<bool> submitAssignMembers() async {
    final newIds = getNewAssignedIds();
    if (newIds.isEmpty) return false;

    setState(() => isSubmitting = true);

    final payload = {
      "projectId": widget.projectId,
      "members": newIds.map((id) => {"memberId": id}).toList(),
    };

    try {
      final res = await http.post(
        Uri.parse("https://pg-vincent.bccdev.id/rsi/api/assign/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      print("RAW RESPONSE: ${res.body}");

      // HARUS: selalu decode JSON (jika gagal → backend kirim html)
      try {
        jsonDecode(res.body);
      } catch (_) {
        throw Exception("Backend returned non-JSON");
      }

      submitSuccess = res.statusCode >= 200 && res.statusCode < 300;
      setState(() => isSubmitting = false);
      return submitSuccess;
    } catch (e) {
      print("SUBMIT ERROR: $e");
      setState(() => isSubmitting = false);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(18),
        width: 420,
        child: isLoading
            ? SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            Text("Assign Member",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),

            /// SEARCH BAR
            TextField(
              controller: searchCtrl,
              onChanged: applySearch,
              decoration: InputDecoration(
                hintText: "Search name / role / email...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 12),

            /// MEMBERS LIST
            SizedBox(
              height: 330,
              child: ListView.separated(
                itemCount: filteredMembers.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final m = filteredMembers[index];
                  final isExisting = widget.existingMembers
                      .any((ex) => ex.id == m.id);

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        m.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    title: Text(
                      m.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.role!,
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12)),
                        Text(m.email!,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11)),
                      ],
                    ),

                    trailing: isExisting
                        ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Assigned",
                        style: TextStyle(
                            color: Colors.green, fontSize: 12),
                      ),
                    )
                        : Checkbox(
                      value: selectedIds.contains(m.id),
                      onChanged: (value) {
                        if (isExisting) return;  // <-- cegah perubahan
                        setState(() {
                          if (value == true) {
                            selectedIds.add(m.id);
                          } else {
                            selectedIds.remove(m.id);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            /// BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed:
                    isSubmitting ? null : () => Navigator.pop(context),
                    child: const Text("Cancel")),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (isSubmitting || submitSuccess)
                      ? null
                      : () async {
                    final success = await submitAssignMembers();
                  },
                  child: isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : submitSuccess
                      ? const Text("Saved ✔")
                      : const Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
