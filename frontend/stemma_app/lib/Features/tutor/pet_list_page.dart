import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/simple_components.dart';
import 'package:stemma_app/Features/Tutor/cadastrar_pet_page.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final _searchController = TextEditingController();
  List<dynamic> _pets = [];
  bool _carregando = true;
  String _busca = '';

  @override
  void initState() {
    super.initState();
    _buscarPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscarPets() async {
    setState(() => _carregando = true);
    try {
      final lista = await ApiService.listarPets();
      setState(() {
        _pets = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar pets: $e')));
    }
  }

  List<dynamic> get _petsFiltrados {
    if (_busca.trim().isEmpty) return _pets;
    final termo = _busca.toLowerCase();
    return _pets.where((pet) => _texto(pet['nome'] ?? pet['name']).toLowerCase().contains(termo)).toList();
  }

  Future<void> _abrirHistorico(dynamic pet) async {
    final petId = pet['id'].toString();
    try {
      final resultados = await Future.wait([
        ApiService.listarHistoricoConsultasPorPet(petId),
        ApiService.listarProntuariosPorPet(petId),
      ]);
      if (!mounted) return;
      _mostrarHistorico(pet, resultados[0], resultados[1]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar histórico: $e')));
    }
  }

  void _mostrarHistorico(dynamic pet, List<dynamic> consultas, List<dynamic> prontuarios) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SimpleTitle(text: 'Histórico de ${_texto(pet['nome'] ?? pet['name'])}'),
            const SizedBox(height: 16),
            const Text('Consultas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (consultas.isEmpty)
              const Text('Nenhuma consulta encontrada.')
            else
              ...consultas.map((consulta) => SimpleCard(
                    child: Text('${_formatarData(consulta['dateTime'] ?? consulta['dataConsulta'])}\nStatus: ${consulta['status'] ?? '-'}'),
                  )),
            const SizedBox(height: 12),
            const Text('Prontuários', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (prontuarios.isEmpty)
              const Text('Nenhum prontuário encontrado.')
            else
              ...prontuarios.map((prontuario) => SimpleCard(
                    child: Text(_texto(prontuario['descricao'] ?? prontuario['description'] ?? 'Prontuário')),
                  )),
          ],
        );
      },
    );
  }

  String _texto(dynamic value) => value == null ? '-' : value.toString();

  String _formatarData(dynamic raw) {
    if (raw == null) return 'Data não informada';
    final data = DateTime.parse(raw.toString()).toLocal();
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year} $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final pets = _petsFiltrados;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: const SimpleTitle(text: 'Pets'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _busca = value),
              decoration: const InputDecoration(
                labelText: 'Pesquisar pet',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _buscarPets,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return SimpleCard(
                          child: ListTile(
                            leading: const Icon(Icons.pets, color: AppColors.primaryGreen),
                            title: Text(_texto(pet['nome'] ?? pet['name'] ?? 'Pet sem nome')),
                            subtitle: Text('Raça: ${_texto(pet['raca'])} - Idade: ${_texto(pet['idade'])}'),
                            trailing: const Icon(Icons.history),
                            onTap: () => _abrirHistorico(pet),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SimpleButton(
              text: 'Adicionar pet',
              onPressed: () async {
                final salvou = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastrarPetPage()));
                if (salvou == true) _buscarPets();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 2),
    );
  }
}
