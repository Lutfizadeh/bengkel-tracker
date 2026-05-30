import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_list_page.dart';
import 'home_page.dart';
import 'service_page.dart';
import 'tracking_page.dart';
import 'invoice_page.dart';
import 'rating_page.dart';
import 'profil_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryStatus? selectedStatus;

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (_) => false,
    );
  }

  List<_HistoryData> get histories => [
    const _HistoryData(
      orderId: 1,
      asset: AppAssets.slamet,
      title: 'Bengkel Pak Slamet',
      service: 'Mogok / Mesin',
      detail: 'Biaya panggilan + servis offline',
      date: '22 Apr 2026 · 09:45',
      callFee: 'Rp 25.000',
      finalPrice: 'Rp 100.000',
      status: HistoryStatus.done,
      isRated: false,
    ),
    const _HistoryData(
      orderId: 2,
      asset: AppAssets.karya,
      title: 'Auto Karya Motor',
      service: 'Ganti Ban + Tambal',
      detail: 'Biaya panggilan + servis offline',
      date: '14 Apr 2026 · 14:20',
      callFee: 'Rp 25.000',
      finalPrice: 'Rp 75.000',
      status: HistoryStatus.done,
      isRated: true,
    ),
    const _HistoryData(
      orderId: 3,
      asset: AppAssets.lainnya,
      title: 'Setia Motor',
      service: 'Aki Drop + Kabel',
      detail: 'Mekanik sedang menangani kendaraan',
      date: '22 Apr 2026 · 10:15',
      callFee: 'Rp 25.000',
      finalPrice: '-',
      status: HistoryStatus.process,
      isRated: false,
    ),
    const _HistoryData(
      orderId: 4,
      asset: '',
      title: 'Novi Garage',
      service: 'Tune Up + Karburator',
      detail: 'Biaya panggilan + servis offline',
      date: '10 Apr 2026 · 13:00',
      callFee: 'Rp 25.000',
      finalPrice: 'Rp 65.000',
      status: HistoryStatus.done,
      isRated: false,
      garage: true,
    ),
    const _HistoryData(
      orderId: 5,
      asset: AppAssets.ban,
      title: 'Bengkel Jaya Motor',
      service: 'Ban Bocor',
      detail: 'Pesanan dibatalkan oleh pengguna',
      date: '09 Apr 2026 · 11:30',
      callFee: 'Rp 25.000',
      finalPrice: '-',
      status: HistoryStatus.canceled,
      isRated: false,
    ),
  ];

  List<_HistoryData> get filteredHistories {
    if (selectedStatus == null) {
      return histories;
    }

    return histories.where((item) => item.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _Tabs(
                      selectedStatus: selectedStatus,
                      onChanged: (status) {
                        setState(() {
                          selectedStatus = status;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    if (filteredHistories.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Tidak ada history pada filter ini.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredHistories.map((item) {
                        return _HistoryCard(
                          orderId: item.orderId,
                          asset: item.asset,
                          title: item.title,
                          service: item.service,
                          detail: item.detail,
                          date: item.date,
                          callFee: item.callFee,
                          finalPrice: item.finalPrice,
                          status: item.status,
                          isRated: item.isRated,
                          garage: item.garage,
                        );
                      }),

                    _buildMonthlySummary(),
                  ],
                ),
              ),
            ),

            BottomNavbar(
              activeIndex: 1,
              onCenterTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ServicePage()));
              },
              onHomeTap: () => _goHome(context),
              onHistoryTap: () {},
              onChatTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ChatListPage()),
                );
              },
              onProfileTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 118,
      color: AppColors.navy,
      child: Stack(
        children: [
          const Positioned(
            right: -18,
            top: -24,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: AppColors.blueNavy,
            ),
          ),
          const Positioned(
            left: 19,
            top: 16,
            child: Text(
              '19:22',
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
          ),
          Positioned(
            left: 18,
            top: 45,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _goHome(context),
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
                  style: TextStyle(color: AppColors.gray, fontSize: 13),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 19,
            bottom: 14,
            child: Text(
              'History Order',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontFamily: 'Syne',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary() {
    return Container(
      height: 66,
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total pengeluaran bulan ini',
                  style: TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                SizedBox(height: 4),
                Text(
                  '4 transaksi · termasuk biaya servis offline',
                  style: TextStyle(fontSize: 10.5, color: AppColors.gray),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Rp 420.000',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.paleOrange,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'Dari input admin',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selectedStatus, required this.onChanged});

  final HistoryStatus? selectedStatus;
  final ValueChanged<HistoryStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabItem(label: 'Semua', status: null),
      _TabItem(label: 'Selesai', status: HistoryStatus.done),
      _TabItem(label: 'Proses', status: HistoryStatus.process),
      _TabItem(label: 'Batal', status: HistoryStatus.canceled),
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
        children:
            tabs.map((tab) {
              final active = selectedStatus == tab.status;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(tab.status),
                  child: Container(
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: active ? AppColors.white : AppColors.darkGray,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w400,
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

class _TabItem {
  const _TabItem({required this.label, required this.status});

  final String label;
  final HistoryStatus? status;
}

enum HistoryStatus { done, process, canceled }

class _HistoryData {
  const _HistoryData({
    required this.orderId,
    required this.asset,
    required this.title,
    required this.service,
    required this.detail,
    required this.date,
    required this.callFee,
    required this.finalPrice,
    required this.status,
    required this.isRated,
    this.garage = false,
  });

  final int orderId;
  final String asset;
  final String title;
  final String service;
  final String detail;
  final String date;
  final String callFee;
  final String finalPrice;
  final HistoryStatus status;
  final bool isRated;
  final bool garage;
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.orderId,
    required this.asset,
    required this.title,
    required this.service,
    required this.detail,
    required this.date,
    required this.callFee,
    required this.finalPrice,
    required this.status,
    required this.isRated,
    this.garage = false,
  });

  final int orderId;
  final String asset;
  final String title;
  final String service;
  final String detail;
  final String date;
  final String callFee;
  final String finalPrice;
  final HistoryStatus status;
  final bool isRated;
  final bool garage;

  bool get isProcess => status == HistoryStatus.process;
  bool get isDone => status == HistoryStatus.done;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          if (isProcess)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
                child: SizedBox(width: 5),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _Status(status: status),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            detail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1, color: AppColors.warmBorder),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ),
                              Text(
                                isDone ? finalPrice : callFee,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (isProcess) _buildProcessActions(context),
                if (isDone) _buildDoneActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: garage ? AppColors.paleOrange : AppColors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child:
            garage
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
    );
  }

  Widget _buildProcessActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SmallActionButton(
            text: 'Lihat Tracking',
            filled: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TrackingPage(orderId: orderId),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SmallActionButton(
            text: 'Hubungi',
            filled: false,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ChatListPage()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoneActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SmallActionButton(
            text: 'Lihat Invoice',
            filled: true,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const InvoicePage()));
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SmallActionButton(
            text: isRated ? 'Sudah Rating' : 'Beri Rating',
            filled: false,
            disabled: isRated,
            onTap: () {
              if (isRated) return;

              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RatingPage()));
            },
          ),
        ),
      ],
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.text,
    required this.filled,
    required this.onTap,
    this.disabled = false,
  });

  final String text;
  final bool filled;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        disabled
            ? const Color(0xFFE5E7EB)
            : filled
            ? AppColors.navy
            : AppColors.white;

    final textColor =
        disabled
            ? AppColors.gray
            : filled
            ? AppColors.white
            : AppColors.orange;

    final borderColor =
        disabled
            ? const Color(0xFFE5E7EB)
            : filled
            ? AppColors.navy
            : AppColors.orange;

    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: disabled ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({required this.status});

  final HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final bool process = status == HistoryStatus.process;
    final bool canceled = status == HistoryStatus.canceled;

    final Color bgColor =
        canceled
            ? const Color(0xFFFFE4E6)
            : process
            ? const Color(0xFFFEF3C7)
            : AppColors.lightGreen;

    final Color dotColor =
        canceled
            ? Colors.red
            : process
            ? AppColors.yellow
            : AppColors.brightGreen;

    final Color textColor =
        canceled
            ? Colors.red
            : process
            ? AppColors.brown
            : AppColors.green;

    final String label =
        canceled
            ? 'Batal'
            : process
            ? 'Dalam Proses'
            : 'Selesai';

    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Row(
          children: [
            CircleAvatar(radius: 3.5, backgroundColor: dotColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
