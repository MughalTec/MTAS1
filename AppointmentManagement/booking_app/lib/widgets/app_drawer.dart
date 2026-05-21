import 'package:booking_app/screens/booking/location_screen.dart';
import 'package:booking_app/screens/booking/services_screen.dart';
import 'package:booking_app/screens/booking/user_screen.dart';
import 'package:flutter/material.dart';
import '../screens/provider/dashboard_screen.dart';
import '../screens/booking/company_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "My App",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.business),
            title: const Text("Company"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompanyScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.location_pin),
            title: const Text("Location"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocationScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Services"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServicesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}