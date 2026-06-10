import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';
import 'package:stemma_app/Core/Widgets/FormularioConsulta.dart';
import 'package:stemma_app/Core/Widgets/calendario_widget.dart';
import 'package:stemma_app/Core/Widgets/card_consulta.dart';
import 'package:stemma_app/Features/Tutor/home_page.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  DateTime _mesFocado = DateTime.now();
  DateTime _diaSelecionado = DateTime.now();

  List<dynamic> _consultas = [];
  Map<String, String> _nomesPets = {};
  Map<String, String> _nomesVets = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() => _carregando = true);

    try {
      final resultados = await Future.wait([
        ApiService.listarConsultas(),
        ApiService.listarPets(),
        ApiService.listarVeterinarios(),
      ]);

      setState(() {
        _consultas = resultados[0];
        _nomesPets = {
          for (final p in resultados[1])
            p['id'].toString(): (p['nome'] ?? p['name'] ?? 'Pet').toString()
        };
        _nomesVets = {
          for (final v in resultados[2])
            v['id'].toString(): (v['nome'] ?? v['name'] ?? 'Veterinário').toString()
        };
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar dados: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }


  List<dynamic> _consultasDoDia(DateTime dia) {
    return _consultas.where((c) {
      final raw = c['dateTime'] ?? c['dataConsulta'];
      if (raw == null) return false;
      final dt = DateTime.parse(raw.toString()).toLocal();
      return dt.day == dia.day && dt.month == dia.month && dt.year == dia.year;
    }).toList()
      ..sort((a, b) {
        final dtA = DateTime.parse((a['dateTime'] ?? a['dataConsulta']).toString());
        final dtB = DateTime.parse((b['dateTime'] ?? b['dataConsulta']).toString());
        return dtA.compareTo(dtB);
      });
  }

  List<DateTime> get _diasComConsulta {
    return _consultas.map((c) {
      final raw = c['dateTime'] ?? c['dataConsulta'];
      if (raw == null) return null;
      return DateTime.parse(raw.toString()).toLocal();
    }).whereType<DateTime>().toList();
  }

  void _mudarMes(int delta) {
    setState(() {
      _mesFocado = DateTime(_mesFocado.year, _mesFocado.month + delta, 1);
      _diaSelecionado = DateTime(_mesFocado.year, _mesFocado.month, 1);
    });
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => FormularioConsulta(dataSelecionada: _diaSelecionado),
    ).then((sucesso) {
      if (sucesso == true) _buscarDados(); // recarrega depois de criar consulta
    });
  }

  String _nomePet(dynamic id) {
    if (id == null) return 'N/A';
    return _nomesPets[id.toString()] ?? _cortarId(id);
  }

  String _nomeVet(dynamic id) {
    if (id == null) return 'N/A';
    return _nomesVets[id.toString()] ?? _cortarId(id);
  }

  String _cortarId(dynamic id) {
    final s = id.toString();
    return s.length > 8 ? '${s.substring(0, 8)}...' : s;
  }

  String _formatarData(dynamic raw) {
    if (raw == null) return 'Sem data';
    final dt = DateTime.parse(raw.toString()).toLocal();
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} às $h:$min';
  }

  // ----- build -----
  @override
  Widget build(BuildContext context) {
    final consultasDoDia = _consultasDoDia(_diaSelecionado);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          ),
        ),
        title: Image.asset('assets/Loggo.png', width: 150, height: 45, fit: BoxFit.contain),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryGreen),
            onPressed: _buscarDados,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _buscarDados,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- calendário compartilhado -----
              CalendarioWidget(
                mesFocado: _mesFocado,
                diaSelecionado: _diaSelecionado,
                diasComConsulta: _diasComConsulta,
                onSelecionarDia: (dia) => setState(() => _diaSelecionado = dia),
                onMudarMes: _mudarMes,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Text(
                    'Agendamentos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _abrirFormulario,
                    icon: const Icon(Icons.add_circle, color: AppColors.primaryGreen, size: 32),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (_carregando)
                const Center(child: CircularProgressIndicator())
              else if (consultasDoDia.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Nenhum agendamento neste dia.',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ),
                )
              else
                ...consultasDoDia.map(
                  (consulta) => CardConsulta(
                    nomePet: _nomePet(consulta['petId']),
                    nomeVet: _nomeVet(consulta['veterinarianId'] ?? consulta['veterinarioId']),
                    dataFormatada: _formatarData(consulta['dateTime'] ?? consulta['dataConsulta']),
                    status: (consulta['status'] ?? 'Agendada').toString(),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorPet(abaAtiva: 1),
    );
  }
}