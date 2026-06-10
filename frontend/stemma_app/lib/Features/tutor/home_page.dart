import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/CardContador.dart';
import 'package:stemma_app/Core/Widgets/simple_components.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Features/Tutor/calendario_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _nomeUsuario = ApiService.usuarioLogadoNome ?? 'Tutor';
  String _proximaConsulta = 'Nenhum agendamento encontrado.';
  int _qtdFuturas = 0;
  int _qtdEncerradas = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() => _carregando = true);

    try {
      final resultados = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarConsultasEncerradas(),
        ApiService.listarPets(),
      ]);

      final consultas = List<dynamic>.from(resultados[0]);
      final encerradas = List<dynamic>.from(resultados[1]);
      final pets = List<dynamic>.from(resultados[2]);
      final tutorId = ApiService.usuarioLogadoId;

      final nomesPets = <String, String>{};
      final idsPetsTutor = <String>{};

      for (final pet in pets) {
        final petId = _campo(pet, ['id', 'Id']);
        final petTutorId = _campo(pet, ['tutorId', 'TutorId']);
        final nomePet = _campo(pet, ['nome', 'name', 'Nome', 'Name']) ?? 'Pet';
        if (petId != null) {
          nomesPets[petId] = nomePet;
          if (tutorId == null || petTutorId == tutorId) idsPetsTutor.add(petId);
        }
      }
      if (idsPetsTutor.isEmpty) idsPetsTutor.addAll(nomesPets.keys);

      final consultasDoTutor = consultas.where((c) {
        final petId = _campo(c, ['petId', 'PetId']);
        return petId != null && idsPetsTutor.contains(petId);
      }).toList();

      final hoje = DateTime.now();
      final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);

      final futuras = consultasDoTutor.where((c) {
        final status = _normalizarStatus(_campo(c, ['status', 'Status']));
        final data = _parsarData(c);
        return status != 'encerrada' &&
            status != 'cancelada' &&
            (data == null || !data.isBefore(inicioHoje));
      }).toList()
        ..sort((a, b) {
          final dtA = _parsarData(a) ?? DateTime(2100);
          final dtB = _parsarData(b) ?? DateTime(2100);
          return dtA.compareTo(dtB);
        });

      String textoProxima = 'Nenhum agendamento encontrado.';
      if (futuras.isNotEmpty) {
        final proxima = futuras.first;
        final petId = _campo(proxima, ['petId', 'PetId']);
        final nomePet = petId == null ? 'Pet' : (nomesPets[petId] ?? _cortarId(petId));
        final data = _parsarData(proxima);
        textoProxima = 'Pet: $nomePet';
        if (data != null) textoProxima += '\n${_formatarData(data)}';
      }

      final encerradasDoTutor = encerradas.where((c) {
        final petId = _campo(c, ['petId', 'PetId']);
        return petId != null && idsPetsTutor.contains(petId);
      }).length;

      if (!mounted) return;
      setState(() {
        _nomeUsuario = ApiService.usuarioLogadoNome ?? 'Tutor';
        _qtdFuturas = futuras.length;
        _qtdEncerradas = encerradasDoTutor;
        _proximaConsulta = textoProxima;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
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


  String? _campo(dynamic item, List<String> chaves) {
    if (item is! Map) return null;
    for (final c in chaves) {
      if (item[c] != null) return item[c].toString();
    }
    return null;
  }

  String _normalizarStatus(dynamic status) {
    final s = (status ?? '').toString().toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    if (s == '1') return 'agendada';
    if (s == '2') return 'emandamento';
    if (s == '3') return 'encerrada';
    if (s == '4') return 'cancelada';
    return s;
  }

  DateTime? _parsarData(dynamic consulta) {
    final raw = _campo(consulta, ['dateTime', 'dataConsulta', 'DateTime', 'DataConsulta']);
    if (raw == null) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  String _cortarId(String id) => id.length > 8 ? '${id.substring(0, 8)}...' : id;

  String _formatarData(DateTime data) {
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    final h = data.hour.toString().padLeft(2, '0');
    final min = data.minute.toString().padLeft(2, '0');
    return '$d/$m/${data.year} às $h:$min';
  }

  @override
  Widget build(BuildContext context) {
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
        onRefresh: _buscarDados,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Olá, $_nomeUsuario!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Resumo dos seus agendamentos.',
              style: TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 20),

            SimpleCard(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SimpleTitle(text: 'Próxima consulta'),
                        const SizedBox(height: 10),
                        Text(_proximaConsulta),
                        const SizedBox(height: 12),
                        SimpleButton(
                          text: 'Ver agenda',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CalendarioPage()),
                            );
                            if (mounted) _buscarDados();
                          },
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 10),
            const SimpleTitle(text: 'Visão geral'),
            const SizedBox(height: 12),

            if (_carregando)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: CardContador(numero: _qtdFuturas.toString(), titulo: 'Futuros'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CardContador(numero: _qtdEncerradas.toString(), titulo: 'Encerrados'),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 0),
    );
  }
}