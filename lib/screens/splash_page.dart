import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weebsoul/screens/welcome_page.dart';
import 'package:weebsoul/screens/navigation_root.dart';
import 'package:weebsoul/widgets/app_logo.dart';
import 'package:weebsoul/widgets/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    // ⚡ Cek status login setelah 2.5 detik
    Timer(const Duration(milliseconds: 2500), () {
      _checkAuthStatus();
    });
  }

  // ⚡ Cek apakah user sudah login atau belum
  Future<void> _checkAuthStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null) {
      // ✅ User sudah login → Langsung ke Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          FadeSlidePageRoute(page: const NavigationRoot()),
        );
      }
    } else {
      // ❌ User belum login → Ke Welcome/Login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          FadeSlidePageRoute(page: const WelcomePage()),
        );
      }
    }
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
