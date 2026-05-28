import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/vehicle.dart';
import '../services/local_data_service.dart';
import 'vehicle_form_page.dart';

class VehicleSelectPage extends StatefulWidget {
  const VehicleSelectPage({super.key});

  @override
  State<VehicleSelectPage> createState() => _VehicleSelectPageState();
}

class _VehicleSelectPageState extends State<VehicleSelectPage> {
  List<Vehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    vehicles = await LocalDataService.getVehicles();
    if (mounted) setState(() {});
  }

  Future<void> _choose(Vehicle vehicle) async {
    await LocalDataService.setMainVehicle(vehicle.id);
    if (mounted) Navigator.pop(context, vehicle);
  }

  Future<void> _openForm([Vehicle? vehicle]) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleFormPage(vehicle: vehicle)));
    _load();
  }

  Future<void> _deleteVehicle(Vehicle vehicle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1EE),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD4CC)),
              ),
              child: const Icon(Icons.close, color: AppColors.orange, size: 24),
            ),
            const SizedBox(height: 14),
            const Text(
              'Hapus kendaraan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
          ],
        ),
        content: Text(
          'Anda yakin ingin menghapus kendaraan ini?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13.5, color: AppColors.gray, height: 1.35),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.gray,
                      backgroundColor: const Color(0xFFF5F6F8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await LocalDataService.deleteVehicle(vehicle.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final mainVehicle = _mainVehicle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 148),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('KENDARAAN UTAMA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray)),
                const SizedBox(height: 8),
                if (vehicles.isEmpty) _emptyCard(),
                ...vehicles.where((vehicle) => vehicle.isMain).map(_vehicleCard),
                const SizedBox(height: 14),
                const Text('KENDARAAN LAINNYA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray)),
                const SizedBox(height: 8),
                ...vehicles.where((vehicle) => !vehicle.isMain).map(_vehicleCard),
                const SizedBox(height: 10),
                _addVehicleCard(),
              ]),
            ),
          ),
          _selectionFooter(mainVehicle),
        ]),
      ),
    );
  }

  Vehicle? get _mainVehicle {
    if (vehicles.isEmpty) return null;
    return vehicles.firstWhere((vehicle) => vehicle.isMain, orElse: () => vehicles.first);
  }

  Widget _header() => Container(
        height: 130,
        width: double.infinity,
        color: AppColors.navy,
        child: Stack(children: [
          const Positioned(right: -44, top: -66, child: CircleAvatar(radius: 94, backgroundColor: Color(0x333B82F6))),
          Positioned(left: 18, top: 42, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chevron_left, color: Colors.white, size: 27)))),
          const Positioned(top: 49, left: 0, right: 0, child: Center(child: Text('Pilih Kendaraan', style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)))),
        ]),
      );

  Widget _emptyCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.warmBorder)),
        child: const Text('Belum ada kendaraan. Tambahkan kendaraan terlebih dahulu.', style: TextStyle(color: AppColors.gray, fontSize: 13)),
      );

  Widget _selectionFooter(Vehicle? mainVehicle) => Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: Color(0xFFF1EDE7))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.orange12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.info, size: 16, color: AppColors.orange),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kendaraan Utama otomatis dipilih saat order. Gantikan kapan saja sebelum konfirmasi order.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.darkGray, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: mainVehicle == null ? null : () => Navigator.pop(context, mainVehicle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.gray,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  mainVehicle == null ? 'Tambah Kendaraan Terlebih Dahulu' : 'Gunakan ${mainVehicle.title} (Utama)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _addVehicleCard() => GestureDetector(
        onTap: () => _openForm(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.warmBorder),
            boxShadow: appShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.orange12, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.add, color: AppColors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambah Kendaraan Baru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.orange)),
                    SizedBox(height: 2),
                    Text('Motor, Mobil, atau Truk', style: TextStyle(fontSize: 11, color: AppColors.gray)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.orange, size: 24),
            ],
          ),
        ),
      );

  Widget _vehicleCard(Vehicle vehicle) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: vehicle.isMain ? AppColors.orange : AppColors.warmBorder, width: vehicle.isMain ? 1.8 : 1),
          boxShadow: appShadow,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _choose(vehicle),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vehicle.isMain)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Utama',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: vehicle.isMain ? const Color(0xFFFFF0EA) : const Color(0xFFF1F5FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.asset(
                              _vehicleAsset(vehicle.type),
                              width: 48,
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            vehicle.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.year} • ${vehicle.color} • ${vehicle.plate}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.gray),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vehicle.isMain ? AppColors.orange : Colors.transparent,
                        border: Border.all(color: vehicle.isMain ? AppColors.orange : AppColors.warmBorder, width: 1.6),
                      ),
                      child: vehicle.isMain ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1EDE7)),
            SizedBox(
              height: 40,
              child: Row(
                children: vehicle.isMain
                    ? [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _openForm(vehicle),
                            child: const Text('Edit', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Container(width: 1, height: 20, color: const Color(0xFFF1EDE7)),
                        Expanded(
                          child: TextButton(
                            onPressed: () => _deleteVehicle(vehicle),
                            child: const Text('Hapus', style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]
                    : [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _openForm(vehicle),
                            child: const Text('Edit', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Container(width: 1, height: 20, color: const Color(0xFFF1EDE7)),
                        Expanded(
                          child: TextButton(
                            onPressed: () => _deleteVehicle(vehicle),
                            child: const Text('Hapus', style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Container(width: 1, height: 20, color: const Color(0xFFF1EDE7)),
                        Expanded(
                          child: TextButton(
                            onPressed: () => _choose(vehicle),
                            child: const Text('Jadikan Utama', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
      );

  IconData _vehicleIcon(String type) {
    if (type == 'Mobil') return Icons.directions_car;
    if (type == 'Truk/Bus') return Icons.local_shipping;
    return Icons.two_wheeler;
  }

  String _vehicleAsset(String type) {
    if (type == 'Mobil') return AppAssets.mobil;
    if (type == 'Truk/Bus') return AppAssets.truk;
    return AppAssets.motor;
  }
}
