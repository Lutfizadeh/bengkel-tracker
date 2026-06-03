import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/mechanic.dart';
import '../models/vehicle.dart';
import '../services/mechanic_service.dart';
import '../services/order_service.dart';
import '../services/local_data_service.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/order_info_cards.dart';
import '../widgets/service_card.dart';
import 'vehicle_select_page.dart';
import 'history_page.dart';
import 'chat_list_page.dart';
import 'payment_page.dart';
import 'profil_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key, this.initialServiceIndex = 0});

  final int initialServiceIndex;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late int selectedServiceIndex;
  bool isLoading = false;
  bool isLocationLoading = true;
  Vehicle? selectedVehicle;

  final TextEditingController otherProblemController = TextEditingController();

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
    selectedServiceIndex = widget.initialServiceIndex;
    _loadInitialVehicle();
    _loadInitialLocation();
  }

  @override
  void dispose() {
    otherProblemController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialVehicle() async {
    selectedVehicle = await LocalDataService.getMainVehicle();
    if (mounted) setState(() {});
  }

  Future<void> _openVehiclePicker() async {
    final result = await Navigator.of(context).push<Vehicle>(
      MaterialPageRoute(builder: (_) => const VehicleSelectPage()),
    );

    if (result != null) {
      setState(() => selectedVehicle = result);
    } else {
      await _loadInitialVehicle();
    }
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

      final List<Mechanic> mechanics =
          await MechanicService.getNearestMechanics(lat: userLat, lng: userLng);

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

      final bool isOtherService = selectedService.title == 'Lainnya';
      final String otherProblem = otherProblemController.text.trim();

      if (isOtherService && otherProblem.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keterangan masalah wajib diisi.')),
        );
        return;
      }

      final String problemText =
          isOtherService ? 'Lainnya - $otherProblem' : selectedService.title;

      // 1. Buat data order ke DB PostgreSQL backend Render
      final orderId = await OrderService.createOrder(
        userId: 1,
        workshopId: mechanic.workshopId,
        mechanicId: mechanic.id,
        problem: problemText,
        userLat: userLat,
        userLng: userLng,
      );

      if (!mounted) return;

      // 2. Oper orderId ke PaymentPage internal aplikasi
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => PaymentPage(orderId: orderId)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mencari mekanik: $e')));
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
    final locationText =
        isLocationLoading
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
                padding: const EdgeInsets.only(bottom: 92),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 190,
                      color: AppColors.navy,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 44,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.chevron_left,
                                    color: AppColors.gray,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Kembali',
                                    style: TextStyle(
                                      color: AppColors.gray,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 36),
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
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: _openVehiclePicker,
                                  child: Container(
                                    height: 34,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.orange20,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: AppColors.orange,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.two_wheeler,
                                          color: AppColors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          selectedVehicle == null
                                              ? 'Pilih kendaraan'
                                              : selectedVehicle!.title,
                                          style: TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.expand_more,
                                          color: AppColors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

                                    if (services[index].title != 'Lainnya') {
                                      otherProblemController.clear();
                                    }
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 17),

                          if (services[selectedServiceIndex].title ==
                              'Lainnya') ...[
                            TextField(
                              controller: otherProblemController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Tulis keterangan masalah kendaraan...',
                                hintStyle: const TextStyle(fontSize: 12),
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          LocationCard(address: locationText),
                          const SizedBox(height: 10),
                          const PriceCard(),
                          const SizedBox(height: 7),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : _findMechanicAndCreateOrder,
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
            BottomNavbar(
              activeIndex: 2,
              onCenterTap: isLoading ? () {} : _findMechanicAndCreateOrder,
              onHomeTap: () => Navigator.of(context).maybePop(),
              onHistoryTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  ),
              onChatTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ChatListPage()),
                  ),
              onProfileTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
            ),
          ],
        ),
      ),
    );
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
