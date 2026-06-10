import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';

class CalendarioWidget extends StatelessWidget {
  final DateTime mesFocado;
  final DateTime diaSelecionado;
  final List<DateTime> diasComConsulta; 
  final void Function(DateTime dia) onSelecionarDia;
  final void Function(int delta) onMudarMes;

  const CalendarioWidget({
    super.key,
    required this.mesFocado,
    required this.diaSelecionado,
    required this.diasComConsulta,
    required this.onSelecionarDia,
    required this.onMudarMes,
  });

  static const _meses = [
    '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];


  static const _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  int _diasNoMes(DateTime data) => DateTime(data.year, data.month + 1, 0).day;

  List<DateTime?> _celulasDoGrid(DateTime data) {
    final primeiroDia = DateTime(data.year, data.month, 1);
    final espacosVazios = primeiroDia.weekday - 1; 

    final lista = <DateTime?>[];
    for (var i = 0; i < espacosVazios; i++) lista.add(null);
    for (var d = 1; d <= _diasNoMes(data); d++) lista.add(DateTime(data.year, data.month, d));
    while (lista.length % 7 != 0) lista.add(null); 
    return lista;
  }

  bool _temConsulta(DateTime dia) {
    return diasComConsulta.any(
      (d) => d.day == dia.day && d.month == dia.month && d.year == dia.year,
    );
  }

  bool _estaSelecionado(DateTime dia) {
    return dia.day == diaSelecionado.day &&
        dia.month == diaSelecionado.month &&
        dia.year == diaSelecionado.year;
  }

  @override
  Widget build(BuildContext context) {
    final celulas = _celulasDoGrid(mesFocado);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => onMudarMes(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${_meses[mesFocado.month]} ${mesFocado.year}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => onMudarMes(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Row(
          children: _diasSemana
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: celulas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final dia = celulas[index];
            if (dia == null) return const SizedBox.shrink(); 
            final selecionado = _estaSelecionado(dia);
            final temPonto = _temConsulta(dia);

            return GestureDetector(
              onTap: () => onSelecionarDia(dia),
              child: Container(
                decoration: BoxDecoration(
                  color: selecionado ? AppColors.primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dia.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: selecionado ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (temPonto)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: selecionado ? Colors.white : AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}