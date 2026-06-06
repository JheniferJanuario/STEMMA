import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';

class HomeVeterinarioPage extends StatefulWidget {
  const HomeVeterinarioPage({super.key});

  @override
  State<HomeVeterinarioPage> createState() => _HomeVeterinarioPageState();
}

class _HomeVeterinarioPageState extends State<HomeVeterinarioPage> {
  final Color verdeProjeto = AppColors.primaryGreen;
  final Color fundoClaro = AppColors.lightBackground;
  
  final TextEditingController _prontuarioController = TextEditingController();

  int agendamentosFuturos = 3;
  String nomePet = "Theo";
  String racaPet = "Golden Retriever";
  String detalhesPet = "3 anos - 28kg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoClaro,
      extendBody: true, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/loggo.png', width: 140, height: 45, fit: BoxFit.contain),
                  Icon(Icons.notifications_none, color: verdeProjeto, size: 28),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Visão de Agendamentos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40), 
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: verdeProjeto,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "$agendamentosFuturos",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text(
                      "Futuros",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), 
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: const AssetImage('assets/theo.png'), 
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nomePet, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: verdeProjeto)),
                              Text(racaPet, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                              Text(detalhesPet, style: const TextStyle(fontSize: 14, color: Colors.black45)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black87),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: -50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Prontuário:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _prontuarioController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: verdeProjeto,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: () {
                              },
                              child: const Text(
                                "Finalizar Consulta", 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    bottomNavigationBar: const BarraInferiorVet(abaAtiva: 0),    );
  }
}