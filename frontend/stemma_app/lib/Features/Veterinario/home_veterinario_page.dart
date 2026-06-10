import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';
import 'package:stemma_app/Core/Widgets/simple_components.dart';
import 'package:stemma_app/Features/Login/login_page.dart';

class HomeVeterinarioPage extends StatefulWidget {
  const HomeVeterinarioPage({super.key});

  @override
  State<HomeVeterinarioPage> createState() => _HomeVeterinarioPageState();
}

class _HomeVeterinarioPageState extends State<HomeVeterinarioPage> {
  final _prontuarioController = TextEditingController();
  dynamic _consultaAtiva;
  List<dynamic> _consultas = [];
  Map<String, String> _nomesPets = {};
  bool _carregando = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _buscarConsultas();
  }

  @override
  void dispose() {
    _prontuarioController.dispose();
    super.dispose();
  }

  Future<void> _buscarConsultas() async {
    setState(() => _carregando = true);

    try {
      final resultados = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarPets(),
      ]);

      final lista = List<dynamic>.from(resultados[0]);
      final pets = List<dynamic>.from(resultados[1]);
      final vetId = ApiService.usuarioLogadoId;

      final filtradas = lista.where((c) {
        final idVet = (c['veterinarianId'] ?? c['veterinarioId'])?.toString();
        final status = _normalizarStatus(c['status']);
        final ehDesteVet = vetId == null || idVet == vetId;
        return ehDesteVet && (status == 'agendada' || status == 'emandamento');
      }).toList()
        ..sort((a, b) {
          final dtA = DateTime.tryParse((a['dateTime'] ?? a['dataConsulta']).toString()) ?? DateTime(2100);
          final dtB = DateTime.tryParse((b['dateTime'] ?? b['dataConsulta']).toString()) ?? DateTime(2100);
          return dtA.compareTo(dtB);
        });

      setState(() {
        _nomesPets = {
          for (final p in pets)
            if (p['id'] != null)
              p['id'].toString(): (p['nome'] ?? p['name'] ?? 'Pet').toString()
        };
        _consultas = filtradas;
        _consultaAtiva = filtradas.isEmpty ? null : filtradas.first;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar consultas: $e')),
      );
    }
  }

  Future<void> _iniciarConsulta() async {
    if (_consultaAtiva == null) return;
    setState(() => _salvando = true);

    try {
      await ApiService.iniciarConsulta(_consultaAtiva['id'].toString());
      await _buscarConsultas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta em andamento.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao iniciar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _finalizarConsulta() async {
    if (_consultaAtiva == null) return;

    final texto = _prontuarioController.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o prontuário antes de finalizar.')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final id = _consultaAtiva['id'].toString();
      await ApiService.adicionarProntuario(consultationId: id, descricao: texto);
      await ApiService.finalizarConsulta(id);
      _prontuarioController.clear();
      await _buscarConsultas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta finalizada.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _sair() async {
    await ApiService.sair();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }


  String _normalizarStatus(dynamic status) {
    final s = (status ?? '').toString().toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    if (s == '1') return 'agendada';
    if (s == '2') return 'emandamento';
    if (s == '3') return 'encerrada';
    if (s == '4') return 'cancelada';
    return s;
  }

  bool _statusAtualEh(String status) {
    if (_consultaAtiva == null) return false;
    return _normalizarStatus(_consultaAtiva['status']) == _normalizarStatus(status);
  }

  String _nomePet(dynamic id) {
    if (id == null) return 'Pet';
    final chave = id.toString();
    return _nomesPets[chave] ?? _cortarId(chave);
  }

  String _cortarId(String id) => id.length > 8 ? '${id.substring(0, 8)}...' : id;

  String _formatarData(dynamic raw) {
    if (raw == null) return 'Sem data';
    final dt = DateTime.parse(raw.toString()).toLocal();
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final temConsulta = _consultaAtiva != null;
    final petId = temConsulta ? (_consultaAtiva['petId'] ?? _consultaAtiva['PetId']) : null;
    final dataRaw = temConsulta ? (_consultaAtiva['dateTime'] ?? _consultaAtiva['dataConsulta']) : null;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: Image.asset('assets/Loggo.png', width: 130),
        actions: [
          IconButton(
            onPressed: _sair,
            icon: const Icon(Icons.logout, color: AppColors.primaryGreen),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _buscarConsultas,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SimpleTitle(text: 'Área do Veterinário'),
            const SizedBox(height: 8),
            Text(
              'Consultas pendentes: ${_consultas.length}',
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 20),

            SimpleCard(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consulta atual',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        if (!temConsulta)
                          const Text('Nenhuma consulta pendente.')
                        else ...[
                          Text('Pet: ${_nomePet(petId)}'),
                          Text('Data: ${_formatarData(dataRaw)}'),
                          Text('Status: ${_consultaAtiva['status'] ?? 'Agendada'}'),
                        ],
                      ],
                    ),
            ),

            if (temConsulta) ...[
              SimpleTextField(
                label: 'Prontuário',
                hint: _statusAtualEh('agendada')
                    ? 'Coloque a consulta em andamento primeiro'
                    : 'Digite o atendimento aqui',
                controller: _prontuarioController,
                maxLines: 4,
                enabled: _statusAtualEh('emandamento'),
              ),
              SimpleButton(
                text: _salvando
                    ? 'Salvando...'
                    : (_statusAtualEh('agendada') ? 'Colocar em andamento' : 'Finalizar consulta'),
                onPressed: _salvando
                    ? null
                    : (_statusAtualEh('agendada') ? _iniciarConsulta : _finalizarConsulta),
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              'Todas as consultas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            if (_consultas.isEmpty && !_carregando)
              const Text('Nenhuma consulta encontrada.')
            else
              ..._consultas.map(
                (consulta) => SimpleCard(
                  child: Text(
                    'Pet: ${_nomePet(consulta['petId'] ?? consulta['PetId'])}'
                    '\n${_formatarData(consulta['dateTime'] ?? consulta['dataConsulta'])}'
                    '\nStatus: ${consulta['status'] ?? '-'}',
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorVet(abaAtiva: 0),
    );
  }
}