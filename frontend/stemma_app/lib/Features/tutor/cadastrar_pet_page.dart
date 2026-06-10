import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/simple_components.dart';

class CadastrarPetPage extends StatefulWidget {
  const CadastrarPetPage({super.key});

  @override
  State<CadastrarPetPage> createState() => _CadastrarPetPageState();
}

class _CadastrarPetPageState extends State<CadastrarPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _tutorIdController = TextEditingController();
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

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    final tutorIdDigitado = _tutorIdController.text.trim();
    final tutorId = tutorIdDigitado.isEmpty ? ApiService.usuarioLogadoId : tutorIdDigitado;

    if (tutorId == null || tutorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tutor não encontrado.')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet cadastrado com sucesso!')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar pet: $e')));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  String? _campoObrigatorio(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _idadeValida(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    if (int.tryParse(value.trim()) == null) return 'Digite um número';
    return null;
  }

  String? _pesoValido(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    if (double.tryParse(value.trim().replaceAll(',', '.')) == null) return 'Digite um número';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        title: const SimpleTitle(text: 'Cadastrar Pet'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.pets, size: 60, color: AppColors.primaryGreen),
            const SizedBox(height: 20),
            SimpleTextField(label: 'Nome do pet', hint: 'Digite o nome', controller: _nomeController, validator: _campoObrigatorio),
            SimpleTextField(label: 'Raça', hint: 'Ex: Poodle', controller: _racaController, validator: _campoObrigatorio),
            SimpleTextField(label: 'Idade', hint: 'Ex: 3', controller: _idadeController, keyboardType: TextInputType.number, validator: _idadeValida),
            SimpleTextField(label: 'Peso', hint: 'Ex: 8.5', controller: _pesoController, keyboardType: TextInputType.number, validator: _pesoValido),
            SimpleTextField(label: 'Tutor ID', hint: 'Pode deixar vazio usando o tutor logado', controller: _tutorIdController),
            SimpleButton(text: _carregando ? 'Salvando...' : 'Salvar pet', onPressed: _carregando ? null : _salvarPet),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 2),
    );
  }
}
