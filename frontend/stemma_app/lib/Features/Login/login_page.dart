import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Core/Widgets/type_selector.dart';
import 'package:stemma_app/Features/Login/register_page_tutor.dart';
import 'package:stemma_app/Features/Login/register_page_veterinario.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/primary_button.dart';
import 'package:stemma_app/Features/tutor/home_page.dart';
import 'package:stemma_app/Features/vet/home_veterinario_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVeterinario = true;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            const LoginHeader(),

            const SizedBox(height: 130),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Acessar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      width: 60, 
                      height: 2, 
                      color: AppColors.primaryGreen,
                    ),

                    const SizedBox(height: 28),

                    const LabeledTextField(
                      label: 'Email',
                      hintText: 'Insira seu email',
                      prefixIcon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 24),

                    LabeledTextField(
                      label: 'Senha',
                      hintText: 'Insira sua senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          obscurePassword = !obscurePassword;
                        }),
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => isVeterinario
                                ? const RegisterVeterinarioPage()
                                : const RegisterTutorPage(),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Não possui conta? ',
                            style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Cadastre-se.',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Center(
                      child: Text(
                        'Por favor, nos diga como você deseja se conectar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11, 
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    UserTypeSelector(
                      isVeterinario: isVeterinario,
                      onChanged: (value) => setState(() => isVeterinario = value),
                    ),

                    const SizedBox(height: 64),

                    Center(
                      child: SizedBox(
                        width: isDesktop ? 320 : double.infinity,
                        child: PrimaryButton(
                          text: 'Entrar',
                          onPressed: () {
                            if (isVeterinario) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeVeterinarioPage()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}