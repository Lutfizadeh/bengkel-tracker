import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/mechanic.dart';
import '../models/workshop.dart';
import '../services/mechanic_service.dart';
import 'chat_detail_page.dart';
import 'service_page.dart';

class WorkshopDetailPage extends StatelessWidget {
  const WorkshopDetailPage({
    super.key,
    required this.asset,
    required this.workshop,
  });

  final String asset;
  final Workshop workshop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  children: [
                    FutureBuilder<List<Mechanic>>(
                      future: MechanicService.getMechanicsByWorkshop(
                        workshop.id,
                      ),
                      builder: (context, snapshot) {
                        final mechanics = snapshot.data ?? [];
                        final openMechanics = mechanics
                            .where((mechanic) => mechanic.isOpen)
                            .length;

                        String mechanicText = '-';

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          mechanicText = '...';
                        } else if (snapshot.hasError) {
                          mechanicText = '-';
                        } else {
                          mechanicText = openMechanics.toString();
                        }

                        return _Header(
                          asset: asset,
                          workshop: workshop,
                          mechanicText: mechanicText,
                        );
                      },
                    ),
                    const SizedBox(height: 13),
                    const _ServiceChips(),
                    const SizedBox(height: 14),
                    _HoursCard(isOpen: workshop.isOpen),
                    const SizedBox(height: 11),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Row(
                        children: const [
                          Text(
                            'Review Pelanggan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Semua',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    const _ReviewCard(
                      initial: 'B',
                      name: 'Budi Speed',
                      time: '2 hr lalu',
                      text:
                          'Pelayanan cepat & profesional, harga wajar.\nLangsung beres dalam 30 menit. Recommended!',
                    ),
                    const _ReviewCard(
                      initial: 'D',
                      name: 'Clarisa Speed',
                      time: '1 hari lalu',
                      text:
                          'Motor mogok, mekanik datang kurang dari\n10 menit. Mantap pelayanannya!',
                      orange: true,
                      rating: '4.8',
                    ),
                    const _ReviewCard(
                      initial: 'R',
                      name: 'Rizal Patung',
                      time: '3 hari lalu',
                      text: 'Harga sesuai, pengerjaan rapi. Puas!',
                      blue: true,
                      rating: '4.5',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 86,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChatDetailPage(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.orange,
                          width: 1.5,
                        ),
                        foregroundColor: AppColors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(51),
                      ),
                      child: const Text(
                        'Chat',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ServicePage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(51),
                      ),
                      child: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.asset,
    required this.workshop,
    required this.mechanicText,
  });

  final String asset;
  final Workshop workshop;
  final String mechanicText;

  @override
  Widget build(BuildContext context) {
    final String statusText = workshop.isOpen ? 'Buka' : 'Tutup';
    final Color statusBg =
        workshop.isOpen ? AppColors.lightGreen : const Color(0xFFFFE5E5);
    final Color statusColor = workshop.isOpen ? AppColors.green : AppColors.red;

    return Container(
      height: 220,
      color: AppColors.navy,
      child: Stack(
        children: [
          const Positioned(
            right: -20,
            top: -22,
            child: CircleAvatar(
              radius: 68,
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
            top: 52,
            child: GestureDetector(
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
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            top: 52,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.white15,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.share,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            top: 86,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Image.asset(asset, width: 54),
                      ),
                    ),
                    const Positioned(
                      right: -1,
                      bottom: -1,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: AppColors.blue,
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workshop.title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Syne',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        workshop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '06:00 – 21:00',
                            style: TextStyle(
                              color: AppColors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 10,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white15,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: workshop.rating, label: 'Rating'),
                  const _Divider(),
                  const _Stat(value: '128', label: 'Review'),
                  const _Divider(),
                  _Stat(value: workshop.distance, label: 'Jarak'),
                  const _Divider(),
                  _Stat(value: mechanicText, label: 'Mekanik'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 29, color: AppColors.white15);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: AppColors.white60,
          ),
        ),
      ],
    );
  }
}

class _ServiceChips extends StatelessWidget {
  const _ServiceChips();

  @override
  Widget build(BuildContext context) {
    final chips = ['Motor', 'Mobil', 'Ganti Oli', 'Ban Bocor', 'AC'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 7,
          runSpacing: 7,
          children: chips.map((c) {
            final active = c == 'Motor' || c == 'Mobil';

            return Container(
              height: 27,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: active ? AppColors.orange : AppColors.background,
                border: Border.all(
                  color: active ? AppColors.orange : AppColors.warmBorder,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  c,
                  style: TextStyle(
                    color: active ? AppColors.white : AppColors.darkGray,
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard({
    required this.isOpen,
  });

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final String statusText = isOpen ? 'Buka' : 'Tutup';
    final Color statusColor = isOpen ? AppColors.green : AppColors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 9),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jam Operasional',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Senin – Sabtu',
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                ),
                Text(
                  'Minggu',
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('06:00 – 21:00', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: TextStyle(fontSize: 12, color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.initial,
    required this.name,
    required this.time,
    required this.text,
    this.orange = false,
    this.blue = false,
    this.rating = '5.0',
  });

  final String initial;
  final String name;
  final String time;
  final String text;
  final String rating;
  final bool orange;
  final bool blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: blue
                ? AppColors.blue
                : (orange ? AppColors.orange : AppColors.navy),
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '★★★★★ $rating',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}