import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';

class CadastrarPetPage extends StatefulWidget {
  const CadastrarPetPage({super.key});

  @override
  State<CadastrarPetPage> createState() => _CadastrarPetPageState();
}

class _CadastrarPetPageState extends State<CadastrarPetPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _tutorIdController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _tutorIdController.dispose();
    super.dispose();
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText, IconData prefixIcon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 15),
      prefixIcon: Icon(prefixIcon, color: AppColors.primaryGreen, size: 22),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Future<void> _submeterFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    final tutorIdDigitado = _tutorIdController.text.trim();
    final tutorId = tutorIdDigitado.isNotEmpty
        ? tutorIdDigitado
        : ApiService.usuarioLogadoId;

    if (tutorId == null || tutorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o Tutor ID ou faça login como tutor antes de cadastrar o pet.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await ApiService.cadastrarPet(
        nome: _nomeController.text.trim(),
        raca: _racaController.text.trim(),
        idade: int.parse(_idadeController.text.trim()),
        peso: double.parse(_pesoController.text.trim().replaceAll(',', '.')),
        tutorId: tutorId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet cadastrado com sucesso!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar pet: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastrar Pet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.softGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: AppColors.primaryGreen,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _buildFieldLabel('Nome do Pet *'),
                TextFormField(
                  controller: _nomeController,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration('Digite o nome do pet', Icons.badge_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome do pet não pode estar vazio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Raça *'),
                TextFormField(
                  controller: _racaController,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration('Ex: Poodle, SRD, Siamês', Icons.fingerprint_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'A raça do pet não pode estar vazia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Idade (anos) *'),
                          TextFormField(
                            controller: _idadeController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: _buildInputDecoration('Ex: 3', Icons.calendar_today_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Obrigatório';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'Número inválido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Peso (Kg) *'),
                          TextFormField(
                            controller: _pesoController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: _buildInputDecoration('Ex: 8.5', Icons.monitor_weight_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Obrigatório';
                              }
                              final valorTratado = value.trim().replaceAll(',', '.');
                              if (double.tryParse(valorTratado) == null) {
                                return 'Número inválido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Tutor ID'),
                TextFormField(
                  controller: _tutorIdController,
                  textInputAction: TextInputAction.done,
                  decoration: _buildInputDecoration('Use o ID do tutor logado ou digite manualmente', Icons.person_search_outlined),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  text: _carregando ? 'Salvando...' : 'Adicionar Pet',
                  onPressed: _carregando ? null : _submeterFormulario,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BarraInferiorPet(abaAtiva: 0),
    );
  }
}