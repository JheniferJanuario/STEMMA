// lib/core/widgets/tipo_de_usuario.dart
import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';

class TipoDeUsuario extends StatelessWidget {
  const TipoDeUsuario({
    super.key,
    required this.isVeterinario,
    required this.onChanged,
  });

  final bool isVeterinario;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Option(
          label: 'Veterinário',
          selected: isVeterinario,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 20),
        _Option(
          label: 'Tutor',
          selected: !isVeterinario,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: selected,
          activeColor: AppColors.primaryGreen,
          onChanged: (_) => onTap(),
        ),
        Text(label),
      ],
    );
  }
}