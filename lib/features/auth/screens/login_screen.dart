import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  String _friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found for this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'too-many-requests':
          return 'Too many attempts. Try again later';
        default:
          return 'Login failed. Please try again';
      }
    }
    return 'Something went wrong';
  }

  Future<void> _login() async {
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.isEmpty) {
      _showSnack('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnack(_friendlyError(e));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.local_parking, size: 90, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Email
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  if (emailCtrl.text.trim().isEmpty) {
                    _showSnack('Enter email to reset password');
                    return;
                  }
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailCtrl.text.trim(),
                  );
                  _showSnack('Password reset email sent');
                },
                child: const Text('Forgot password?'),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
