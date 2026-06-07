import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/CardContador.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color verdeProjeto = AppColors.primaryGreen;

  // --- VARIÁVEIS QUE VÃO RECEBER OS DADOS DA API ---
  String nomeUsuario = "Carregando...";
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

  void _buscarDadosDaApi() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      nomeUsuario = "Arthur";
      petProximaConsulta = "Banho e Tosa - Theo 🐶";
      dataProximaConsulta = "Próxima Consulta\n25 de Mai, 2026 - 14:00";
      qtdFuturos = 3;
      qtdEncerrados = 12;
      carregando = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                      icon: Icon(Icons.notifications_none_outlined, color: verdeProjeto, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Text(
                      "Olá, $nomeUsuario !",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                        child: Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- CARD LARGO 2: PRÓXIMA CONSULTA (Vem da API) ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: verdeProjeto,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              petProximaConsulta,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            if (dataProximaConsulta.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                dataProximaConsulta,
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        child: const Text("Ver agenda", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- SEÇÃO: VISÃO DE AGENDAMENTOS ---
                const Text(
                  "Visão de Agendamentos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 16),

                // --- GRID USANDO OS COMPONENTES DINÂMICOS (Vem da API) ---
                Row(
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
      bottomNavigationBar: BarraInferiorPet(abaAtiva: 0),
    );
  }
}