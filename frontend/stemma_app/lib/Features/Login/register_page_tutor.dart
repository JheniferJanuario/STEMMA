import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/primary_button.dart';

class RegisterTutorPage extends StatefulWidget {
  const RegisterTutorPage({super.key});

  @override
  State<RegisterTutorPage> createState() => _RegisterTutorPageState();
}

class _RegisterTutorPageState extends State<RegisterTutorPage> {
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 60),

                    const Text(
                      'Cadastrar',
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
                      label: 'Nome',
                      hintText: 'Insira seu nome',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),

                    const LabeledTextField(
                      label: 'CPF',
                      hintText: 'Insira seu CPF',
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 24),

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

                    const SizedBox(height: 62),

                    SizedBox(
                      width: isDesktop ? 320 : double.infinity,
                      child: PrimaryButton(
                        text: 'Cadastrar',
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                        },
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