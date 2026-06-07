import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/CardContador.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color verdeProjeto = AppColors.primaryGreen;

  String nomeUsuario = "Tutor";
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

  Future<void> _buscarDadosDaApi() async {
    setState(() => carregando = true);
    try {
      // Busca consultas futuras (todas) e encerradas em paralelo
      final results = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarConsultasEncerradas(),
      ]);

      final futuras = results[0];
      final encerradas = results[1];

      // Filtra apenas consultas com data futura para o próximo agendamento
      final agora = DateTime.now();
      final proximas = futuras
          .where((c) {
            if (c['dateTime'] == null) return false;
            return DateTime.parse(c['dateTime']).isAfter(agora);
          })
          .toList()
        ..sort((a, b) => DateTime.parse(a['dateTime'])
            .compareTo(DateTime.parse(b['dateTime'])));

      String nomePet = "Nenhum agendamento";
      String dataTexto = "";

      if (proximas.isNotEmpty) {
        final proxima = proximas.first;
        final data = DateTime.parse(proxima['dateTime']).toLocal();
        nomePet = "Pet: ${proxima['petId'].toString().substring(0, 8)}...";
        dataTexto =
            "Próxima Consulta\n${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} - ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
      }

      setState(() {
        qtdFuturos = futuras.length;
        qtdEncerrados = encerradas.length;
        petProximaConsulta = nomePet;
        dataProximaConsulta = dataTexto;
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao carregar dados: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                        'assets/loggo.png',
                        width: 150,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_none_outlined,
                            color: verdeProjeto, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Text(
                        "Olá, $nomeUsuario !",
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142)),
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

                  // Card: prontuários / resumo clínica
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

                  // Card: próxima consulta (vem da API)
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
                                onPressed: () {},
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

                  // Contadores vindos da API
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
      bottomNavigationBar: BarraInferiorPet(abaAtiva: 0),
    );
  }
}