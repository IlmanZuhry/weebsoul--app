import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weebsoul/screens/welcome_page.dart';
import 'package:weebsoul/widgets/app_logo.dart';
import 'package:weebsoul/widgets/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Auto navigate after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        FadeSlidePageRoute(page: const WelcomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 140),
              const SizedBox(height: 24),
              Text("Weebsoul", style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 12),
              Text(
                "Feel the soul of creativity.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
