import 'package:flutter/material.dart';
import '../../models/services.dart';
import '../../models/location.dart';
import '../../services/services_service.dart';
import '../../services/location_service.dart';
import '../../widgets/app_drawer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ServicesService _service = ServicesService();
  final LocationService _locationService = LocationService();

  List<Services> services = [];
  List<Location> locations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    services = await _service.getServices();
    locations = await _locationService.getLocations();

    setState(() => isLoading = false);
  }

  void showForm({Services? s}) {
    int? selectedLocation = s?.locationId;

    final name = TextEditingController(text: s?.serviceName ?? "");
    final desc = TextEditingController(text: s?.description ?? "");
    final duration = TextEditingController(text: s?.durationMinutes.toString() ?? "");
    final price = TextEditingController(text: s?.price.toString() ?? "");

    bool active = s?.active ?? true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setStateDialog) {
          return AlertDialog(
            title: Text(s == null ? "Add Service" : "Edit Service"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedLocation,
                    hint: const Text("Select Location"),
                    items: locations.map((loc) {
                      return DropdownMenuItem(
                        value: loc.id,
                        child: Text(loc.locationname),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setStateDialog(() => selectedLocation = val);
                    },
                  ),

                  TextField(controller: name, decoration: const InputDecoration(labelText: "Service Name")),
                  TextField(controller: desc, decoration: const InputDecoration(labelText: "Description")),
                  TextField(controller: duration, decoration: const InputDecoration(labelText: "Duration")),
                  TextField(controller: price, decoration: const InputDecoration(labelText: "Price")),

                  SwitchListTile(
                    value: active,
                    onChanged: (v) => setStateDialog(() => active = v),
                    title: const Text("Active"),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (selectedLocation == null) return;

                  if (s == null) {
                    await _service.addService(Services(
                      locationId: selectedLocation!,
                      locationName: "",
                      serviceName: name.text,
                      description: desc.text,
                      durationMinutes: int.tryParse(duration.text) ?? 0,
                      bufferBefore: 0,
                      bufferAfter: 0,
                      price: double.tryParse(price.text) ?? 0,
                      active: active,
                    ));
                  } else {
                    s.locationId = selectedLocation!;
                    s.serviceName = name.text;
                    s.description = desc.text;
                    s.durationMinutes = int.tryParse(duration.text) ?? 0;
                    s.price = double.tryParse(price.text) ?? 0;
                    s.active = active;

                    await _service.updateService(s);
                  }

                  Navigator.pop(context);
                  loadAll();
                },
                child: const Text("Save"),
              )
            ],
          );
        },
      ),
    );
  }

  void delete(int id) async {
    await _service.deleteService(id);
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Services")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) {
          final s = services[i];
          return ListTile(
            title: Text(s.serviceName),
            subtitle: Text("${s.locationName ?? ''} | Rs ${s.price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => showForm(s: s), icon: const Icon(Icons.edit)),
                IconButton(onPressed: () => delete(s.id!), icon: const Icon(Icons.delete)),
              ],
            ),
          );
        },
      ),
    );
  }
}