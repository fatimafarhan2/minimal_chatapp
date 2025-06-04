import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/auth_service.dart';
import 'package:minimal_chatapp/pages/register_page.dart'; // Import RegisterPage
import 'package:minimal_chatapp/pages/login_page.dart';
import 'package:minimal_chatapp/pages/settings_page.dart'; // Import LoginPage

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();

    // Navigate to LoginPage and pass the onTap function
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onTap: () {
            // Navigate to RegisterPage when "Register now" is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),
              // Home ListTile
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Settings ListTile
            ],
          ),
          Spacer(flex: 1),
          // Logout ListTile
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: Icon(Icons.logout),
              onTap: () => logout(context), // Pass context for navigation
            ),
          ),
        ],
      ),
    );
  }
}
