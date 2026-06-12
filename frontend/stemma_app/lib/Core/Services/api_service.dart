import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://bonding-agreed-said.ngrok-free.dev';

  static Map<String, dynamic>? usuarioLogado;

  static String? get usuarioLogadoId => usuarioLogado?['id']?.toString();
  static String? get usuarioLogadoNome => usuarioLogado?['nome']?.toString();
  static String? get usuarioLogadoTipo => usuarioLogado?['tipoUsuario']?.toString();

  static Future<void> inicializarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarioLogado');
    if (raw == null || raw.isEmpty) return;
    usuarioLogado = json.decode(raw) as Map<String, dynamic>;
  }

  static Future<void> _salvarSessao(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuarioLogado', json.encode(data));
  }

  static Future<void> sair() async {
    usuarioLogado = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioLogado');
  }

  static bool get estaLogado => usuarioLogado != null;
  static bool get usuarioEhVeterinario => (usuarioLogadoTipo ?? '').toLowerCase().contains('veterinario');
  static bool get usuarioEhTutor => (usuarioLogadoTipo ?? '').toLowerCase().contains('tutor');

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      };

  static dynamic _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return null;
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Exception _erro(String acao, http.Response response) {
    final body = response.body.trim().isEmpty ? 'Sem detalhes' : utf8.decode(response.bodyBytes);
    if (response.statusCode == 401) return Exception(body.replaceAll('\"', ''));
    return Exception('$acao. Status: ${response.statusCode}. Resposta: $body');
  }

  static bool _sucesso(http.Response response) =>
      response.statusCode >= 200 && response.statusCode < 300;

  // AUTH
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Auth/login'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'senha': senha,
      }),
    );

    if (_sucesso(response)) {
      final data = _decodeResponse(response) as Map<String, dynamic>;
      usuarioLogado = data;
      await _salvarSessao(data);
      return data;
    }

    throw _erro('Erro ao fazer login', response);
  }

  // TUTORES
  static Future<dynamic> cadastrarTutor({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tutores'),
      headers: _headers,
      body: json.encode({
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'senha': senha,
      }),
    );

    if (_sucesso(response)) return _decodeResponse(response);
    throw _erro('Erro ao cadastrar tutor', response);
  }

  static Future<List<dynamic>> listarTutores() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tutores'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar tutores', response);
  }

  // VETERINÁRIOS
  static Future<dynamic> cadastrarVeterinario({
    required String nome,
    required String crmv,
    required String email,
    required String senha,
    required String especialidade,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Veterinario'),
      headers: _headers,
      body: json.encode({
        'nome': nome,
        'crmv': crmv,
        'email': email,
        'senha': senha,
        'especialidade': especialidade,
      }),
    );

    if (_sucesso(response)) return _decodeResponse(response);
    throw _erro('Erro ao cadastrar veterinário', response);
  }

  static Future<List<dynamic>> listarVeterinarios() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Veterinario'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar veterinários', response);
  }

  // PETS
  static Future<dynamic> cadastrarPet({
    required String nome,
    required String raca,
    required int idade,
    required double peso,
    required String tutorId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/pets'),
      headers: _headers,
      body: json.encode({
        'nome': nome,
        'raca': raca,
        'idade': idade,
        'peso': peso,
        'tutorId': tutorId,
      }),
    );

    if (_sucesso(response)) return _decodeResponse(response);
    throw _erro('Erro ao cadastrar pet', response);
  }

  static Future<List<dynamic>> listarPets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/pets'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar pets', response);
  }

  // CONSULTAS
  static Future<List<dynamic>> listarConsultas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Consulta'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar consultas', response);
  }

  static Future<List<dynamic>> listarConsultasEncerradas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Consulta/encerradas'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar consultas encerradas', response);
  }

  static Future<void> criarConsulta({
    required String petId,
    required String veterinarioId,
    required DateTime dataConsulta,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Consulta'),
      headers: _headers,
      body: json.encode({
        'petId': petId,
        'veterinarioId': veterinarioId,
        'dataConsulta': dataConsulta.toIso8601String(),
      }),
    );

    if (!_sucesso(response)) throw _erro('Erro ao criar consulta', response);
  }

  static Future<void> iniciarConsulta(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Consulta/$id/start'),
      headers: _headers,
    );

    if (!_sucesso(response)) throw _erro('Erro ao iniciar consulta', response);
  }

  static Future<void> finalizarConsulta(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Consulta/$id/complete'),
      headers: _headers,
    );

    if (!_sucesso(response)) throw _erro('Erro ao finalizar consulta', response);
  }

  static Future<void> adicionarProntuario({
    required String consultationId,
    required String descricao,
    String diagnostico = '',
    String tratamento = '',
    String medicacao = '',
    double? peso,
  }) async {
    final texto = descricao.trim();
    final diagnosticoFinal = diagnostico.trim().isEmpty ? texto : diagnostico.trim();

    final response = await http.post(
      Uri.parse('$baseUrl/api/Consulta/medical-record'),
      headers: _headers,
      body: json.encode({
        'consultationId': consultationId,
        'description': texto,
        'diagnostico': diagnosticoFinal,
        'tratamento': tratamento.trim(),
        'medicacao': medicacao.trim(),
        if (peso != null) 'peso': peso,
      }),
    );

    if (!_sucesso(response)) throw _erro('Erro ao salvar prontuário', response);
  }


  // DISPONIBILIDADE
  static Future<void> criarAgendaDisponibilidade({
    required String veterinarioId,
    required DateTime data,
    String horaInicio = '08:00:00',
    String horaFim = '18:00:00',
    int duracaoMinutos = 60,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Disponibilidade/agenda'),
      headers: _headers,
      body: json.encode({
        'veterinarioId': veterinarioId,
        'data': data.toIso8601String(),
        'horaInicio': horaInicio,
        'horaFim': horaFim,
        'duracaoMinutos': duracaoMinutos,
      }),
    );

    if (!_sucesso(response)) throw _erro('Erro ao criar agenda de disponibilidade', response);
  }

  static Future<List<dynamic>> listarHorariosDisponiveis({
    required String veterinarioId,
    required DateTime data,
  }) async {
    final dia = DateTime(data.year, data.month, data.day);
    final uri = Uri.parse('$baseUrl/api/Disponibilidade/horarios-disponiveis')
        .replace(queryParameters: {
      'veterinarioId': veterinarioId,
      'data': dia.toIso8601String(),
    });

    final response = await http.get(uri, headers: _headers);

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar horários disponíveis', response);
  }

  static Future<List<dynamic>> listarHistoricoConsultasPorPet(String petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Consulta/historico-pet/$petId'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar histórico de consultas do pet', response);
  }

  // PRONTUÁRIOS
  static Future<dynamic> buscarProntuarioPorConsulta(String consultaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/prontuarios/$consultaId'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response);
    throw _erro('Erro ao buscar prontuário', response);
  }

  static Future<List<dynamic>> listarProntuariosPorPet(String petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/prontuarios/pet/$petId'),
      headers: _headers,
    );

    if (_sucesso(response)) return _decodeResponse(response) as List<dynamic>;
    throw _erro('Erro ao listar prontuários do pet', response);
  }
}
