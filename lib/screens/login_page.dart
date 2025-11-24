import 'package:flutter/material.dart';
import 'package:weebsoul/widgets/page_transition.dart';
import 'package:weebsoul/screens/navigation_root.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Login", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  FadeSlidePageRoute(
                    page: const NavigationRoot(), // ← FIXED
                  ),
                );
              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Text("Login with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
