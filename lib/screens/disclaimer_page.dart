import 'package:flutter/material.dart';
import 'package:weebsoul/screens/login_page.dart';
import 'package:weebsoul/widgets/page_transition.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String disclaimerText =
        'Weebsouls is an Unofficial App. All trademarks and copyright protected to the respective owner. We do not accept responsibility for content hosted on third party and does not have any involvement in the downloading/uploading. We just post link available in internet. If you think any of the contents infringes any intellectual property law and you hold the copyright of that content report it to admin@weebsoul.app and the content will be immediately removed. By using this Application, you signify your acceptance of this policy.';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Disclaimer',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    disclaimerText,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Continue
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      FadeSlidePageRoute(page: const LoginPage()),
                    );
                  },
                  child: const Text("Continue"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
