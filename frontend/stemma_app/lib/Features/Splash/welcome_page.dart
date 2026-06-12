import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/wave_clipper.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';
import 'package:stemma_app/Features/Login/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.25,
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
                        height: screenHeight * 0.12, 
                        width: double.infinity,
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Image.asset(
              'assets/logo_stemma_brasao.png', 
              height: screenHeight * 0.10,
            ),

            SizedBox(height: screenHeight * 0.02),

            Text(
              'Bem-vindo ao\nSTEMMA!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth < 360 ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Gerencie consultas, acompanhe prontuários e organize atendimentos veterinários de forma prática.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth < 360 ? 14 : 16, 
                  color: AppColors.textGrey
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/image_splash_animais.png',
                  fit: BoxFit.contain, 
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

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
            
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}