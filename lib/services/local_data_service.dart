import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vehicle.dart';

class LocalDataService {
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  static const _phoneKey = 'profile_phone';
  static const _photoKey = 'profile_photo';
  static const _vehiclesKey = 'vehicles_data';

  static Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim());
    await prefs.setString(_phoneKey, phone.trim());
    if (photoPath != null) await prefs.setString(_photoKey, photoPath);
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? 'Fahmii Wulidan',
      'email': prefs.getString(_emailKey) ?? 'fahmiwal3@gmail.com',
      'phone': prefs.getString(_phoneKey) ?? '+62 857-1991-6327',
      'photo': prefs.getString(_photoKey) ?? '',
    };
  }

  static Future<List<Vehicle>> getVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_vehiclesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => Vehicle.fromMap(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveVehicles(List<Vehicle> vehicles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vehiclesKey, jsonEncode(vehicles.map((e) => e.toMap()).toList()));
  }

  static Future<Vehicle?> getMainVehicle() async {
    final vehicles = await getVehicles();
    if (vehicles.isEmpty) return null;
    return vehicles.firstWhere((v) => v.isMain, orElse: () => vehicles.first);
  }

  static Future<void> upsertVehicle(Vehicle vehicle) async {
    final vehicles = await getVehicles();
    final index = vehicles.indexWhere((v) => v.id == vehicle.id);
    final bool firstVehicle = vehicles.isEmpty;

    if (index >= 0) {
      vehicles[index] = vehicle.copyWith(isMain: vehicles[index].isMain);
    } else {
      vehicles.add(vehicle.copyWith(isMain: firstVehicle));
    }

    if (!vehicles.any((v) => v.isMain) && vehicles.isNotEmpty) {
      vehicles[0] = vehicles[0].copyWith(isMain: true);
    }

    await saveVehicles(vehicles);
  }

  static Future<void> setMainVehicle(String id) async {
    final vehicles = await getVehicles();
    await saveVehicles(vehicles.map((v) => v.copyWith(isMain: v.id == id)).toList());
  }

  static Future<void> deleteVehicle(String id) async {
    final vehicles = await getVehicles();
    final updated = vehicles.where((v) => v.id != id).toList();

    if (updated.isNotEmpty && !updated.any((v) => v.isMain)) {
      updated[0] = updated[0].copyWith(isMain: true);
    }

    await saveVehicles(updated);
  }
}
