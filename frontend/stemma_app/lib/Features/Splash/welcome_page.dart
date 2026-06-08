import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/wave_clipper.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';
import 'package:stemma_app/Features/Login/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.primaryGreen,
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Image.asset('assets/logo_stemma_brasao.png', height: 90),

            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao\nSTEMMA!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Gerencie consultas, acompanhe prontuários e organize atendimentos veterinários de forma prática.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.textGrey),
              ),
            ),

            const SizedBox(height: 25),

            Image.asset('assets/image_splash_animais.png', height: 260),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: SizedBox(
                  width: isDesktop ? 320 : double.infinity,

                  child: PrimaryButton(
                    text: 'Começar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
