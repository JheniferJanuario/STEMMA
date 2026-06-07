import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class FormularioConsulta extends StatefulWidget {
  // Data pré-selecionada no calendário (passada pela tela pai)
  final DateTime? dataSelecionada;

  const FormularioConsulta({super.key, this.dataSelecionada});

  @override
  State<FormularioConsulta> createState() => _FormularioConsultaState();
}

class _FormularioConsultaState extends State<FormularioConsulta> {
  final Color primaryGreen = AppColors.primaryGreen;

  // Listas carregadas da API
  List<dynamic> _pets = [];
  List<dynamic> _veterinarios = [];

  // Selecionados pelo usuário
  dynamic _petSelecionado;
  dynamic _vetSelecionado;
  TimeOfDay _horarioSelecionado = const TimeOfDay(hour: 9, minute: 0);

  bool _carregando = true;
  bool _enviando = false;

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
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Erro ao carregar dados: $e"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _selecionarHorario() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _horarioSelecionado = picked);
    }
  }

  Future<void> _agendar() async {
    if (_petSelecionado == null || _vetSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione um pet e um veterinário.")),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      // Monta o DateTime combinando a data selecionada no calendário + horário
      final base = widget.dataSelecionada ?? DateTime.now();
      final dataConsulta = DateTime(
        base.year,
        base.month,
        base.day,
        _horarioSelecionado.hour,
        _horarioSelecionado.minute,
      );

      await ApiService.criarConsulta(
        petId: _petSelecionado['id'].toString(),
        veterinarioId: _vetSelecionado['id'].toString(),
        dataConsulta: dataConsulta,
      );

      if (mounted) {
        Navigator.pop(context, true); // true = sucesso, tela pai vai recarregar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Consulta agendada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _enviando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Erro ao agendar: $e"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 32.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle visual do bottom sheet
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

            const Text(
              "Novo Agendamento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            if (_carregando)
              const Center(child: CircularProgressIndicator())
            else ...[
              // ── Pet ──────────────────────────────────────────────
              const Text("Pet",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    value: _petSelecionado,
                    isExpanded: true,
                    hint: const Text("Selecione o pet"),
                    items: _pets
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p['nome'] ?? p['name'] ?? p['id'].toString()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _petSelecionado = v),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Veterinário ──────────────────────────────────────
              const Text("Veterinário",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    value: _vetSelecionado,
                    isExpanded: true,
                    hint: const Text("Selecione o veterinário"),
                    items: _veterinarios
                        .map((v) => DropdownMenuItem(
                              value: v,
                              child: Text(v['nome'] ?? v['name'] ?? v['id'].toString()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _vetSelecionado = v),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Data + Horário ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Data",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.dataSelecionada != null
                                ? "${widget.dataSelecionada!.day.toString().padLeft(2, '0')}/${widget.dataSelecionada!.month.toString().padLeft(2, '0')}/${widget.dataSelecionada!.year}"
                                : "Hoje",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Horário",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _selecionarHorario,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryGreen),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: primaryGreen),
                                const SizedBox(width: 6),
                                Text(
                                  "${_horarioSelecionado.hour.toString().padLeft(2, '0')}:${_horarioSelecionado.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                      fontSize: 14, color: primaryGreen, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Botão ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _enviando ? null : _agendar,
                  child: _enviando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Agendar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}