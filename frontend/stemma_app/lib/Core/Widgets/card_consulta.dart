import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';


class CardConsulta extends StatelessWidget {
  final String nomePet;
  final String nomeVet;
  final String dataFormatada;
  final String status;

  const CardConsulta({
    super.key,
    required this.nomePet,
    required this.nomeVet,
    required this.dataFormatada,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryGreen,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.event, color: Colors.white, size: 28),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet: $nomePet',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dataFormatada,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    'Vet: $nomeVet',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}