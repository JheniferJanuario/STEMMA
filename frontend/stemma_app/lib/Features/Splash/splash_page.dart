import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/wave_clipper.dart';
import 'package:stemma_app/Features/Splash/welcome_page.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Features/tutor/home_page.dart';
import 'package:stemma_app/Features/vet/home_veterinario_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    _navigateToWelcome();
  }

  void _navigateToWelcome() {
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        await ApiService.inicializarSessao();
        if (!mounted) return;

        final destino = ApiService.estaLogado
            ? (ApiService.usuarioEhVeterinario
                ? const HomeVeterinarioPage()
                : const HomePage())
            : const WelcomePage();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => destino,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;

    final isDesktop =
        screenWidth > 900;

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
              child: Image.asset(
                'assets/logo_splash_creme.png',
                width: 280,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Stack(
                children: [

                  Align(
                    alignment:
                        Alignment.bottomCenter,

                    child: ClipPath(
                      clipper: WaveClipper(),

                      child: Container(
                        height: 280,
                        width: double.infinity,
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 55,
                    left: 0,
                    right: 0,

                    child: Center(
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Container(
                            width: isDesktop ? 70:56,
                            height: isDesktop  ? 70:56,

                            alignment:Alignment.center,

                            decoration:
                              const BoxDecoration(
                              color:AppColors.lightBackground,
                              shape:BoxShape.circle,
                            ),

                            child:const Icon(
                              Icons.pets,
                              color:AppColors.primaryGreen,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 14),

                          SizedBox(
                            width:isDesktop ? 320 : 220,
                            child: const Text(
                              'Cuidando da saúde do seu\npet com tecnologia e carinho',
                              textAlign:TextAlign.left,
                              style:TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 15,
                                fontWeight:FontWeight .w500,
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