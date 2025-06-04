import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/auth_service.dart';
import 'package:minimal_chatapp/components/my_button.dart';
import 'package:minimal_chatapp/components/my_textfield.dart';
import 'package:minimal_chatapp/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _pwController.text.trim(),
      );

      // Navigate to HomePage and clear backstack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    } catch (e) {
      if (context.mounted) {
        // ✅ Show clean error without "Exception:"
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Icon(
              Icons.message,
              color: Theme.of(context).colorScheme.primary,
              size: 60,
            ),
            const SizedBox(height: 25),
            Text(
              'Welcome! You have been missed!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            // Email
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),

            // Password
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 25),

            // Login Button
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    ' Register now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
