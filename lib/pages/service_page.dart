import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/mechanic.dart';
import '../services/mechanic_service.dart';
import '../services/order_service.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/order_info_cards.dart';
import '../widgets/service_card.dart';
import 'tracking_page.dart';
import 'history_page.dart';
import 'chat_list_page.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  int selectedServiceIndex = 0;
  bool isLoading = false;
  bool isLocationLoading = true;

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
                              child: const Text(
                                '← Kembali',
                                style: TextStyle(
                                  color: AppColors.gray,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 47),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 44),
                                Text(
                                  'Pilih Layanan',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Syne',
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Mekanik siap datang ke lokasi kamu',
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
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
            BottomNavbar(
              activeIndex: 2,
              onCenterTap: isLoading ? () {} : _findMechanicAndCreateOrder,
              onHomeTap: () => Navigator.of(context).maybePop(),
              onHistoryTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              ),
              onChatTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatListPage()),
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