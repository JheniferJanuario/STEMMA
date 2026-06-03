import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';

class BarraInferiorPet extends StatelessWidget {
  const BarraInferiorPet({super.key, required int abaAtiva});

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
        selectedItemColor: iconColor,   
        unselectedItemColor: iconColor,
        showSelectedLabels: false,   
        showUnselectedLabels: false, 
        onTap: (index) {
          if (index == 0) {
            // Home
          } 
          else if (index == 1) {
            // Agenda
          } 
          else if (index == 2) {
            // Pets
          } 
          else if (index == 3) {
            // Perfil
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}