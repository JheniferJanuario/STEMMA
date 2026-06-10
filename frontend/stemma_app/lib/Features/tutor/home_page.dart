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
  String nomeUsuario = ApiService.usuarioLogadoNome ?? 'Tutor';
  String proximaConsulta = 'Nenhum agendamento encontrado.';
  int qtdFuturos = 0;
  int qtdEncerrados = 0;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarDadosDaApi();
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

  String? _valor(dynamic item, List<String> chaves) {
    if (item is! Map) return null;
    for (final chave in chaves) {
      if (item[chave] != null) return item[chave].toString();
    }
    return null;
  }

  String _normalizarStatus(dynamic status) {
    final texto = (status ?? '').toString().toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    if (texto == '1') return 'agendada';
    if (texto == '2') return 'emandamento';
    if (texto == '3') return 'encerrada';
    if (texto == '4') return 'cancelada';
    return texto;
  }

  DateTime? _dataConsulta(dynamic consulta) {
    final raw = _valor(consulta, ['dateTime', 'dataConsulta', 'DateTime', 'DataConsulta']);
    if (raw == null) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  Future<void> _buscarDadosDaApi() async {
    setState(() => carregando = true);

    try {
      final resultados = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarConsultasEncerradas(),
        ApiService.listarPets(),
      ]);

      final consultas = List<dynamic>.from(resultados[0]);
      final consultasEncerradas = List<dynamic>.from(resultados[1]);
      final pets = List<dynamic>.from(resultados[2]);
      final tutorId = ApiService.usuarioLogadoId;

      final nomesPets = <String, String>{};
      final idsPetsTutor = <String>{};

      for (final pet in pets) {
        final petId = _valor(pet, ['id', 'Id']);
        final petTutorId = _valor(pet, ['tutorId', 'TutorId']);
        final nomePet = _valor(pet, ['nome', 'name', 'Nome', 'Name']) ?? 'Pet';

        if (petId != null) {
          nomesPets[petId] = nomePet;
          if (tutorId == null || petTutorId == tutorId) {
            idsPetsTutor.add(petId);
          }
        }
      }

      if (idsPetsTutor.isEmpty) idsPetsTutor.addAll(nomesPets.keys);

      final consultasDoTutor = consultas.where((consulta) {
        final petId = _valor(consulta, ['petId', 'PetId']);
        return petId != null && idsPetsTutor.contains(petId);
      }).toList();

      final hoje = DateTime.now();
      final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);

      final futuras = consultasDoTutor.where((consulta) {
        final status = _normalizarStatus(_valor(consulta, ['status', 'Status']));
        final data = _dataConsulta(consulta);
        final naoFinalizada = status != 'encerrada' && status != 'cancelada';
        final futuraOuHoje = data == null || !data.isBefore(inicioHoje);
        return naoFinalizada && futuraOuHoje;
      }).toList();

      futuras.sort((a, b) {
        final dataA = _dataConsulta(a) ?? DateTime(2100);
        final dataB = _dataConsulta(b) ?? DateTime(2100);
        return dataA.compareTo(dataB);
      });

      String textoProxima = 'Nenhum agendamento encontrado.';
      if (futuras.isNotEmpty) {
        final consulta = futuras.first;
        final petId = _valor(consulta, ['petId', 'PetId']);
        final data = _dataConsulta(consulta);
        final nomePet = petId == null ? 'Pet' : (nomesPets[petId] ?? _formatarGuid(petId));
        textoProxima = 'Pet: $nomePet';
        if (data != null) textoProxima = '$textoProxima\n${_formatarData(data)}';
      }

      final encerradasDoTutor = consultasEncerradas.where((consulta) {
        final petId = _valor(consulta, ['petId', 'PetId']);
        return petId != null && idsPetsTutor.contains(petId);
      }).toList();

      if (!mounted) return;
      setState(() {
        nomeUsuario = ApiService.usuarioLogadoNome ?? 'Tutor';
        qtdFuturos = futuras.length;
        qtdEncerrados = encerradasDoTutor.length;
        proximaConsulta = textoProxima;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
    }
  }

  String _formatarGuid(String id) => id.length > 8 ? '${id.substring(0, 8)}...' : id;

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year} às $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: Image.asset('assets/Loggo.png', width: 130),
        actions: [IconButton(onPressed: _sair, icon: const Icon(Icons.logout, color: AppColors.primaryGreen))],
      ),
      body: RefreshIndicator(
        onRefresh: _buscarDadosDaApi,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Olá, $nomeUsuario!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Resumo dos seus agendamentos.', style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 20),
            SimpleCard(
              child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SimpleTitle(text: 'Próxima consulta'),
                        const SizedBox(height: 10),
                        Text(proximaConsulta),
                        const SizedBox(height: 12),
                        SimpleButton(
                          text: 'Ver agenda',
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarioPage()));
                            if (mounted) _buscarDadosDaApi();
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            const SimpleTitle(text: 'Visão geral'),
            const SizedBox(height: 12),
            carregando
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(child: CardContador(numero: qtdFuturos.toString(), titulo: 'Futuros')),
                      const SizedBox(width: 12),
                      Expanded(child: CardContador(numero: qtdEncerrados.toString(), titulo: 'Encerrados')),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 0),
    );
  }
}
