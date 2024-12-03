import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:cursova/screens/delete_account_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final userId = await _authService.login(username, password);
      if (userId != null) {
        Navigator.pushNamed(context, '/calculator', arguments: userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong login or password!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final _deleteUsernameController = TextEditingController();
        final _deletePasswordController = TextEditingController();

        return AlertDialog(
          title: Text('Delete account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _deleteUsernameController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              TextField(
                controller: _deletePasswordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final username = _deleteUsernameController.text;
                final password = _deletePasswordController.text;

                try {
                  final success = await _authService.deleteAccount(username, password);
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account deleted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wrong login or password!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to My Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
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
            ElevatedButton(onPressed: _login, child: Text('Sign in')),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Sign up'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              child: Text('Delete account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
