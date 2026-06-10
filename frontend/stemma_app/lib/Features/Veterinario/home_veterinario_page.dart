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
      final vetLogadoId = ApiService.usuarioLogadoId;

      final consultasFiltradas = lista.where((consulta) {
        final vetId = (consulta['veterinarianId'] ?? consulta['veterinarioId'])?.toString();
        final status = _normalizarStatus(consulta['status']);
        final pertenceAoVet = vetLogadoId == null || vetId == vetLogadoId;
        return pertenceAoVet && (status == 'agendada' || status == 'emandamento');
      }).toList();

      consultasFiltradas.sort((a, b) {
        final dataA = DateTime.tryParse((a['dateTime'] ?? a['dataConsulta']).toString()) ?? DateTime(2100);
        final dataB = DateTime.tryParse((b['dateTime'] ?? b['dataConsulta']).toString()) ?? DateTime(2100);
        return dataA.compareTo(dataB);
      });

      setState(() {
        _nomesPets = {
          for (final pet in pets)
            if (pet['id'] != null) pet['id'].toString(): (pet['nome'] ?? pet['name'] ?? 'Pet').toString(),
        };
        _consultas = consultasFiltradas;
        _consultaAtiva = consultasFiltradas.isEmpty ? null : consultasFiltradas.first;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar consultas: $e')));
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

  Future<void> _iniciarConsulta() async {
    if (_consultaAtiva == null) return;
    setState(() => _salvando = true);
    try {
      await ApiService.iniciarConsulta(_consultaAtiva['id'].toString());
      await _buscarConsultas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta em andamento.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao iniciar: $e')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _finalizarConsulta() async {
    if (_consultaAtiva == null) return;

    final texto = _prontuarioController.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha o prontuário.')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta finalizada.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao finalizar: $e')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  String _normalizarStatus(dynamic status) {
    final texto = (status ?? '').toString().toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    if (texto == '1') return 'agendada';
    if (texto == '2') return 'emandamento';
    if (texto == '3') return 'encerrada';
    if (texto == '4') return 'cancelada';
    return texto;
  }

  bool _statusEh(String status) {
    if (_consultaAtiva == null) return false;
    return _normalizarStatus(_consultaAtiva['status']) == _normalizarStatus(status);
  }

  String _nomePet(dynamic id) {
    if (id == null) return 'Pet';
    final chave = id.toString();
    return _nomesPets[chave] ?? _formatarGuid(chave);
  }

  String _formatarGuid(String id) => id.length > 8 ? '${id.substring(0, 8)}...' : id;

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
    final temConsulta = _consultaAtiva != null;
    final petId = temConsulta ? (_consultaAtiva['petId'] ?? _consultaAtiva['PetId']) : null;
    final data = temConsulta ? (_consultaAtiva['dateTime'] ?? _consultaAtiva['dataConsulta']) : null;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: Image.asset('assets/Loggo.png', width: 130),
        actions: [IconButton(onPressed: _sair, icon: const Icon(Icons.logout, color: AppColors.primaryGreen))],
      ),
      body: RefreshIndicator(
        onRefresh: _buscarConsultas,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SimpleTitle(text: 'Área do Veterinário'),
            const SizedBox(height: 8),
            Text('Consultas futuras: ${_consultas.length}'),
            const SizedBox(height: 20),
            SimpleCard(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Consulta atual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        if (!temConsulta)
                          const Text('Nenhuma consulta pendente.')
                        else ...[
                          Text('Pet: ${_nomePet(petId)}'),
                          Text('Data: ${_formatarData(data)}'),
                          Text('Status: ${_consultaAtiva['status'] ?? 'Agendada'}'),
                        ],
                      ],
                    ),
            ),
            if (temConsulta) ...[
              SimpleTextField(
                label: 'Prontuário',
                hint: _statusEh('agendada') ? 'Coloque a consulta em andamento primeiro' : 'Digite o atendimento',
                controller: _prontuarioController,
                maxLines: 4,
                enabled: _statusEh('emandamento'),
              ),
              SimpleButton(
                text: _salvando ? 'Salvando...' : (_statusEh('agendada') ? 'Colocar em andamento' : 'Finalizar consulta'),
                onPressed: _salvando ? null : (_statusEh('agendada') ? _iniciarConsulta : _finalizarConsulta),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Lista de consultas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            if (_consultas.isEmpty && !_carregando)
              const Text('Nenhuma consulta encontrada.')
            else
              ..._consultas.map((consulta) {
                final pet = _nomePet(consulta['petId'] ?? consulta['PetId']);
                final consultaData = consulta['dateTime'] ?? consulta['dataConsulta'];
                return SimpleCard(
                  child: Text('Pet: $pet\n${_formatarData(consultaData)}\nStatus: ${consulta['status'] ?? '-'}'),
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorVet(abaAtiva: 0),
    );
  }
}
