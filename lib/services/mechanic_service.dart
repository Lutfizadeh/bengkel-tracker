import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/mechanic.dart';

class MechanicService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Mechanic>> getMechanicsByWorkshop(int workshopId) async {
    final url = Uri.parse('$baseUrl/workshops/$workshopId/mechanics');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Mechanic.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data mekanik bengkel');
    }
  }

  static Future<List<Mechanic>> getNearestMechanics({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/mechanics/nearest?lat=$lat&lng=$lng');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Mechanic.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data mekanik terdekat');
    }
  }
}