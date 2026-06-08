import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';

class RegisterVeterinarioPage extends StatefulWidget {
  const RegisterVeterinarioPage({super.key});

  @override
  State<RegisterVeterinarioPage> createState() => _RegisterVeterinarioPageState();
}

class _RegisterVeterinarioPageState extends State<RegisterVeterinarioPage> {
  final _nomeController = TextEditingController();
  final _crmvController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool obscurePassword = true;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _crmvController.dispose();
    _especialidadeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final crmv = _crmvController.text.trim();
    final especialidade = _especialidadeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || crmv.isEmpty || especialidade.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await ApiService.cadastrarVeterinario(
        nome: nome,
        crmv: crmv,
        email: email,
        senha: senha,
        especialidade: especialidade,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veterinário cadastrado com sucesso!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
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
                      'Cadastrar Veterinário',
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
                      controller: _nomeController,
                      label: 'Nome',
                      hintText: 'Insira seu nome',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      controller: _crmvController,
                      label: 'CRMV',
                      hintText: 'Insira seu CRMV',
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      controller: _especialidadeController,
                      label: 'Especialidade',
                      hintText: 'Ex: Clínica geral',
                      prefixIcon: Icons.medical_services_outlined,
                    ),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      hintText: 'Insira seu email',
                      prefixIcon: Icons.mail_outline,
                    ),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      controller: _senhaController,
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
                        text: _carregando ? 'Cadastrando...' : 'Cadastrar',
                        onPressed: _carregando ? null : _cadastrar,
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
