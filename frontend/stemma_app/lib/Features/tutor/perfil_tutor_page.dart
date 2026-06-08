import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Features/tutor/cadastrar_pet_page.dart';

class PerfilTutorPage extends StatelessWidget {
  const PerfilTutorPage({super.key});

  Future<void> _sair(BuildContext context) async {
    await ApiService.sair();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = ApiService.usuarioLogadoNome ?? 'Tutor';
    final email = ApiService.usuarioLogado?['email']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: const Text('Meu perfil', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => _sair(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primaryGreen,
              child: Icon(Icons.person, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 18),
            Text(nome, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(email, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textGrey)),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white),
              icon: const Icon(Icons.pets),
              label: const Text('Adicionar pet'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastrarPetPage())),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
              onPressed: () => _sair(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 3),
    );
  }
}
