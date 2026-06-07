import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Features/vet/home_veterinario_page.dart'; 
import 'package:stemma_app/Features/vet/calendario_veterinario_page.dart';

class BarraInferiorVet extends StatelessWidget {
  final int abaAtiva;

  const BarraInferiorVet({super.key, required this.abaAtiva});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = AppColors.primaryGreen;
    final Color iconColor = AppColors.iconGrey;

    return Container(
      height: 88,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: abaAtiva, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: iconColor,
        showSelectedLabels: false,   
        showUnselectedLabels: false, 
        onTap: (index) {
          if (index == 0 && abaAtiva != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeVeterinarioPage()),
            );
          } 
          else if (index == 1 && abaAtiva != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CalendarioVeterinarioPage()),
            );
          } 
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ícone do Perfil/Home do Vet
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), // Calendário do Vet
            label: '',
          ),
        ],
      ),
    );
  }
}