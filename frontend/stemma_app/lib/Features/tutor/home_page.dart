import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/CardContador.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Features/Login/login_page.dart';
import 'package:stemma_app/Features/tutor/calendario_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color verdeProjeto = AppColors.primaryGreen;

  String nomeUsuario = ApiService.usuarioLogadoNome ?? "Tutor";
  String petProximaConsulta = "Nenhum agendamento";
  String dataProximaConsulta = "";
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
      if (item.containsKey(chave) && item[chave] != null) {
        return item[chave].toString();
      }
    }
    return null;
  }

  String _normalizarStatus(dynamic status) {
    final s = (status ?? '')
        .toString()
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '')
        .trim();

    if (s == '1') return 'agendada';
    if (s == '2') return 'emandamento';
    if (s == '3') return 'encerrada';
    if (s == '4') return 'cancelada';
    return s;
  }

  DateTime? _dataConsulta(dynamic consulta) {
    final raw = _valor(consulta, ['dateTime', 'dataConsulta', 'DateTime', 'DataConsulta']);
    if (raw == null) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  bool _consultaNaoEncerrada(dynamic consulta) {
    final status = _normalizarStatus(_valor(consulta, ['status', 'Status']));
    return status != 'encerrada' && status != 'cancelada';
  }

  bool _consultaEncerrada(dynamic consulta) {
    final status = _normalizarStatus(_valor(consulta, ['status', 'Status']));
    return status == 'encerrada';
  }

  bool _ehFuturaOuHoje(dynamic consulta) {
    final data = _dataConsulta(consulta);
    if (data == null) return true;
    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    return !data.isBefore(inicioHoje);
  }

  Future<void> _buscarDadosDaApi() async {
    if (mounted) setState(() => carregando = true);

    try {
      final results = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarConsultasEncerradas(),
        ApiService.listarPets(),
      ]);

      final todasConsultas = List<dynamic>.from(results[0]);
      final encerradasApi = List<dynamic>.from(results[1]);
      final todosPets = List<dynamic>.from(results[2]);
      final tutorId = ApiService.usuarioLogadoId;

      final nomesTodosPets = <String, String>{
        for (final p in todosPets)
          if (_valor(p, ['id', 'Id']) != null)
            _valor(p, ['id', 'Id'])!: (_valor(p, ['nome', 'name', 'Nome', 'Name']) ?? 'Pet'),
      };

      final petsDoTutor = todosPets.where((p) {
        final petTutorId = _valor(p, ['tutorId', 'TutorId']);
        return tutorId != null && petTutorId == tutorId;
      }).toList();

      // Se por algum motivo o tutorId não vier igual ao TutorId do pet,
      // usamos todos os pets para não esconder os agendamentos na apresentação.
      final idsPetsTutor = petsDoTutor.isNotEmpty
          ? petsDoTutor
              .map((p) => _valor(p, ['id', 'Id']))
              .whereType<String>()
              .toSet()
          : nomesTodosPets.keys.toSet();

      final consultasDoTutor = todasConsultas.where((c) {
        final petId = _valor(c, ['petId', 'PetId']);
        return petId != null && idsPetsTutor.contains(petId);
      }).toList();

      final futuras = consultasDoTutor.where((c) {
        return _consultaNaoEncerrada(c) && _ehFuturaOuHoje(c);
      }).toList()
        ..sort((a, b) {
          final da = _dataConsulta(a) ?? DateTime(2100);
          final db = _dataConsulta(b) ?? DateTime(2100);
          return da.compareTo(db);
        });

      final encerradasDoTutor = [
        ...encerradasApi.where((c) {
          final petId = _valor(c, ['petId', 'PetId']);
          return petId != null && idsPetsTutor.contains(petId);
        }),
        ...consultasDoTutor.where(_consultaEncerrada),
      ];

      String nomePet = "Nenhum agendamento";
      String dataTexto = "";

      if (futuras.isNotEmpty) {
        final proxima = futuras.first;
        final data = _dataConsulta(proxima);
        final petId = _valor(proxima, ['petId', 'PetId']);
        nomePet = "Pet: ${petId == null ? 'Pet' : (nomesTodosPets[petId] ?? _formatarGuid(petId))}";
        if (data != null) {
          dataTexto =
              "Próxima Consulta\n${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} - ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
        }
      }

      if (!mounted) return;
      setState(() {
        nomeUsuario = ApiService.usuarioLogadoNome ?? "Tutor";
        qtdFuturos = futuras.length;
        qtdEncerrados = encerradasDoTutor.length;
        petProximaConsulta = nomePet;
        dataProximaConsulta = dataTexto;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao carregar dados: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatarGuid(String id) => id.length > 8 ? '${id.substring(0, 8)}...' : id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _buscarDadosDaApi,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/Loggo.png',
                        width: 150,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      IconButton(
                        tooltip: 'Sair',
                        icon: Icon(Icons.logout, color: verdeProjeto, size: 28),
                        onPressed: _sair,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Olá, $nomeUsuario !",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.pets, color: verdeProjeto, size: 24),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Aqui está o resumo dos seus atendimentos.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: verdeProjeto,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Prontuários Cadastrados",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Clínica Stemma",
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.shield_outlined,
                              color: Colors.white, size: 18),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: verdeProjeto,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: carregando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: Colors.white, size: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      petProximaConsulta,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    if (dataProximaConsulta.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        dataProximaConsulta,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: verdeProjeto,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CalendarioPage()),
                                  );
                                  if (mounted) _buscarDadosDaApi();
                                },
                                child: const Text("Ver agenda",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    "Visão de Agendamentos",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 16),

                  carregando
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              child: CardContador(
                                numero: qtdFuturos.toString(),
                                titulo: "Futuros",
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CardContador(
                                numero: qtdEncerrados.toString(),
                                titulo: "Encerrados",
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 0),
    );
  }
}
