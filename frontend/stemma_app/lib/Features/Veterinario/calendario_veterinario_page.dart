import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';
import 'package:stemma_app/Core/Widgets/calendario_widget.dart';
import 'package:stemma_app/Core/Widgets/card_consulta.dart';
import 'package:stemma_app/Features/Veterinario/home_veterinario_page.dart';

class CalendarioVeterinarioPage extends StatefulWidget {
  const CalendarioVeterinarioPage({super.key});

  @override
  State<CalendarioVeterinarioPage> createState() => _CalendarioVeterinarioPageState();
}

class _CalendarioVeterinarioPageState extends State<CalendarioVeterinarioPage> {
  DateTime _mesFocado = DateTime.now();
  DateTime _diaSelecionado = DateTime.now();

  List<dynamic> _consultas = [];
  Map<String, String> _nomesPets = {};
  Map<String, String> _nomesVets = {};
  bool _carregando = true;
  bool _criandoAgenda = false;

  final List<String> _horarios = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00', '18:00',
  ];

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
          SnackBar(content: Text('Erro ao carregar agenda: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _criarDisponibilidade() async {
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
        data: _diaSelecionado,
        horaInicio: '08:00:00',
        horaFim: '18:00:00',
        duracaoMinutos: 60,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disponibilidade criada para o dia.'),
            backgroundColor: Colors.green,
          ),
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
            MaterialPageRoute(builder: (_) => const HomeVeterinarioPage()),
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

              CalendarioWidget(
                mesFocado: _mesFocado,
                diaSelecionado: _diaSelecionado,
                diasComConsulta: _diasComConsulta,
                onSelecionarDia: (dia) => setState(() => _diaSelecionado = dia),
                onMudarMes: _mudarMes,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _criandoAgenda ? null : _criarDisponibilidade,
                  icon: _criandoAgenda
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.event_available),
                  label: const Text('Criar disponibilidade do dia'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Agenda do dia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (_carregando)
                const Center(child: CircularProgressIndicator())
              else
                ..._horarios.map((hora) => _linhaHorario(hora, consultasDoDia)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorVet(abaAtiva: 1),
    );
  }

  Widget _linhaHorario(String hora, List<dynamic> consultasDia) {
    final horaInt = int.parse(hora.split(':')[0]);

    dynamic consulta;
    for (final c in consultasDia) {
      final raw = c['dateTime'] ?? c['dataConsulta'];
      if (raw == null) continue;
      final dt = DateTime.parse(raw.toString()).toLocal();
      if (dt.hour == horaInt) {
        consulta = c;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 55,
            child: Text(
              hora,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: consulta != null
                ? CardConsulta(
                    nomePet: _nomePet(consulta['petId']),
                    nomeVet: _nomeVet(consulta['veterinarianId'] ?? consulta['veterinarioId']),
                    dataFormatada: _formatarData(consulta['dateTime'] ?? consulta['dataConsulta']),
                    status: (consulta['status'] ?? 'Agendada').toString(),
                  )
                : Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}