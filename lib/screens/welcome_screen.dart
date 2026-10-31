import 'package:flutter/material.dart';

import 'dashboardScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/logo.png', height: 150),
              const SizedBox(height: 24),
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18243A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF687386), height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2878E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Bắt đầu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
