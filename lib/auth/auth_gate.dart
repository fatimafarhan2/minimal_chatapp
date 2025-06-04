import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/Login_or_Register.dart';
import 'package:minimal_chatapp/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            print("User logged in with UID: ${user?.uid}");
            return HomePage();
          } else {
            print("User is not logged in; showing LoginOrRegister page.");
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
