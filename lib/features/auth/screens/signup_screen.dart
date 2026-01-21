import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool isLoading = false;

  String _friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'weak-password':
          return 'Password should be at least 6 characters';
        default:
          return 'Signup failed. Try again';
      }
    }
    return 'Something went wrong';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _signup() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill all fields');
      return;
    }

    if (pass != confirm) {
      _showSnack('Passwords do not match');
      return;
    }

    if (pass.length < 6) {
      _showSnack('Password must be at least 6 characters');
      return;
    }

    setState(() => isLoading = true);
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await cred.user?.sendEmailVerification();

      _showSnack('Verification email sent');

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnack(_friendlyError(e));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
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
            const Icon(Icons.person_add_outlined,
                size: 90, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              'Join Smart Parking',
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
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : _signup,
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
                      'Create Account',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
