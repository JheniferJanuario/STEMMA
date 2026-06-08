import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/primary_button.dart';
import 'package:stemma_app/Features/tutor/cadastrar_pet_page.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final TextEditingController _searchController = TextEditingController();

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
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pets: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<dynamic> get _petsFiltrados {
    if (_busca.trim().isEmpty) return _pets;
    final termo = _busca.toLowerCase();
    return _pets.where((p) {
      final nome = (p['nome'] ?? p['name'] ?? '').toString().toLowerCase();
      return nome.contains(termo);
    }).toList();
  }

  Future<void> _abrirHistorico(dynamic pet) async {
    final petId = pet['id'].toString();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final resultados = await Future.wait([
        ApiService.listarHistoricoConsultasPorPet(petId),
        ApiService.listarProntuariosPorPet(petId),
      ]);
      if (mounted) Navigator.pop(context);
      if (!mounted) return;
      _mostrarHistorico(pet, resultados[0], resultados[1]);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar histórico: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _mostrarHistorico(dynamic pet, List<dynamic> consultas, List<dynamic> prontuarios) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Histórico de ${pet['nome'] ?? pet['name'] ?? 'Pet'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        const Text('Consultas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (consultas.isEmpty)
                          const Text('Nenhuma consulta encontrada.', style: TextStyle(color: AppColors.textGrey))
                        else
                          ...consultas.map((c) => Card(
                                child: ListTile(
                                  leading: const Icon(Icons.event, color: AppColors.primaryGreen),
                                  title: Text(_formatarData(c['dateTime'] ?? c['dataConsulta'])),
                                  subtitle: Text('Status: ${c['status'] ?? '-'}'),
                                ),
                              )),
                        const SizedBox(height: 20),
                        const Text('Prontuários', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (prontuarios.isEmpty)
                          const Text('Nenhum prontuário encontrado.', style: TextStyle(color: AppColors.textGrey))
                        else
                          ...prontuarios.map((p) => Card(
                                child: ListTile(
                                  leading: const Icon(Icons.description, color: AppColors.primaryGreen),
                                  title: Text((p['descricao'] ?? p['description'] ?? 'Prontuário').toString()),
                                  subtitle: Text(
                                    [
                                      if ((p['diagnostico'] ?? '').toString().isNotEmpty) 'Diagnóstico: ${p['diagnostico']}',
                                      if ((p['tratamento'] ?? '').toString().isNotEmpty) 'Tratamento: ${p['tratamento']}',
                                      if ((p['medicacao'] ?? '').toString().isNotEmpty) 'Medicação: ${p['medicacao']}',
                                    ].join('\n'),
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatarData(dynamic raw) {
    if (raw == null) return 'Data não informada';
    final dt = DateTime.parse(raw.toString()).toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final petsFiltrados = _petsFiltrados;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: const Text(
          'Pets',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _busca = value),
              decoration: InputDecoration(
                hintText: 'Pesquisar pet pelo nome',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : petsFiltrados.isEmpty
                    ? const Center(
                        child: Text('Nenhum pet encontrado.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
                      )
                    : RefreshIndicator(
                        onRefresh: _buscarPets,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: petsFiltrados.length,
                          itemBuilder: (context, index) {
                            final pet = petsFiltrados[index];
                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const Icon(Icons.pets, color: AppColors.primaryGreen),
                                title: Text((pet['nome'] ?? pet['name'] ?? 'Pet sem nome').toString()),
                                subtitle: Text('Raça: ${pet['raca'] ?? '-'} • Idade: ${pet['idade'] ?? '-'} ano(s)'),
                                trailing: const Icon(Icons.history, color: AppColors.primaryGreen),
                                onTap: () => _abrirHistorico(pet),
                              ),
                            );
                          },
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(
              text: '+ Adicionar pet',
              onPressed: () async {
                final salvou = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastrarPetPage()),
                );
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
