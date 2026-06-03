import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}
  
class _CalendarioPageState extends State<CalendarioPage> {
  DateTime _focusedDate = DateTime.now(); 
  DateTime _selectedDate = DateTime.now(); 
  
  final Color primaryGreen = const Color(0xFF1B4D45);
  
  final List<String> _horarios = [
    "08:00", 
    "09:00", 
    "10:00", 
    "11:00", 
    "12:00", 
    "13:00", 
    "14:00", 
    "15:00", 
    "16:00", 
    "17:00", 
    "18:00"
  ];

  static final String hoje = DateTime.now().toIso8601String().substring(0, 10);

  final List<Map<String, dynamic>> _consultasDaApi = [
    {
      "petId": "Theo - Banho e Tosa",
      "veterinarioId": "Dr. Carlos",
      "dataConsulta": "${hoje}T09:00:00.000Z" 
    },
    {
      "petId": "Luna - Vacina HJM",
      "veterinarioId": "Dra. Márcia",
      "dataConsulta": "${hoje}T11:00:00.000Z" 
    }
  ];

  final List<String> _weekdays = [
    "Seg", 
    "Ter", 
    "Qua", 
    "Qui", 
    "Sex", 
    "Sáb", 
    "Dom"];
  
  final List<String> _months = [
    "", 
    "Janeiro", 
    "Fevereiro", 
    "Março", 
    "Abril", 
    "Maio", 
    "Junho", 
    "Julho", 
    "Agosto", 
    "Setembro", 
    "Outubro", 
    "Novembro", 
    "Dezembro"
  ];

  List<DateTime> _getDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(lastDay, (index) => DateTime(date.year, date.month, index + 1));
  }

  void _nextMonth() {
    setState(() { _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1); });
  }

  void _previousMonth() {
    setState(() { _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1); });
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
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

                // --- SELETOR DE MESES ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _previousMonth,
                      child: Text("← $prevMonthName", style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          _months[safeDate.month],
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          safeDate.year.toString(),
                          style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _nextMonth,
                      child: Text("$nextMonthName →", style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- CALENDÁRIO HORIZONTAL ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 130, 
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
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
                          
                          String weekdayName = _weekdays[dayDate.weekday - 1];

                          return GestureDetector(
                            onTap: () {
                              setState(() { _selectedDate = dayDate; });
                            },
                            child: AnimatedContainer(
                              width: 70,       
                              height: 120,     
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGreen : const Color(0xFFF8F9FA),
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
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    weekdayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white70 : Colors.black54,
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
                
                // --- LISTA DE AGENDAMENTOS DO DIA ---
                const Text(
                  "Agendamentos",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 16),

                Column(
                  children: [
                    for (var hora in _horarios) ...[
                      Builder(
                        builder: (context) {
                          Map<String, dynamic>? consultaDoHorario;
                          
                          // Corre para ver se algum item do nosso "Falso Banco" bate com o dia e hora selecionados
                          for (var consulta in _consultasDaApi) {
                            DateTime dataDaConsulta = DateTime.parse(consulta['dataConsulta']);
                            
                            if (dataDaConsulta.day == _selectedDate.day &&
                                dataDaConsulta.month == _selectedDate.month &&
                                dataDaConsulta.year == _selectedDate.year) {
                              
                              String horaFormatada = "${dataDaConsulta.hour.toString().padLeft(2, '0')}:00";
                              if (horaFormatada == hora) {
                                consultaDoHorario = consulta;
                                break;
                              }
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hora fixa na esquerda
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
                                
                                // Direita: mostra o card mockado ou deixa o espaço vazio
                                Expanded(
                                  child: consultaDoHorario != null
                                      ? Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: primaryGreen, 
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${consultaDoHorario['petId']}", // Exibe o texto de teste do Pet/Serviço
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Veterinário: ${consultaDoHorario['veterinarioId']}", 
                                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(height: 50), // Linha em branco vazia
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ]
                  ],
                ),
              ], 
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 1),
    );
  }
}