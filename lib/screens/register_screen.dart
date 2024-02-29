import 'package:flutter/material.dart';
import '../services/register_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password_confirmationController =
      TextEditingController();
  final RegisterService _registerService = RegisterService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password_confirmationController.dispose();
    super.dispose();
  }

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfirmation = _password_confirmationController.text.trim();

    if (!_validateName(name) ||
        !_validateEmail(email) ||
        !_validatePassword(password, passwordConfirmation)) {
      return;
    }

    try {
      await _registerService.register(
          name, email, password, passwordConfirmation);
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration Successful.'),
      ));
      // Registration successful. Navigate to the login screen.
    } catch (e) {
      // Handle registration errors.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration failed. Please try again.'),
      ));
      print(e.toString());
    }
  }

  bool _validateName(String name) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your name.'),
      ));
      return false;
    }
    return true;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w\-\.\+]+@[\w\-\.\+]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email.'),
      ));
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid email format.'),
      ));
      return false;
    }
    return true;
  }

  bool _validatePassword(String password, String passwordConfirmation) {
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your password.'),
      ));
      return false;
    } else if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password must be at least 6 characters.'),
      ));
      return false;
    } else if (password != passwordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match.'),
      ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _password_confirmationController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _register,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Register'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
