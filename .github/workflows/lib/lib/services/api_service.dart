import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://votre-api.onrender.com/api/v1";

  static Future<List<dynamic>> fetchPredictions(int leagueId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/predict/$leagueId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['matchs'];
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}
