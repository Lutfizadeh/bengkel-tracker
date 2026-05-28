import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_list_page.dart';
import 'home_page.dart';
import 'service_page.dart';
import 'profile_page.dart';

enum _HistoryFilter { all, completed, process, canceled }

enum _HistoryStatus { completed, process, canceled }

class _HistoryItem {
  const _HistoryItem({
    required this.asset,
    required this.title,
    required this.service,
    required this.detail,
    required this.date,
    required this.price,
    required this.status,
    this.garage = false,
  });

  final String asset;
  final String title;
  final String service;
  final String detail;
  final String date;
  final String price;
  final _HistoryStatus status;
  final bool garage;
}

const List<_HistoryItem> _historyItems = [
  _HistoryItem(
    asset: AppAssets.slamet,
    title: 'Bengkel Pak Slamet',
    service: 'Mogok / Mesin',
    detail: 'Oli mesin + Busi NGK',
    date: '22 Apr 2026 · 09:45',
    price: 'Rp 100.000',
    status: _HistoryStatus.completed,
  ),
  _HistoryItem(
    asset: AppAssets.karya,
    title: 'Auto Karya Motor',
    service: 'Ganti Ban + Tambal',
    detail: 'Ban belakang IRC 80/90–14',
    date: '14 Apr 2026 · 14:20',
    price: 'Rp 75.000',
    status: _HistoryStatus.completed,
  ),
  _HistoryItem(
    asset: AppAssets.lainnya,
    title: 'Setia Motor',
    service: 'Aki Drop + Kabel',
    detail: 'Ganti aki + perbaikan kabel',
    date: '22 Apr 2026 · 10:15',
    price: 'Rp 180.000',
    status: _HistoryStatus.process,
  ),
  _HistoryItem(
    asset: '',
    title: 'Novi Garage',
    service: 'Tune Up + Karburator',
    detail: 'Servis karburator + stel klep',
    date: '10 Apr 2026 · 13:00',
    price: 'Rp 65.000',
    status: _HistoryStatus.completed,
    garage: true,
  ),
  _HistoryItem(
    asset: AppAssets.karya,
    title: 'Maju Jaya Motor',
    service: 'Servis Mesin',
    detail: 'Dibatalkan pelanggan sebelum pengerjaan',
    date: '08 Apr 2026 · 11:05',
    price: 'Rp 0',
    status: _HistoryStatus.canceled,
  ),
];

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  _HistoryFilter _selectedFilter = _HistoryFilter.all;

  void _goHome(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );

  int _parsePrice(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String _formatRupiah(int value) {
    final digits = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && index % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[index]);
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _historyItems.where((item) {
      switch (_selectedFilter) {
        case _HistoryFilter.all:
          return true;
        case _HistoryFilter.completed:
          return item.status == _HistoryStatus.completed;
        case _HistoryFilter.process:
          return item.status == _HistoryStatus.process;
        case _HistoryFilter.canceled:
          return item.status == _HistoryStatus.canceled;
      }
    }).toList();

    final completedItems = _historyItems.where((item) => item.status == _HistoryStatus.completed).toList();
    final completedTotal = completedItems.fold<int>(0, (sum, item) => sum + _parsePrice(item.price));
    final shouldShowTotalCard = _selectedFilter != _HistoryFilter.process && _selectedFilter != _HistoryFilter.canceled;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 120 + MediaQuery.of(context).viewPadding.bottom),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: double.infinity,
                    height: 190,
                    color: AppColors.navy,
                    child: Stack(
                      children: [
                        const Positioned(right: -12, top: -20, child: CircleAvatar(radius: 60, backgroundColor: AppColors.blueNavy)),
                        Positioned(
                          left: 18,
                          top: 44,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _goHome(context),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.chevron_left, color: AppColors.white, size: 23),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Beranda', style: TextStyle(color: AppColors.gray, fontSize: 13)),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 104,
                          child: Text(
                            'History Order',
                            style: TextStyle(color: AppColors.white, fontSize: 23, fontFamily: 'Syne', fontWeight: FontWeight.w700, height: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Tabs(
                    selectedFilter: _selectedFilter,
                    onSelected: (filter) => setState(() => _selectedFilter = filter),
                  ),
                  const SizedBox(height: 16),
                  if (visibleItems.isEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.warmBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Tidak ada riwayat pada filter ini.',
                        style: TextStyle(fontSize: 12, color: AppColors.gray),
                      ),
                    )
                  else
                    ...visibleItems.map((item) => _HistoryCard(
                          asset: item.asset,
                          title: item.title,
                          service: item.service,
                          detail: item.detail,
                          date: item.date,
                          price: item.price,
                          status: item.status,
                          garage: item.garage,
                        )),
                  if (shouldShowTotalCard)
                    Container(
                      height: 58,
                      margin: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.warmBorder), borderRadius: BorderRadius.circular(13)),
                      child: Row(children: [
                        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Total pengeluaran bulan ini', style: const TextStyle(fontSize: 12, color: AppColors.gray)), const SizedBox(height: 4), Text('${completedItems.length} transaksi · ${completedItems.map((item) => item.title).toSet().length} bengkel berbeda', style: const TextStyle(fontSize: 10.5, color: AppColors.gray))])),
                        Text(_formatRupiah(completedTotal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                ]),
              ),
            ),
            BottomNavbar(
              activeIndex: 1,
              onCenterTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ServicePage())),
              onHomeTap: () => _goHome(context),
              onHistoryTap: () {},
              onChatTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ChatListPage())),
                  onProfileTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage())),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selectedFilter, required this.onSelected});

  final _HistoryFilter selectedFilter;
  final ValueChanged<_HistoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = <MapEntry<_HistoryFilter, String>>[
      const MapEntry(_HistoryFilter.all, 'Semua'),
      const MapEntry(_HistoryFilter.completed, 'Selesai'),
      const MapEntry(_HistoryFilter.process, 'Proses'),
      const MapEntry(_HistoryFilter.canceled, 'Batal'),
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.map((entry) {
          final isActive = entry.key == selectedFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(entry.key),
              child: Container(
                decoration: BoxDecoration(
                  color: isActive ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isActive ? AppColors.white : AppColors.darkGray,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.asset,
    required this.title,
    required this.service,
    required this.detail,
    required this.date,
    required this.price,
    required this.status,
    this.garage = false,
  });

  final String asset;
  final String title;
  final String service;
  final String detail;
  final String date;
  final String price;
  final _HistoryStatus status;
  final bool garage;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.warmBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: garage ? AppColors.paleOrange : AppColors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: garage
                      ? const Text(
                          'GARAGE',
                          style: TextStyle(
                            color: Color(0xFFFF2965),
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Image.asset(asset, width: 42),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        _Status(status: status),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(service, style: const TextStyle(fontSize: 12, color: AppColors.darkGray)),
                    Text(detail, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.warmBorder),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(date, style: const TextStyle(fontSize: 11.5, color: AppColors.gray)),
                        const Spacer(),
                        Text(price, style: const TextStyle(fontSize: 15, color: AppColors.orange, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _Status extends StatelessWidget {
  const _Status({required this.status});

  final _HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    late final Color dotColor;
    late final Color textColor;
    late final String label;

    switch (status) {
      case _HistoryStatus.completed:
        backgroundColor = AppColors.lightGreen;
        dotColor = AppColors.brightGreen;
        textColor = AppColors.green;
        label = 'Selesai';
        break;
      case _HistoryStatus.process:
        backgroundColor = const Color(0xFFFEF3C7);
        dotColor = AppColors.yellow;
        textColor = AppColors.brown;
        label = 'Dalam Proses';
        break;
      case _HistoryStatus.canceled:
        backgroundColor = const Color(0xFFFEE2E2);
        dotColor = AppColors.red;
        textColor = AppColors.darkRed;
        label = 'Batal';
        break;
    }

    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3.5, backgroundColor: dotColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
