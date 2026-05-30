import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/order_tracking.dart';

class OrderService {
  static const String baseUrl = 'http://10.253.128.201:8000/api';

  static Future<OrderTracking> getTracking(int orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/tracking');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return OrderTracking.fromJson(result['data']);
    } else {
      throw Exception('Gagal mengambil data tracking order');
    }
  }

  static Future<int> createOrder({
    required int userId,
    required int workshopId,
    required int mechanicId,
    required String problem,
    required double userLat,
    required double userLng,
  }) async {
    final url = Uri.parse('$baseUrl/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'workshop_id': workshopId,
        'mechanic_id': mechanicId,
        'problem': problem,
        'user_lat': userLat,
        'user_lng': userLng,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return int.parse(result['data']['id'].toString());
    } else {
      throw Exception(
        'Gagal membuat order: ${response.statusCode} ${response.body}',
      );
    }
  }
}
