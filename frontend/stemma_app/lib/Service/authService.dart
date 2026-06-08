import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:5215';

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final erro = jsonDecode(response.body);
      throw Exception(erro['message'] ?? 'Email ou senha inválidos.');
    }
  }

  Future<void> cadastrarTutor({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tutor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'senha': senha,
      }),
    );

    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return; 
    }

    final body = response.body.trim();
    if (body.isNotEmpty) {
      try {
        final erro = jsonDecode(body);
        throw Exception(erro['message'] ?? 'Erro ao cadastrar tutor.');
      } catch (_) {
        throw Exception(
          'Erro ao cadastrar tutor. Status: ${response.statusCode}',
        );
      }
    } else {
      throw Exception(
        'Erro ao cadastrar tutor. Status: ${response.statusCode}',
      );
    }
  }

  Future<void> cadastrarVeterinario({
    required String nome,
    required String crmv,
    required String email,
    required String senha,
    required String especialidade,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/veterinario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'crmv': crmv,
        'email': email,
        'senha': senha,
        'especialidade': especialidade,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final erro = jsonDecode(response.body);
      throw Exception(erro['message'] ?? 'Erro ao cadastrar veterinário.');
    }
  }
}
