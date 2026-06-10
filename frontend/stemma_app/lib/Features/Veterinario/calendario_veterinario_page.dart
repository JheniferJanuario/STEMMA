import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Features/Veterinario/home_veterinario_page.dart';

class CalendarioVeterinarioPage extends StatefulWidget {
  const CalendarioVeterinarioPage({super.key});

  @override
  State<CalendarioVeterinarioPage> createState() => _CalendarioVeterinarioPageState();
}

class _CalendarioVeterinarioPageState extends State<CalendarioVeterinarioPage> {
  final Color verdeProjeto = AppColors.primaryGreen;
  final Color fundoClaro = AppColors.lightBackground;
  final Color textoCinza = AppColors.textGrey;

  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<dynamic> _todasConsultas = [];
  Map<String, String> _nomesPets = {};
  Map<String, String> _nomesVeterinarios = {};
  bool _isLoading = true;
  bool _criandoAgenda = false;

  final List<String> _weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  final List<String> _months = [
    '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];
  final List<String> _horarios = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'
  ];

  @override
  void initState() {
    super.initState();
    _buscarConsultas();
  }

  Future<void> _buscarConsultas() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarPets(),
        ApiService.listarVeterinarios(),
      ]);
      final consultas = results[0];
      final pets = results[1];
      final vets = results[2];
      setState(() {
        _todasConsultas = consultas;
        _nomesPets = {for (final p in pets) p['id'].toString(): (p['nome'] ?? p['name'] ?? 'Pet').toString()};
        _nomesVeterinarios = {for (final v in vets) v['id'].toString(): (v['nome'] ?? v['name'] ?? 'Veterinário').toString()};
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agenda: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _criarAgendaDoDia() async {
    final vetId = ApiService.usuarioLogadoId;
    if (vetId == null || vetId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login como veterinário para criar disponibilidade.')),
      );
      return;
    }

    setState(() => _criandoAgenda = true);
    try {
      await ApiService.criarAgendaDisponibilidade(
        veterinarioId: vetId,
        data: _selectedDate,
        horaInicio: '08:00:00',
        horaFim: '18:00:00',
        duracaoMinutos: 60,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agenda de disponibilidade criada para o dia.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar disponibilidade: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _criandoAgenda = false);
    }
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(lastDay, (i) => DateTime(date.year, date.month, i + 1));
  }

  List<dynamic> _consultasDoDia(DateTime dia) {
    return _todasConsultas.where((c) {
      final raw = c['dateTime'] ?? c['dataConsulta'];
      if (raw == null) return false;
      final dt = DateTime.parse(raw.toString()).toLocal();
      return dt.day == dia.day && dt.month == dia.month && dt.year == dia.year;
    }).toList()
      ..sort((a, b) {
        final da = DateTime.parse((a['dateTime'] ?? a['dataConsulta']).toString());
        final db = DateTime.parse((b['dateTime'] ?? b['dataConsulta']).toString());
        return da.compareTo(db);
      });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_focusedDate);
    final consultasDia = _consultasDoDia(_selectedDate);

    return Scaffold(
      backgroundColor: fundoClaro,
      extendBody: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.home, size: 24), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeVeterinarioPage()))),
                  Image.asset('assets/Loggo.png', width: 130, height: 40, fit: BoxFit.contain),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1)),
                    child: Text('← ${_months[DateTime(_focusedDate.year, _focusedDate.month - 1, 1).month].substring(0, 3)}', style: TextStyle(color: textoCinza, fontSize: 14)),
                  ),
                  Text('${_months[_focusedDate.month]} ${_focusedDate.year}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1)),
                    child: Text('${_months[DateTime(_focusedDate.year, _focusedDate.month + 1, 1).month].substring(0, 3)} →', style: TextStyle(color: textoCinza, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 110,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                  child: ListView.builder(
                    key: ValueKey(_focusedDate),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: daysInMonth.length,
                    itemBuilder: (context, index) {
                      final day = daysInMonth[index];
                      final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month && day.year == _selectedDate.year;
                      final temConsulta = _consultasDoDia(day).isNotEmpty;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = day),
                        child: Container(
                          width: 65,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? verdeProjeto : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.black12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(day.day.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                              const SizedBox(height: 4),
                              Text(_weekdays[day.weekday - 1], style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : textoCinza)),
                              if (temConsulta) ...[
                                const SizedBox(height: 4),
                                Container(width: 6, height: 6, decoration: BoxDecoration(color: isSelected ? Colors.white : verdeProjeto, shape: BoxShape.circle)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text('Agendamentos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: _buscarConsultas, icon: Icon(Icons.refresh, color: verdeProjeto)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _criandoAgenda ? null : _criarAgendaDoDia,
                  icon: _criandoAgenda ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.event_available),
                  label: const Text('Criar disponibilidade do dia'),
                  style: OutlinedButton.styleFrom(foregroundColor: verdeProjeto),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _buscarConsultas,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _horarios.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _horarios.length) return const SizedBox(height: 100);
                          return _linhaHorario(_horarios[index], consultasDia);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferiorVet(abaAtiva: 1),
    );
  }

  Widget _linhaHorario(String hora, List<dynamic> consultasDia) {
    final horaInt = int.parse(hora.split(':')[0]);
    dynamic consulta;
    for (var c in consultasDia) {
      final raw = c['dateTime'] ?? c['dataConsulta'];
      if (raw == null) continue;
      final dt = DateTime.parse(raw.toString()).toLocal();
      if (dt.hour == horaInt) {
        consulta = c;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 65, child: Text(hora, style: TextStyle(color: textoCinza, fontWeight: FontWeight.w500, fontSize: 14))),
          Expanded(
            child: consulta != null
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: verdeProjeto, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pet: ${_nomePet(consulta['petId'])}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('Vet: ${_nomeVeterinario(consulta['veterinarianId'] ?? consulta['veterinarioId'])}', style: const TextStyle(color: Colors.white70, fontSize: 11))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                              child: Text(consulta['status'] ?? 'Agendado', style: const TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  String _nomePet(dynamic id) => id == null ? 'N/A' : (_nomesPets[id.toString()] ?? _formatarGuid(id));
  String _nomeVeterinario(dynamic id) => id == null ? 'N/A' : (_nomesVeterinarios[id.toString()] ?? _formatarGuid(id));
  String _formatarGuid(dynamic id) => id.toString().length > 8 ? '${id.toString().substring(0, 8)}...' : id.toString();
}
