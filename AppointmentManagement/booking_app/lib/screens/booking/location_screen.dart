import 'package:flutter/material.dart';
import '../../models/location.dart';
import '../../services/location_service.dart';
import '../../widgets/app_drawer.dart';
import '../../config/theme.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _service = LocationService();

  List<Location> locations = [];
  List<Location> filtered = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await _service.getLocations();

    setState(() {
      locations = data;
      filtered = data;
      isLoading = false;
    });
  }

  void search(String value) {
    setState(() {
      filtered = locations
          .where((l) =>
          l.locationname.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void showForm({Location? location}) {
    final locationname = TextEditingController(text: location?.locationname ?? "");
    final address = TextEditingController(text: location?.address ?? "");
    final city = TextEditingController(text: location?.city ?? "");
    final state = TextEditingController(text: location?.state ?? "");
    final country = TextEditingController(text: location?.country ?? "");
    final timezone = TextEditingController(text: location?.timezone ?? "");
    final phone = TextEditingController(text: location?.phoneno ?? "");
    bool active = location?.active ?? true;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          location == null ? "Add Location" : "Edit Location",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        _field(locationname, "Location Name"),
                        _field(address, "Address"),
                        _field(city, "City"),
                        _field(state, "State"),
                        _field(country, "Country"),
                        _field(timezone, "Time Zone"),
                        _field(phone, "Phone No"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Active"),
                            Switch(
                              value: active,
                              onChanged: (val) {
                                setStateDialog(() {
                                  active = val;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () async {
                            if (locationname.text.isEmpty) return;

                            if (location == null) {
                              await _service.addLocation(Location(
                                locationname: locationname.text.trim(),
                                address: address.text.trim(),
                                city: city.text.trim(),
                                state: state.text.trim(),
                                country: country.text.trim(),
                                timezone: timezone.text.trim(),
                                phoneno: phone.text.trim(),
                                active: active,
                              ));
                            } else {
                              location.locationname = locationname.text;
                              location.address = address.text;
                              location.city = city.text;
                              location.state = state.text;
                              location.country = country.text;
                              location.timezone = timezone.text;
                              location.phoneno = phone.text;
                              location.active = active;

                              await _service.updateLocation(location);
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

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  void deleteLocation(int id) async {
    await _service.deleteLocation(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Locations")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: const InputDecoration(
                hintText: "Search Location...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) => _card(filtered[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Location l) {
    return Card(
      child: ListTile(
        title: Text(l.locationname),
        subtitle: Text("${l.city} • ${l.country}"),
        leading: Icon(
          l.active ? Icons.check_circle : Icons.cancel,
          color: l.active ? Colors.green : Colors.red,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showForm(location: l),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteLocation(l.id!),
            ),
          ],
        ),
      ),
    );
  }
}