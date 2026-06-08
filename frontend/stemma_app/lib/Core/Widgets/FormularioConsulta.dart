import 'package:flutter/material.dart';
import 'package:stemma_app/Core/Constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class FormularioConsulta extends StatefulWidget {
  final DateTime? dataSelecionada;

  const FormularioConsulta({super.key, this.dataSelecionada});

  @override
  State<FormularioConsulta> createState() => _FormularioConsultaState();
}

class _FormularioConsultaState extends State<FormularioConsulta> {
  final Color primaryGreen = AppColors.primaryGreen;

  List<dynamic> _pets = [];
  List<dynamic> _veterinarios = [];
  List<dynamic> _horariosDisponiveis = [];

  dynamic _petSelecionado;
  dynamic _vetSelecionado;
  dynamic _horarioSelecionado;

  bool _carregando = true;
  bool _carregandoHorarios = false;
  bool _enviando = false;

  DateTime get _dataBase => widget.dataSelecionada ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final results = await Future.wait([
        ApiService.listarPets(),
        ApiService.listarVeterinarios(),
      ]);

      setState(() {
        _pets = results[0];
        _veterinarios = results[1];
        if (_pets.isNotEmpty) _petSelecionado = _pets.first;
        if (_veterinarios.isNotEmpty) _vetSelecionado = _veterinarios.first;
        _carregando = false;
      });

      await _carregarHorariosDisponiveis();
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _carregarHorariosDisponiveis() async {
    if (_vetSelecionado == null) return;

    setState(() {
      _carregandoHorarios = true;
      _horariosDisponiveis = [];
      _horarioSelecionado = null;
    });

    try {
      final horarios = await ApiService.listarHorariosDisponiveis(
        veterinarioId: _vetSelecionado['id'].toString(),
        data: _dataBase,
      );

      setState(() {
        _horariosDisponiveis = horarios;
        if (_horariosDisponiveis.isNotEmpty) {
          _horarioSelecionado = _horariosDisponiveis.first;
        }
        _carregandoHorarios = false;
      });
    } catch (e) {
      setState(() => _carregandoHorarios = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar horários disponíveis: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _agendar() async {
    if (_petSelecionado == null || _vetSelecionado == null || _horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pet, veterinário e horário disponível.')),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      final dataConsulta = DateTime.parse(
        (_horarioSelecionado['inicio'] ?? _horarioSelecionado['dataInicio']).toString(),
      ).toLocal();

      await ApiService.criarConsulta(
        petId: _petSelecionado['id'].toString(),
        veterinarioId: _vetSelecionado['id'].toString(),
        dataConsulta: dataConsulta,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() => _enviando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao agendar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _nome(dynamic item) => (item?['nome'] ?? item?['name'] ?? item?['id'] ?? '-').toString();

  String _formatarData(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _formatarHorario(dynamic horario) {
    final rawInicio = horario['inicio'] ?? horario['dataInicio'];
    final rawFim = horario['fim'] ?? horario['dataFim'];
    if (rawInicio == null) return 'Horário';
    final inicio = DateTime.parse(rawInicio.toString()).toLocal();
    final fim = rawFim == null ? null : DateTime.parse(rawFim.toString()).toLocal();
    final textoInicio = '${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}';
    if (fim == null) return textoInicio;
    final textoFim = '${fim.hour.toString().padLeft(2, '0')}:${fim.minute.toString().padLeft(2, '0')}';
    return '$textoInicio - $textoFim';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text('Novo Agendamento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Data: ${_formatarData(_dataBase)}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            if (_carregando)
              const Center(child: CircularProgressIndicator())
            else ...[
              const Text('Pet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _dropdown(
                value: _petSelecionado,
                hint: 'Selecione o pet',
                items: _pets,
                label: _nome,
                onChanged: (v) => setState(() => _petSelecionado = v),
              ),
              const SizedBox(height: 16),
              const Text('Veterinário', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _dropdown(
                value: _vetSelecionado,
                hint: 'Selecione o veterinário',
                items: _veterinarios,
                label: _nome,
                onChanged: (v) async {
                  setState(() => _vetSelecionado = v);
                  await _carregarHorariosDisponiveis();
                },
              ),
              const SizedBox(height: 16),
              const Text('Horários disponíveis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              if (_carregandoHorarios)
                const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
              else if (_horariosDisponiveis.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.35)),
                  ),
                  child: const Text(
                    'Nenhum horário disponível para este veterinário nesta data. Peça para o veterinário criar a agenda do dia.',
                    style: TextStyle(fontSize: 13),
                  ),
                )
              else
                _dropdown(
                  value: _horarioSelecionado,
                  hint: 'Selecione um horário',
                  items: _horariosDisponiveis,
                  label: _formatarHorario,
                  onChanged: (v) => setState(() => _horarioSelecionado = v),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: (_enviando || _horariosDisponiveis.isEmpty) ? null : _agendar,
                  child: _enviando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Agendar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dropdown({
    required dynamic value,
    required String hint,
    required List<dynamic> items,
    required String Function(dynamic) label,
    required ValueChanged<dynamic> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(label(item)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
