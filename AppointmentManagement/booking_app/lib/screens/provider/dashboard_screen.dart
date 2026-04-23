import 'package:flutter/material.dart';
import '../../services/api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var data = await ApiService.getUsers();
      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Data"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No Data Found"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(user['Name'].toString()),
                        subtitle: Text("ID: ${user['ID']}"),
                      ),
                    );
                  },
                ),
    );
  }
}