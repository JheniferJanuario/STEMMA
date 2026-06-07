import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/FormularioConsulta.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  final Color primaryGreen = AppColors.primaryGreen;

  List<dynamic> _consultasBanco = [];
  bool _isLoading = true;

  final List<String> _horarios = [
    "08:00", "09:00", "10:00", "11:00", "12:00",
    "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
  ];

  final List<String> _weekdays = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];
  final List<String> _months = [
    "", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
    "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
  ];

  @override
  void initState() {
    super.initState();
    _buscarConsultas();
  }

  Future<void> _buscarConsultas() async {
    setState(() => _isLoading = true);
    try {
      final lista = await ApiService.listarConsultas();
      setState(() {
        _consultasBanco = lista;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Não foi possível conectar à API: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(
        lastDay, (index) => DateTime(date.year, date.month, index + 1));
  }

  void _nextMonth() => setState(() {
        _focusedDate =
            DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
      });

  void _previousMonth() => setState(() {
        _focusedDate =
            DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
      });

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => FormularioConsulta(dataSelecionada: _selectedDate),
    ).then((sucesso) {
      // Recarrega a lista se o formulário retornou sucesso
      if (sucesso == true) _buscarConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeDate = _focusedDate;
    final daysInMonth = _getDaysInMonth(safeDate);

    final prevMonthDate = DateTime(safeDate.year, safeDate.month - 1, 1);
    final nextMonthDate = DateTime(safeDate.year, safeDate.month + 1, 1);
    final prevMonthName = _months[prevMonthDate.month].substring(0, 3);
    final nextMonthName = _months[nextMonthDate.month].substring(0, 3);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _buscarConsultas,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              size: 16, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Image.asset(
                        'assets/loggo.png',
                        width: 172,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Navegação de mês
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _previousMonth,
                        child: Text("← $prevMonthName",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16)),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            _months[safeDate.month],
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            safeDate.year.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: primaryGreen,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _nextMonth,
                        child: Text("$nextMonthName →",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Strip de dias
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 130,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse
                          },
                        ),
                        child: ListView.builder(
                          key: ValueKey(safeDate),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: daysInMonth.length,
                          itemBuilder: (context, index) {
                            final dayDate = daysInMonth[index];
                            bool isSelected = dayDate.day == _selectedDate.day &&
                                dayDate.month == _selectedDate.month &&
                                dayDate.year == _selectedDate.year;
                            String weekdayName =
                                _weekdays[dayDate.weekday - 1];

                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedDate = dayDate),
                              child: AnimatedContainer(
                                width: 70,
                                height: 120,
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryGreen
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(43),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dayDate.day.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      weekdayName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Agendamentos",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: _abrirFormulario,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.add,
                            color: primaryGreen,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Grade de horários
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            for (var hora in _horarios) ...[
                              Builder(
                                builder: (context) {
                                  Map<String, dynamic>? itemAgendado;

                                  for (var consulta in _consultasBanco) {
                                    // A API retorna "dateTime" (campo do ConsultationResponse)
                                    final rawData = consulta['dateTime'] ??
                                        consulta['dataConsulta'];
                                    if (rawData == null) continue;

                                    DateTime dataItem =
                                        DateTime.parse(rawData.toString())
                                            .toLocal();

                                    if (dataItem.day == _selectedDate.day &&
                                        dataItem.month ==
                                            _selectedDate.month &&
                                        dataItem.year == _selectedDate.year) {
                                      String agendaHora =
                                          "${dataItem.hour.toString().padLeft(2, '0')}:00";
                                      if (agendaHora == hora) {
                                        itemAgendado = Map<String, dynamic>.from(consulta);
                                        break;
                                      }
                                    }
                                  }

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            hora,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: itemAgendado != null
                                              ? Container(
                                                  padding: const EdgeInsets.all(14),
                                                  decoration: BoxDecoration(
                                                    color: primaryGreen,
                                                    borderRadius:
                                                        BorderRadius.circular(16),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Pet: ${_formatarGuid(itemAgendado['petId'])}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "Vet: ${_formatarGuid(itemAgendado['veterinarianId'] ?? itemAgendado['veterinarioId'])}",
                                                        style: const TextStyle(
                                                            color: Colors.white70,
                                                            fontSize: 11),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white24,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          itemAgendado['status'] ?? 'Agendado',
                                                          style: const TextStyle(color: Colors.white, fontSize: 10),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(height: 50),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ]
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 1),
    );
  }
}