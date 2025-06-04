import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/auth_service.dart';
import 'package:minimal_chatapp/components/my_button.dart';
import 'package:minimal_chatapp/components/my_textfield.dart';
import 'package:minimal_chatapp/pages/home_page.dart';
import 'package:minimal_chatapp/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cnpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cnpwController.dispose();
    super.dispose();
  }

  // Handle registration
  Future<void> register(BuildContext context) async {
    final _auth = AuthService();
    final String email = _emailController.text.trim();
    final String password = _pwController.text.trim();
    final String confirmPassword = _cnpwController.text.trim();

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords don\'t match!'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Password too short'),
          content: Text('Password must be at least 6 characters long.'),
        ),
      );
      return;
    }

    try {
      await _auth.signUpWithEmailPassword(email, password);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
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
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 10),
            MyTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _cnpwController,
            ),
            const SizedBox(height: 25),
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login now',
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
