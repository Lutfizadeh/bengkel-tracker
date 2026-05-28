import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/mechanic.dart';
import '../models/vehicle.dart';
import '../services/mechanic_service.dart';
import '../services/local_data_service.dart';
import '../services/order_service.dart';
import '../widgets/order_info_cards.dart';
import '../widgets/service_card.dart';
import 'tracking_page.dart';
import 'vehicle_select_page.dart';
import 'vehicle_form_page.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  int selectedServiceIndex = 0;
  bool isLoading = false;
  bool isLocationLoading = true;
  Vehicle? selectedVehicle;

  double userLat = -7.1187;
  double userLng = 112.4215;

  final services = const [
    _ServiceItem(asset: AppAssets.mogok, title: 'Mogok / Mesin'),
    _ServiceItem(asset: AppAssets.ban, title: 'Ban Bocor'),
    _ServiceItem(asset: AppAssets.aki, title: 'Aki / Kelistrikan'),
    _ServiceItem(asset: AppAssets.oli, title: 'Ganti Oli'),
    _ServiceItem(asset: AppAssets.lainnya, title: 'Lainnya'),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialLocation();
    _loadVehicle();
  }


  Future<void> _loadVehicle() async {
    var vehicle = await LocalDataService.getMainVehicle();
    if (vehicle == null) {
      vehicle = const Vehicle(
        id: 'sample-main',
        type: 'Motor',
        brand: 'Honda',
        model: 'Beat Karbu',
        year: '2011',
        transmission: 'Matic',
        color: 'Hitam',
        platePrefix: 'S',
        plateNumber: '5555 TLD',
        isMain: true,
      );
    }
    if (mounted) setState(() => selectedVehicle = vehicle);
  }

  Future<void> _openVehiclePicker() async {
    final vehicles = await LocalDataService.getVehicles();
    if (!mounted) return;
    if (vehicles.isEmpty) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const VehicleFormPage()));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const VehicleSelectPage()));
    }
    await _loadVehicle();
  }

  Future<void> _loadInitialLocation() async {
    await _getUserLocation();

    if (!mounted) return;

    setState(() {
      isLocationLoading = false;
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      userLat = position.latitude;
      userLng = position.longitude;
    } catch (e) {
      debugPrint('Gagal mengambil lokasi user: $e');
    }
  }

  String _serviceTypeFromTitle(String title) {
    if (title.contains('Mogok')) return 'mogok';
    if (title.contains('Ban')) return 'ban_bocor';
    if (title.contains('Aki')) return 'aki';
    if (title.contains('Oli')) return 'ganti_oli';

    return 'lainnya';
  }

  Future<void> _findMechanicAndCreateOrder() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _getUserLocation();

      if (mounted) {
        setState(() {});
      }

      final List<Mechanic> mechanics = await MechanicService.getNearestMechanics(
        lat: userLat,
        lng: userLng,
      );

      if (!mounted) return;

      if (mechanics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada mekanik open yang tersedia.'),
          ),
        );
        return;
      }

      final mechanic = mechanics.first;
      final selectedService = services[selectedServiceIndex];
      final serviceType = _serviceTypeFromTitle(selectedService.title);

      final orderId = await OrderService.createOrder(
        userId: 1,
        workshopId: mechanic.workshopId,
        mechanicId: mechanic.id,
        problem: selectedService.title,
        userLat: userLat,
        userLng: userLng,
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TrackingPage(orderId: orderId),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mencari mekanik: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLocationLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationText = isLocationLoading
        ? 'Mengambil lokasi GPS...'
        : '${userLat.toStringAsFixed(6)}, ${userLng.toStringAsFixed(6)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 203,
                      color: AppColors.navy,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 18,
                            top: 44,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.white15,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: AppColors.white,
                                      size: 23,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Beranda',
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 47, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 44),
                                const Text(
                                  'Pilih Layanan',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Syne',
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Mekanik siap datang ke lokasi kamu',
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _selectedVehicleHeader(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(13, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              'Jenis Masalah',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 14,
                            childAspectRatio: 1.63,
                            children: List.generate(services.length, (index) {
                              final service = services[index];

                              return ServiceOption(
                                asset: service.asset,
                                title: service.title,
                                selected: selectedServiceIndex == index,
                                isVector: service.isVector,
                                onTap: () {
                                  setState(() {
                                    selectedServiceIndex = index;
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 17),
                          LocationCard(address: locationText),
                          const SizedBox(height: 10),
                          const PriceCard(),
                          const SizedBox(height: 7),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading ? null : _findMechanicAndCreateOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: AppColors.white,
                                disabledBackgroundColor: AppColors.gray,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isLoading
                                    ? 'Mencari Mekanik...'
                                    : 'Cari Mekanik Terdekat',
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedVehicleHeader() {
    final vehicle = selectedVehicle;
    if (vehicle == null) return const SizedBox(height: 42);
    return GestureDetector(
      onTap: _openVehiclePicker,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.10),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(.14)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.orange,
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: Image.asset(
                  _vehicleAsset(vehicle.type),
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  Text(vehicle.color, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gray, fontSize: 10.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

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

class _ServiceItem {
  const _ServiceItem({
    required this.asset,
    required this.title,
    this.isVector = false,
  });

  final String asset;
  final String title;
  final bool isVector;
}