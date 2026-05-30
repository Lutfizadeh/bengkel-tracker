import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/workshop.dart';

class WorkshopService {
  static const String baseUrl = 'http://10.253.128.201:8000/api';

  static const String token =
      '4|wuvRaIbdFCJ1DjHwa5eaodGCNaBXpI0Nd2CuZEoM642cdd4d';

  // =========================
  // GET NEAREST WORKSHOPS
  // =========================

  static Future<List<Workshop>> getNearestWorkshops({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/workshops/nearest?lat=$lat&lng=$lng');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel terdekat');
    }
  }

  // =========================
  // GET ALL WORKSHOPS
  // =========================

  static Future<List<Workshop>> getAllWorkshops() async {
    final url = Uri.parse('$baseUrl/workshops');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel');
    }
  }

  // =========================
  // GET TOP RATED WORKSHOPS
  // =========================

  static Future<List<Workshop>> getTopRatedWorkshops({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/workshops/top-rated?lat=$lat&lng=$lng');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel rating tertinggi');
    }
  }

  // =========================
  // GET FILTERED WORKSHOPS
  // =========================

  static Future<List<Workshop>> getFilteredWorkshops({
    required double lat,
    required double lng,
    double radius = 5,
    double? minRating,
    bool? isOpen,
  }) async {
    String url = '$baseUrl/workshops/filter?lat=$lat&lng=$lng&radius=$radius';

    if (minRating != null) {
      url += '&min_rating=$minRating';
    }

    if (isOpen != null) {
      url += '&is_open=${isOpen ? 1 : 0}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil filter bengkel');
    }
  }
}
