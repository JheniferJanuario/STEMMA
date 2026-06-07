import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://localhost:5215/api/Consulta";

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };


  static Future<List<dynamic>> listarConsultas() async {
    final response =
        await http.get(Uri.parse("$baseUrl/api/consulta"), headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception("Erro ao listar consultas: ${response.statusCode}");
  }

  static Future<List<dynamic>> listarConsultasEncerradas() async {
    final response = await http.get(
        Uri.parse("$baseUrl/api/consulta/encerradas"),
        headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception("Erro ao listar encerradas: ${response.statusCode}");
  }

  static Future<void> criarConsulta({
    required String petId,
    required String veterinarioId,
    required DateTime dataConsulta,
  }) async {
    final body = json.encode({
      "petId": petId,
      "veterinarioId": veterinarioId,
      "dataConsulta": dataConsulta.toUtc().toIso8601String(),
    });
    final response = await http.post(
        Uri.parse("$baseUrl/api/consulta"),
        headers: _headers,
        body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao criar consulta: ${response.body}");
    }
  }

  static Future<void> finalizarConsulta(String id) async {
    final response = await http.post(
        Uri.parse("$baseUrl/api/consulta/$id/complete"),
        headers: _headers);
    if (response.statusCode != 204) {
      throw Exception("Erro ao finalizar consulta: ${response.statusCode}");
    }
  }

  static Future<void> adicionarProntuario({
    required String consultationId,
    required String descricao,
    String diagnostico = '',
    String tratamento = '',
    String medicacao = '',
    double? peso,
  }) async {
    final body = json.encode({
      "consultationId": consultationId,
      "description": descricao,
      "diagnostico": diagnostico,
      "tratamento": tratamento,
      "medicacao": medicacao,
      if (peso != null) "peso": peso,
    });
    final response = await http.post(
        Uri.parse("$baseUrl/api/consulta/medical-record"),
        headers: _headers,
        body: body);
    if (response.statusCode != 204) {
      throw Exception("Erro ao salvar prontuário: ${response.body}");
    }
  }

  static Future<List<dynamic>> listarPets() async {
    final response =
        await http.get(Uri.parse("$baseUrl/api/pets"), headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception("Erro ao listar pets: ${response.statusCode}");
  }


  static Future<List<dynamic>> listarVeterinarios() async {
    final response = await http.get(
        Uri.parse("$baseUrl/api/veterinario"),
        headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception("Erro ao listar veterinários: ${response.statusCode}");
  }
}