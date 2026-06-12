import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/label_text_field.dart';
import 'package:stemma_app/Core/Widgets/login_header.dart';
import 'package:stemma_app/Core/Widgets/tipo_de_usuario.dart';
import 'package:stemma_app/Features/Login/register_page_tutor.dart';
import 'package:stemma_app/Features/Login/register_page_veterinario.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';
import 'package:stemma_app/Features/Tutor/home_page.dart';
import 'package:stemma_app/Features/Veterinario/home_veterinario_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool isVeterinario = true;
  bool obscurePassword = true;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha.')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await ApiService.login(email: email, senha: senha);

      if (!mounted) return;

      final tipo = (usuario['tipoUsuario'] ?? '').toString().toLowerCase();

      final pagina = tipo.contains('veterinario')
          ? const HomeVeterinarioPage()
          : const HomePage();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => pagina),
        (_) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const LoginHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

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
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => isVeterinario
                                  ? const RegisterVeterinarioPage()
                                  : const RegisterTutorPage(),
                            ),
                          );
                        },
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

                    TipoDeUsuario(
                      isVeterinario: isVeterinario,
                      onChanged: (value) {
                        setState(() {
                          isVeterinario = value;
                        });
                      },
                    ),

                    const SizedBox(height: 40),

                    Center(
                      child: SizedBox(
                        width: isDesktop ? 320 : double.infinity,
                        child: PrimaryButton(
                          text: _carregando ? 'Entrando...' : 'Entrar',
                          onPressed: _carregando ? null : _entrar,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}