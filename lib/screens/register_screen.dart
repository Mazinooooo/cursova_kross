import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await _authService.register(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully!')),
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username.isNotEmpty && password.isNotEmpty) {
                  try {
                    await AuthService().register(username, password);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully singed up!')),
                    );
                    // Перехід до іншого екрану, наприклад, на екран логіну
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registration error: $e')),
                    );
                  }
                }
              },
              child: Text('Sing up'),
            )

          ],
        ),
      ),
    );
  }
}
