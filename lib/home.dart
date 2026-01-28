import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_model.dart';

class OnlineScholarRequest extends StatefulWidget {
  const OnlineScholarRequest({super.key});

  @override
  State<OnlineScholarRequest> createState() => _OnlineScholarRequestState();
}

class _OnlineScholarRequestState extends State<OnlineScholarRequest> {
  List<Student> allStudents = [];
  List<Student> filteredStudents = [];
  bool isLoading = true;

  final Color navyBlue = const Color(0xFF0A1D56);

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("https://bgnu.space/api/student_data"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        allStudents = list.map((e) => Student.fromJson(e)).toList();
        filteredStudents = allStudents;
      } else {
        showMsg("Failed to fetch students");
      }
    } catch (e) {
      showMsg("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void searchStudent(String query) {
    setState(() {
      filteredStudents = allStudents
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Online Scholar Request",
          style: TextStyle(
            color: Color(0xFF0A1D56),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0A1D56)),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0A1D56)),
            )
          : Column(
              children: [
                // 🔍 Search Field
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchStudent,
                    decoration: InputDecoration(
                      hintText: "Search by Name",
                      hintStyle: const TextStyle(color: Color(0xFF0A1D56)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF0A1D56),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0A1D56)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0A1D56)),
                      ),
                    ),
                  ),
                ),

                // 📋 Student List
                Expanded(
                  child: filteredStudents.isEmpty
                      ? const Center(
                          child: Text(
                            "No record found",
                            style: TextStyle(
                              color: Color(0xFF0A1D56),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  student.name,
                                  style: const TextStyle(
                                    color: Color(0xFF0A1D56),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(student.email),
                                    Text(student.registerDate),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A1D56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    showMsg("Request sent to ${student.name}");
                                  },
                                  child: const Text(
                                    "Send Request",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
