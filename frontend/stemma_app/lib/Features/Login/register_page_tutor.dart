import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Service/authService.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/primary_button.dart';

class RegisterTutorPage extends StatefulWidget {
  const RegisterTutorPage({super.key});

  @override
  State<RegisterTutorPage> createState() => _RegisterTutorPageState();
}

class _RegisterTutorPageState extends State<RegisterTutorPage> {
  bool obscurePassword = true;
  bool _carregando = false;

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    // Validação básica
    if (_nomeController.text.trim().isEmpty ||
        _cpfController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await _authService.cadastrarTutor(
        nome: _nomeController.text.trim(),
        cpf: _cpfController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

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
                    Container(width: 60, height: 2, color: AppColors.primaryGreen),
                    const SizedBox(height: 28),

                    LabeledTextField(
                      label: 'Nome',
                      hintText: 'Insira seu nome',
                      prefixIcon: Icons.person_outline,
                      controller: _nomeController,
                    ),
                    const SizedBox(height: 24),

                    LabeledTextField(
                      label: 'CPF',
                      hintText: 'Insira seu CPF',
                      prefixIcon: Icons.badge_outlined,
                      controller: _cpfController,
                    ),
                    const SizedBox(height: 24),

                    LabeledTextField(
                      label: 'Email',
                      hintText: 'Insira seu email',
                      prefixIcon: Icons.mail_outline,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 24),

                    LabeledTextField(
                      label: 'Senha',
                      hintText: 'Insira sua senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      controller: _senhaController,
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
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: 'Cadastrar',
                              onPressed: _cadastrar, 
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