import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';

import '../../services/api_service.dart';

class CreateBookingScreen extends StatefulWidget {

  final ProviderModel provider;

  const CreateBookingScreen({
    super.key,
    required this.provider,
  });

  @override
  State<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState
    extends State<CreateBookingScreen> {

  final ApiService api = ApiService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSaving = false;

  bool isExistingClient = true;

  List<ClientModel> clients = [];
  List<ServiceModel> services = [];

  ClientModel? selectedClient;
  ServiceModel? selectedService;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String selectedStatus = "Pending";

  final notesController = TextEditingController();

  // =====================================
  // NEW CLIENT CONTROLLERS
  // =====================================

  final firstNameController =
  TextEditingController();

  final lastNameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // =====================================
  // LOAD CLIENTS + SERVICES
  // =====================================

  Future<void> loadData() async {

    try {

      final fetchedClients =
      await api.getClients();

      final fetchedServices =
      await api.getServices(
        widget.provider.id,
      );

      setState(() {

        clients = fetchedClients;
        services = fetchedServices;

        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================
  // PICK DATE
  // =====================================

  Future<void> pickDate() async {

    final picked =
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {

      setState(() {
        selectedDate = picked;
      });
    }
  }

  // =====================================
  // PICK TIME
  // =====================================

  Future<void> pickTime() async {

    final picked =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {

      setState(() {
        selectedTime = picked;
      });
    }
  }

  // =====================================
  // SAVE BOOKING
  // =====================================


  Future<void> saveBooking() async {

    if (!_formKey.currentState!.validate()) return;

    if (selectedService == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select all fields")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {

      String clientName = "";
      String clientEmail = "";
      String clientPhone = "";

      // =========================
      // EXISTING CLIENT
      // =========================
      if (isExistingClient) {

        if (selectedClient == null) {
          throw Exception("Select client");
        }

        clientName = selectedClient!.fullName;
        clientEmail = selectedClient!.email;
        clientPhone = selectedClient!.phone;
      }

      // =========================
      // NEW CLIENT
      // =========================
      else {

        final clientId = await api.createClient({
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
        });

        if (clientId == null) {
          throw Exception("Client not created");
        }

        clientName =
        "${firstNameController.text} ${lastNameController.text}";
        clientEmail = emailController.text;
        clientPhone = phoneController.text;
      }

      // =========================
      // DATETIME BUILD
      // =========================
      final startDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final endDateTime = startDateTime.add(
        Duration(minutes: selectedService!.durationMinutes),
      );

      // =========================
      // SAFE UUID CHECK
      // =========================
      final providerId = widget.provider.id?.toString();
      final serviceId = selectedService!.id?.toString();

      if (providerId == null || serviceId == null) {
        throw Exception("Provider or Service ID is null");
      }

      // =========================
      // CREATE BOOKING API
      // =========================
      final success = await api.createBooking({
        "provider_id": providerId,
        "service_id": serviceId,

        "service_name": selectedService!.name,
        "service_duration_minutes": selectedService!.durationMinutes,
        "service_price": selectedService!.price,

        "client_name": clientName,
        "client_email": clientEmail,
        "client_phone": clientPhone,

        "client_notes": notesController.text,

        "start_time": startDateTime.toIso8601String(),
        "end_time": endDateTime.toIso8601String(),

        "status": selectedStatus,
      });

      if (!success) {
        throw Exception("Booking failed");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking Created")),
        );
        Navigator.pop(context, true);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    } finally {
      setState(() => isSaving = false);
    }
  }
  // =====================================
  // UI
  // =====================================

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Create Booking"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              // ================= CLIENT TYPE CARD =================
              _sectionCard(
                title: "Client Type",
                child: Row(
                  children: [
                    Expanded(
                      child: _modernRadio(
                        title: "Existing",
                        value: true,
                        groupValue: isExistingClient,
                        onChanged: (v) {
                          setState(() {
                            isExistingClient = v!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _modernRadio(
                        title: "New",
                        value: false,
                        groupValue: isExistingClient,
                        onChanged: (v) {
                          setState(() {
                            isExistingClient = v!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ================= CLIENT CARD =================
              _sectionCard(
                title: "Client Details",
                child: isExistingClient
                    ? _modernDropdown<ClientModel>(
                  hint: "Select Client",
                  value: selectedClient,
                  items: clients,
                  labelBuilder: (c) => c.fullName,
                  onChanged: (v) => setState(() => selectedClient = v),
                )
                    : Column(
                  children: [
                    _modernInput(firstNameController, "First Name"),
                    _modernInput(lastNameController, "Last Name"),
                    _modernInput(emailController, "Email"),
                    _modernInput(phoneController, "Phone"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ================= SERVICE CARD =================
              _sectionCard(
                title: "Service",
                child: _modernDropdown<ServiceModel>(
                  hint: "Select Service",
                  value: selectedService,
                  items: services,
                  labelBuilder: (s) => s.name,
                  onChanged: (v) => setState(() => selectedService = v),
                ),
              ),

              const SizedBox(height: 12),

              // ================= SCHEDULE CARD =================
              _sectionCard(
                title: "Schedule",
                child: Column(
                  children: [
                    _modernTile(
                      icon: Icons.calendar_month,
                      text: selectedDate == null
                          ? "Select Date"
                          : selectedDate.toString().split(" ")[0],
                      onTap: pickDate,
                    ),
                    const SizedBox(height: 10),
                    _modernTile(
                      icon: Icons.access_time,
                      text: selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                      onTap: pickTime,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ================= STATUS CARD =================
              _sectionCard(
                title: "Status",
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ["Pending", "Confirmed", "Completed", "Cancelled"]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedStatus = v!),
                  decoration: _inputDecoration(),
                ),
              ),

              const SizedBox(height: 12),

              // ================= NOTES =================
              _sectionCard(
                title: "Notes",
                child: TextFormField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: _inputDecoration(hint: "Optional notes..."),
                ),
              ),

              const SizedBox(height: 20),

              // ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Booking"),
                ),
              ),
            ],
          ),
        ),
      ),
    );







    /*return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Create Booking",
        ),
      ),

      body: Form(

        key: _formKey,

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // =====================================
              // CLIENT TYPE
              // =====================================

              const Text(
                "Client Type",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              Row(
                children: [

                  Expanded(
                    child: RadioListTile<bool>(
                      value: true,
                      groupValue:
                      isExistingClient,
                      title: const Text(
                        "Existing",
                      ),
                      onChanged: (v) {

                        setState(() {
                          isExistingClient =
                          true;
                        });
                      },
                    ),
                  ),

                  Expanded(
                    child: RadioListTile<bool>(
                      value: false,
                      groupValue:
                      isExistingClient,
                      title: const Text(
                        "New",
                      ),
                      onChanged: (v) {

                        setState(() {
                          isExistingClient =
                          false;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =====================================
              // EXISTING CLIENT
              // =====================================

              if (isExistingClient)

                DropdownButtonFormField<
                    ClientModel>(

                  value: selectedClient,

                  decoration:
                  const InputDecoration(
                    labelText:
                    "Select Client",
                    border:
                    OutlineInputBorder(),
                  ),

                  items:
                  clients.map((client) {

                    return DropdownMenuItem(
                      value: client,
                      child: Text(
                        client.fullName,
                      ),
                    );

                  }).toList(),

                  onChanged: (v) {

                    setState(() {
                      selectedClient = v;
                    });
                  },
                ),

              // =====================================
              // NEW CLIENT
              // =====================================

              if (!isExistingClient)

                Column(
                  children: [

                    TextFormField(
                      controller:
                      firstNameController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "First Name",
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextFormField(
                      controller:
                      lastNameController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Last Name",
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextFormField(
                      controller:
                      emailController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Email",
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextFormField(
                      controller:
                      phoneController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Phone",
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // =====================================
              // SERVICE
              // =====================================

              DropdownButtonFormField<
                  ServiceModel>(

                value: selectedService,

                decoration:
                const InputDecoration(
                  labelText:
                  "Select Service",
                  border:
                  OutlineInputBorder(),
                ),

                items:
                services.map((service) {

                  return DropdownMenuItem(
                    value: service,
                    child: Text(
                      service.name,
                    ),
                  );

                }).toList(),

                onChanged: (v) {

                  setState(() {
                    selectedService = v;
                  });
                },
              ),

              const SizedBox(height: 20),

              // =====================================
              // DATE
              // =====================================

              ListTile(

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),

                title: Text(

                  selectedDate == null
                      ? "Select Date"
                      : selectedDate!
                      .toString()
                      .split(" ")[0],
                ),

                trailing:
                const Icon(Icons.calendar_month),

                onTap: pickDate,
              ),

              const SizedBox(height: 16),

              // =====================================
              // TIME
              // =====================================

              ListTile(

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),

                title: Text(

                  selectedTime == null
                      ? "Select Time"
                      : selectedTime!
                      .format(context),
                ),

                trailing:
                const Icon(Icons.access_time),

                onTap: pickTime,
              ),

              const SizedBox(height: 20),

              // =====================================
              // STATUS
              // =====================================

              DropdownButtonFormField<String>(

                value: selectedStatus,

                decoration:
                const InputDecoration(
                  labelText: "Status",
                  border:
                  OutlineInputBorder(),
                ),

                items: [

                  "Pending",
                  "Confirmed",
                  "Completed",
                  "Cancelled"

                ].map((status) {

                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );

                }).toList(),

                onChanged: (v) {

                  setState(() {
                    selectedStatus = v!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // =====================================
              // NOTES
              // =====================================

              TextFormField(

                controller:
                notesController,

                maxLines: 4,

                decoration:
                const InputDecoration(
                  labelText: "Notes",
                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              // =====================================
              // BUTTON
              // =====================================

              SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed:
                  isSaving
                      ? null
                      : saveBooking,

                  child:
                  isSaving
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Create Booking",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );*/




  }
}

Widget _sectionCard({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

Widget _modernInput(TextEditingController c, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: c,
      decoration: _inputDecoration(hint: label),
    ),
  );
}

InputDecoration _inputDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF6F7FB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

Widget _modernTile({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return ListTile(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    tileColor: const Color(0xFFF6F7FB),
    leading: Icon(icon),
    title: Text(text),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    onTap: onTap,
  );
}

Widget _modernRadio({
  required String title,
  required bool value,
  required bool groupValue,
  required Function(bool?) onChanged,
}) {
  return RadioListTile<bool>(
    value: value,
    groupValue: groupValue,
    title: Text(title),
    activeColor: Colors.black,
    onChanged: onChanged,
  );
}

Widget _modernDropdown<T>({
  required String hint,
  required T? value,
  required List<T> items,
  required String Function(T) labelBuilder,
  required Function(T?) onChanged,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    decoration: _inputDecoration(hint: hint),
    items: items
        .map((e) => DropdownMenuItem(
      value: e,
      child: Text(labelBuilder(e)),
    ))
        .toList(),
    onChanged: onChanged,
  );
}