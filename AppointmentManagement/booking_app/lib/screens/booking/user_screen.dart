import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../widgets/app_drawer.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService _service = UserService();

  List<User> users = [];
  List<User> filtered = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await _service.getUsers();

    setState(() {
      users = List<User>.from(data);
      filtered = List<User>.from(data);
      isLoading = false;
    });
  }

  void search(String value) {
    setState(() {
      filtered = users
          .where((u) =>
      u.name.toLowerCase().contains(value.toLowerCase()) ||
          u.email.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void showForm({User? user}) {
    final name = TextEditingController(text: user?.name ?? "");
    final userId = TextEditingController(text: user?.userId ?? "");
    final email = TextEditingController(text: user?.email ?? "");
    final phone = TextEditingController(text: user?.phoneNo ?? "");
    final address = TextEditingController(text: user?.address ?? "");
    final password = TextEditingController(text: user?.password ?? "");
    final role = TextEditingController(text: user?.role ?? "");
    bool active = user?.active ?? true;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Center(
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          user == null ? "Add User" : "Edit User",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        _field(name, "Name"),
                        _field(userId, "User ID"),
                        _field(email, "Email"),
                        _field(phone, "Phone No"),
                        _field(address, "Address"),
                        _field(password, "Password", isPassword: true),
                        _field(role, "Role"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Active"),
                            Switch(
                              value: active,
                              onChanged: (val) {
                                setStateDialog(() => active = val);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () async {
                            if (name.text.trim().isEmpty) return;

                            if (user == null) {
                              await _service.addUser(User(
                                name: name.text.trim(),
                                userId: userId.text.trim(),
                                email: email.text.trim(),
                                phoneNo: phone.text.trim(),
                                address: address.text.trim(),
                                password: password.text.trim(),
                                role: role.text.trim(),
                                active: active,
                              ));
                            } else {
                              user.name = name.text.trim();
                              user.userId = userId.text.trim();
                              user.email = email.text.trim();
                              user.phoneNo = phone.text.trim();
                              user.address = address.text.trim();
                              user.password = password.text.trim();
                              user.role = role.text.trim();
                              user.active = active;

                              await _service.updateUser(user);
                            }

                            Navigator.pop(context);
                            loadData();
                          },
                          child: const Text("Save"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _field(TextEditingController c, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: isPassword, // 🔥 hide text
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  void deleteUser(int id) async {
    await _service.deleteUser(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Users")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: const InputDecoration(
                hintText: "Search User...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final u = filtered[i];
                return Card(
                  child: ListTile(
                    title: Text(u.name),
                    subtitle: Text(u.email),
                    leading: Icon(
                      u.active
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                      u.active ? Colors.green : Colors.red,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showForm(user: u),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteUser(u.id!),
                        ),
                      ],
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