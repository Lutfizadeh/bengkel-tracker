import 'dart:convert';

class Vehicle {
  final String id;
  final String type;
  final String brand;
  final String model;
  final String year;
  final String transmission;
  final String color;
  final String platePrefix;
  final String plateNumber;
  final bool isMain;

  const Vehicle({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.transmission,
    required this.color,
    required this.platePrefix,
    required this.plateNumber,
    required this.isMain,
  });

  Vehicle copyWith({
    String? id,
    String? type,
    String? brand,
    String? model,
    String? year,
    String? transmission,
    String? color,
    String? platePrefix,
    String? plateNumber,
    bool? isMain,
  }) {
    return Vehicle(
      id: id ?? this.id,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      transmission: transmission ?? this.transmission,
      color: color ?? this.color,
      platePrefix: platePrefix ?? this.platePrefix,
      plateNumber: plateNumber ?? this.plateNumber,
      isMain: isMain ?? this.isMain,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'brand': brand,
        'model': model,
        'year': year,
        'transmission': transmission,
        'color': color,
        'platePrefix': platePrefix,
        'plateNumber': plateNumber,
        'isMain': isMain,
      };

  factory Vehicle.fromMap(Map<String, dynamic> map) => Vehicle(
        id: '${map['id'] ?? ''}',
        type: '${map['type'] ?? 'Motor'}',
        brand: '${map['brand'] ?? ''}',
        model: '${map['model'] ?? ''}',
        year: '${map['year'] ?? ''}',
        transmission: '${map['transmission'] ?? ''}',
        color: '${map['color'] ?? ''}',
        platePrefix: '${map['platePrefix'] ?? 'S'}',
        plateNumber: '${map['plateNumber'] ?? ''}',
        isMain: map['isMain'] == true,
      );

  String toJson() => jsonEncode(toMap());

  factory Vehicle.fromJson(String source) => Vehicle.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String get title => '${brand.trim()} ${model.trim()}'.trim();
  String get subtitle => '$year • $transmission';
  String get plate => '${platePrefix.trim()} ${plateNumber.trim()}'.trim();
}
