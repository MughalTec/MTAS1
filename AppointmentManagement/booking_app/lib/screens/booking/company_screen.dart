import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../services/company_service.dart';
import '../../widgets/app_drawer.dart';
import '../../config/theme.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyService _service = CompanyService();

  List<Company> companies = [];
  List<Company> filtered = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await _service.getCompanies();
    setState(() {
      companies = data;
      filtered = data;
      isLoading = false;
    });
  }

  void search(String value) {
    setState(() {
      filtered = companies
          .where((c) =>
          c.companyname.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }


  void showForm({Company? company}) {
    final name = TextEditingController(text: company?.companyname ?? "");
    final address = TextEditingController(text: company?.billingaddress ?? "");
    final city = TextEditingController(text: company?.city ?? "");
    final state = TextEditingController(text: company?.state ?? "");
    final zip = TextEditingController(text: company?.zipcode ?? "");
    final country = TextEditingController(text: company?.country ?? "");

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      company == null ? "Add Company" : "Edit Company",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    _field(name, "Company Name"),
                    _field(address, "Billing Address"),
                    _field(city, "City"),
                    _field(state, "State"),
                    _field(zip, "Zip Code"),
                    _field(country, "Country"),

                    const SizedBox(height: 20),

                    InkWell(
                      onTap: () async {
                        if (name.text.isEmpty) return;

                        if (company == null) {
                          await _service.addCompany(
                            Company(
                              companyname: name.text,
                              billingaddress: address.text,
                              city: city.text,
                              state: state.text,
                              zipcode: zip.text,
                              country: country.text,
                            ),
                          );
                        } else {
                          company.companyname = name.text;
                          company.billingaddress = address.text;
                          company.city = city.text;
                          company.state = state.text;
                          company.zipcode = zip.text;
                          company.country = country.text;

                          await _service.updateCompany(company);
                        }

                        Navigator.pop(context);
                        loadData();
                      },

                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "Save Company",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  void deleteCompany(int id) async {
    await _service.deleteCompany(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Companies"),
        centerTitle: false,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [


            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: search,
                decoration: const InputDecoration(
                  hintText: "Search Company...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),

            const SizedBox(height: 16),


            Expanded(
              child: filtered.isEmpty
                  ? _empty()
                  : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => _card(filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _card(Company c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [


          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business, color: Colors.white),
          ),

          const SizedBox(width: 12),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.companyname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "${c.city ?? ""} • ${c.country ?? ""}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),


          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showForm(company: c),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteCompany(c.id!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("No companies found"),
        ],
      ),
    );
  }
}