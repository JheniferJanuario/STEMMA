import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorVet.dart';
import 'package:stemma_app/Core/Services/api_service.dart';

class HomeVeterinarioPage extends StatefulWidget {
  const HomeVeterinarioPage({super.key});

  @override
  State<HomeVeterinarioPage> createState() => _HomeVeterinarioPageState();
}

class _HomeVeterinarioPageState extends State<HomeVeterinarioPage> {
  final Color verdeProjeto = AppColors.primaryGreen;
  final Color fundoClaro = AppColors.lightBackground;

  final TextEditingController _prontuarioController = TextEditingController();

  // Consulta em andamento que o vet vai finalizar
  dynamic _consultaAtiva;
  List<dynamic> _consultasFuturas = [];
  bool _carregando = true;
  bool _finalizando = false;

  @override
  void initState() {
    super.initState();
    _buscarConsultas();
  }

  @override
  void dispose() {
    _prontuarioController.dispose();
    super.dispose();
  }

  Future<void> _buscarConsultas() async {
    setState(() => _carregando = true);
    try {
      final lista = await ApiService.listarConsultas();

      // Separa consultas futuras e pega a mais próxima como "ativa"
      final agora = DateTime.now();
      final futuras = lista.where((c) {
        final raw = c['dateTime'] ?? c['dataConsulta'];
        if (raw == null) return false;
        return DateTime.parse(raw.toString()).isAfter(agora);
      }).toList()
        ..sort((a, b) {
          final da = DateTime.parse((a['dateTime'] ?? a['dataConsulta']).toString());
          final db = DateTime.parse((b['dateTime'] ?? b['dataConsulta']).toString());
          return da.compareTo(db);
        });

      setState(() {
        _consultasFuturas = futuras;
        _consultaAtiva = futuras.isNotEmpty ? futuras.first : null;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao carregar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _finalizarConsulta() async {
    if (_consultaAtiva == null) return;

    final descricao = _prontuarioController.text.trim();
    if (descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o prontuário antes de finalizar.")),
      );
      return;
    }

    setState(() => _finalizando = true);

    try {
      final id = _consultaAtiva['id'].toString();

      // 1) Salva o prontuário
      await ApiService.adicionarProntuario(
        consultationId: id,
        descricao: descricao,
      );

      // 2) Marca a consulta como completa
      await ApiService.finalizarConsulta(id);

      _prontuarioController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Consulta finalizada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        // Recarrega para mostrar o próximo atendimento
        await _buscarConsultas();
      }
    } catch (e) {
      setState(() => _finalizando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao finalizar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomePet = _consultaAtiva != null
        ? "Pet: ${_formatarGuid(_consultaAtiva['petId'])}"
        : "Nenhuma consulta pendente";

    return Scaffold(
      backgroundColor: fundoClaro,
      extendBody: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _buscarConsultas,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/loggo.png',
                        width: 140, height: 45, fit: BoxFit.contain),
                    Icon(Icons.notifications_none, color: verdeProjeto, size: 28),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Visão de Agendamentos",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),

                // Card contador (vem da API)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: verdeProjeto,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _carregando
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : Column(
                          children: [
                            Text(
                              "${_consultasFuturas.length}",
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              "Futuros",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),

                // Card do pet em atendimento
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(Icons.pets,
                                      size: 32, color: verdeProjeto),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(nomePet,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: verdeProjeto)),
                                      if (_consultaAtiva != null) ...[
                                        Text(
                                          _formatarData(
                                              _consultaAtiva['dateTime'] ??
                                                  _consultaAtiva['dataConsulta']),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: verdeProjeto.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            _consultaAtiva['status'] ?? 'Agendado',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: verdeProjeto,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 20, color: Colors.black87),
                              ],
                            ),
                    ),

                    // Prontuário flutuante
                    Positioned(
                      bottom: -50,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Prontuário:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14)),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _prontuarioController,
                                enabled: _consultaAtiva != null,
                                decoration: InputDecoration(
                                  hintText: _consultaAtiva == null
                                      ? "Nenhuma consulta ativa"
                                      : "Descreva o atendimento...",
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: verdeProjeto,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                onPressed: (_finalizando ||
                                        _consultaAtiva == null)
                                    ? null
                                    : _finalizarConsulta,
                                child: _finalizando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "Finalizar Consulta",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferiorVet(abaAtiva: 0),
    );
  }

  String _formatarGuid(dynamic id) {
    if (id == null) return 'N/A';
    return id.toString().length > 8
        ? id.toString().substring(0, 8) + '...'
        : id.toString();
  }

  String _formatarData(dynamic raw) {
    if (raw == null) return '';
    final dt = DateTime.parse(raw.toString()).toLocal();
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}