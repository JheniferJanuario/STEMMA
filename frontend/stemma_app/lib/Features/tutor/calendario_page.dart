import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/FormularioConsulta.dart';
import 'package:stemma_app/Features/Tutor/home_page.dart';

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
  Map<String, String> _nomesPets = {};
  Map<String, String> _nomesVeterinarios = {};
  bool _isLoading = true;

  final List<String> _weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  final List<String> _months = ['', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];

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
      setState(() {
        _consultasBanco = results[0];
        _nomesPets = {for (final p in results[1]) p['id'].toString(): (p['nome'] ?? p['name'] ?? 'Pet').toString()};
        _nomesVeterinarios = {for (final v in results[2]) v['id'].toString(): (v['nome'] ?? v['name'] ?? 'Veterinário').toString()};
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível conectar à API: $e'), backgroundColor: Colors.red));
      }
    }
  }

  int _daysInMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

  List<DateTime?> _calendarDays(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final emptyBefore = first.weekday - 1;
    final days = <DateTime?>[];
    for (var i = 0; i < emptyBefore; i++) days.add(null);
    for (var day = 1; day <= _daysInMonth(date); day++) {
      days.add(DateTime(date.year, date.month, day));
    }
    while (days.length % 7 != 0) days.add(null);
    return days;
  }

  List<dynamic> _consultasDoDia(DateTime dia) {
    return _consultasBanco.where((consulta) {
      final rawData = consulta['dateTime'] ?? consulta['dataConsulta'];
      if (rawData == null) return false;
      final dataItem = DateTime.parse(rawData.toString()).toLocal();
      return dataItem.day == dia.day && dataItem.month == dia.month && dataItem.year == dia.year;
    }).toList()
      ..sort((a, b) => DateTime.parse((a['dateTime'] ?? a['dataConsulta']).toString()).compareTo(DateTime.parse((b['dateTime'] ?? b['dataConsulta']).toString())));
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => FormularioConsulta(dataSelecionada: _selectedDate),
    ).then((sucesso) {
      if (sucesso == true) _buscarConsultas();
    });
  }

  void _mudarMes(int delta) {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + delta, 1);
      _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final diasCalendario = _calendarDays(_focusedDate);
    final consultasDia = _consultasDoDia(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.home, color: AppColors.primaryGreen), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()))),
        title: Image.asset('assets/Loggo.png', width: 150, height: 45, fit: BoxFit.contain),
        centerTitle: true,
        actions: [IconButton(onPressed: _buscarConsultas, icon: const Icon(Icons.refresh, color: AppColors.primaryGreen))],
      ),
      body: RefreshIndicator(
        onRefresh: _buscarConsultas,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => _mudarMes(-1), icon: const Icon(Icons.chevron_left)),
                  Expanded(child: Text('${_months[_focusedDate.month]} ${_focusedDate.year}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                  IconButton(onPressed: () => _mudarMes(1), icon: const Icon(Icons.chevron_right)),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: _weekdays.map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey))))).toList()),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: diasCalendario.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  final day = diasCalendario[index];
                  if (day == null) return const SizedBox.shrink();
                  final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month && day.year == _selectedDate.year;
                  final temConsulta = _consultasDoDia(day).isNotEmpty;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _selectedDate = day),
                    child: Container(
                      decoration: BoxDecoration(color: isSelected ? primaryGreen : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black12)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(day.day.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                        if (temConsulta) Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: isSelected ? Colors.white : primaryGreen, shape: BoxShape.circle)),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Text('Agendamentos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: _abrirFormulario, icon: Icon(Icons.add_circle, color: primaryGreen, size: 34)),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (consultasDia.isEmpty)
                const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('Nenhum agendamento neste dia.', style: TextStyle(color: AppColors.textGrey))))
              else
                ...consultasDia.map(_cardConsulta),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 1),
    );
  }

  Widget _cardConsulta(dynamic consulta) {
    return Card(
      color: primaryGreen,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.white),
        title: Text('Pet: ${_nomePet(consulta['petId'])}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('${_formatarData(consulta['dateTime'] ?? consulta['dataConsulta'])}\nVet: ${_nomeVeterinario(consulta['veterinarianId'] ?? consulta['veterinarioId'])}', style: const TextStyle(color: Colors.white70)),
        trailing: Text((consulta['status'] ?? 'Agendada').toString(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  String _nomePet(dynamic id) => id == null ? 'N/A' : (_nomesPets[id.toString()] ?? _formatarGuid(id));
  String _nomeVeterinario(dynamic id) => id == null ? 'N/A' : (_nomesVeterinarios[id.toString()] ?? _formatarGuid(id));
  String _formatarGuid(dynamic id) => id.toString().length > 8 ? '${id.toString().substring(0, 8)}...' : id.toString();
  String _formatarData(dynamic raw) {
    if (raw == null) return 'Data não informada';
    final dt = DateTime.parse(raw.toString()).toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
