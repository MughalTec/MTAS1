import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {

  final companyController =
  TextEditingController();

  final addressController =
  TextEditingController();

  final cityController =
  TextEditingController();

  final stateController =
  TextEditingController();

  final zipController =
  TextEditingController();

  final countryController =
  TextEditingController();

  bool loading = false;

  Future<void> saveProfile() async {

    setState(() {
      loading = true;
    });

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final result =
    await ApiService.saveCompanyDetails(
      providerId: user.uid,
      companyName:
      companyController.text,
      billingAddress:
      addressController.text,
      city: cityController.text,
      state: stateController.text,
      zipCode: zipController.text,
      country: countryController.text,
    );

    setState(() {
      loading = false;
    });

    if (result["success"] == true && mounted) {

     /* Navigator.pushReplacementNamed(
        context,
        '/dashboard',
      );*/
      if (mounted) {
        context.go('/dashboard');
      }
    }
  }

  Widget field(
      String hint,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xffF4F6FF),

      body: Center(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.all(24),

          child: Container(
            constraints:
            const BoxConstraints(
              maxWidth: 500,
            ),

            padding:
            const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(28),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.06),
                  blurRadius: 30,
                )
              ],
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(
                  "Complete Profile",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Please enter your company details",
                ),

                const SizedBox(height: 30),

                field(
                  "Company Name",
                  companyController,
                ),

                field(
                  "Billing Address",
                  addressController,
                ),

                field(
                  "City",
                  cityController,
                ),

                field(
                  "State",
                  stateController,
                ),

                field(
                  "Zip Code",
                  zipController,
                ),

                field(
                  "Country",
                  countryController,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed:
                    loading
                        ? null
                        : saveProfile,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xff6C63FF,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(18),
                      ),
                    ),

                    child:
                    loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.bold,
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
  }
}