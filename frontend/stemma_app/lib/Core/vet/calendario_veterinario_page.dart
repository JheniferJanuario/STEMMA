import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';

class CalendarioVeterinarioPage extends StatefulWidget {
  const CalendarioVeterinarioPage({super.key});

  @override
  State<CalendarioVeterinarioPage> createState() => _CalendarioVeterinarioPageState();
}

class _CalendarioVeterinarioPageState extends State<CalendarioVeterinarioPage> {
  final Color verdeProjeto = AppColors.primaryGreen;
  final Color fundoClaro = AppColors.lightBackground;
  final Color textoCinza = AppColors.textGrey;

  int diaSelecionado = 5; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoClaro,
      extendBody: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 24),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Image.asset('assets/Loggo.png', width: 130, height: 40, fit: BoxFit.contain),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("← Mai", style: TextStyle(color: textoCinza, fontSize: 14)),
                  const Text("Junho", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("Jul →", style: TextStyle(color: textoCinza, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardDia(4, "Qua"),
                  _buildCardDia(5, "Qui"),
                  _buildCardDia(6, "Sex"),
                  _buildCardDia(7, "Dom"),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Agendamentos", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Icon(Icons.calendar_today_outlined, color: verdeProjeto),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildLinhaDoTempo("9AM", "Banho e Tosa - Theo", "9:00 AM - 10:00 AM"),
                  _buildEspacoVazio("10AM"),
                  _buildEspacoVazio("10AM"),
                  _buildLinhaDoTempo("11AM", "Vacina HJM - Luna", "11:00 AM - 11:30 PM"),
                  _buildEspacoVazio("12:00PM"),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
    bottomNavigationBar: const BarraInferiorVet(abaAtiva: 1),    );
  }

  Widget _buildLinhaDoTempo(String hora, String titulo, String intervalo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text(hora, style: TextStyle(color: textoCinza, fontWeight: FontWeight.w500, fontSize: 14)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: verdeProjeto,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(intervalo, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEspacoVazio(String hora) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            child: Text(hora, style: TextStyle(color: textoCinza, fontWeight: FontWeight.w500, fontSize: 14)),
          ),
          const Expanded(child: SizedBox(height: 40)), 
        ],
      ),
    );
  }

  Widget _buildCardDia(int dia, String semana) {
    bool isSelected = dia == diaSelecionado;
    return GestureDetector(
      onTap: () => setState(() => diaSelecionado = dia),
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? verdeProjeto : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.black12),
        ),
        child: Column(
          children: [
            Text(dia.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
            const SizedBox(height: 4),
            Text(semana, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : textoCinza)),
          ],
        ),
      ),
    );
  }
}