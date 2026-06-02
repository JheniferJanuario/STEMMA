import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/wave_clipper.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isDesktop = screenWidth > 900;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(0),
        ),

        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset('assets/logo_splash_creme.png', width: 280),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 280,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 55,
                    left: 0,
                    right: 0,

                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: isDesktop ? 70 : 56,
                            height: isDesktop ? 70 : 56,
                            alignment: Alignment.center,

                            decoration: const BoxDecoration(
                              color: AppColors.lightBackground,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.pets,
                              color: AppColors.primaryGreen,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 14),

                          SizedBox(
                            width: isDesktop ? 320 : 220,
                            child: const Text(
                              'Cuidando da saúde do seu\npet com tecnologia e carinho',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
