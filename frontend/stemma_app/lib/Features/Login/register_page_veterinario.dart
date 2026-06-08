import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Service/authService.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/primary_button.dart';

class RegisterVeterinarioPage extends StatefulWidget {
  const RegisterVeterinarioPage({super.key});

  @override
  State<RegisterVeterinarioPage> createState() => _RegisterVeterinarioPageState();
}

class _RegisterVeterinarioPageState extends State<RegisterVeterinarioPage> {
  bool obscurePassword = true;
  bool _carregando = false;

  final _nomeController = TextEditingController();
  final _crmvController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _nomeController.dispose();
    _crmvController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_nomeController.text.trim().isEmpty ||
        _crmvController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _senhaController.text.isEmpty ||
        _especialidadeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await _authService.cadastrarVeterinario(
        nome: _nomeController.text.trim(),
        crmv: _crmvController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
        especialidade: _especialidadeController.text.trim(),
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
                      label: 'CRMV',
                      hintText: 'Insira seu CRMV',
                      prefixIcon: Icons.badge_outlined,
                      controller: _crmvController,
                    ),
                    const SizedBox(height: 24),

                    LabeledTextField(
                      label: 'Especialidade',
                      hintText: 'Ex: Clínico Geral, Ortopedia...',
                      prefixIcon: Icons.medical_services_outlined,
                      controller: _especialidadeController,
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