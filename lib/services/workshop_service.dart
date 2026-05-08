import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/workshop.dart';

class WorkshopService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Workshop>> getNearestWorkshops({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/workshops/nearest?lat=$lat&lng=$lng');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel terdekat');
    }
  }

  static Future<List<Workshop>> getAllWorkshops() async {
    final url = Uri.parse('$baseUrl/workshops');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel');
    }
  }

  static Future<List<Workshop>> getTopRatedWorkshops({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/workshops/top-rated?lat=$lat&lng=$lng');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data bengkel rating tertinggi');
    }
  }

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

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List data = result['data'];

      return data.map((item) => Workshop.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil filter bengkel');
    }
  }
}