import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_detail_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'service_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  void _goHome(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );

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
                padding: const EdgeInsets.only(bottom: 104),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          Container(color: AppColors.navy),
                          const Positioned(
                            right: -12,
                            top: -20,
                            child: CircleAvatar(radius: 60, backgroundColor: AppColors.blueNavy),
                          ),
                          const Positioned(
                            left: 19,
                            top: 15,
                            child: Text('19:22', style: TextStyle(color: AppColors.gray, fontSize: 12)),
                          ),
                          Positioned(
                            left: 19,
                            top: 50,
                            child: Row(
                              children: [
                                const Text('Pesan', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Syne')),
                                const SizedBox(width: 9),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.orange),
                                  child: const Center(child: Text('3', style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(right: 51, top: 47, child: _HeaderIcon(icon: Icons.edit_outlined)),
                          const Positioned(right: 18, top: 47, child: _HeaderIcon(icon: Icons.search)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _SearchBox(),
                    const SizedBox(height: 14),
                    const _FilterTabs(),
                    const SizedBox(height: 13),
                    _ChatTile(
                      asset: AppAssets.slamet,
                      name: 'Pak Slamet Riyadi',
                      message: 'Siap! ETA 8 menit lagi ya.',
                      sub: 'Bengkel Pak Slamet',
                      time: '19:22',
                      unread: '2',
                      online: true,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatDetailPage())),
                    ),
                    _ChatTile(
                      asset: AppAssets.karya,
                      name: 'Auto Karya Motor',
                      message: 'Harga ban belakang Rp 95.000...',
                      sub: '',
                      time: 'Kemarin',
                      unread: '1',
                      onTap: () {},
                    ),
                    const _InitialTile(initial: 'GARAGE', name: 'Novi Garage', message: 'Anda: Oke siap Pak, makasih 🙏', sub: 'Order selesai', time: '14 Apr'),
                    const _InitialTile(initial: 'BT', name: 'Bengkel Track Support', message: 'Selamat datang di BengkelTrack!', sub: 'Otomatis', time: '10 Apr', verified: true),
                    const SizedBox(height: 20),
                    const Center(child: Text('Tidak ada pesan lagi', style: TextStyle(fontSize: 12, color: Color(0xFFC6C1BB)))),
                    const SizedBox(height: 40),
                    const Divider(height: 1, color: AppColors.warmBorder),
                  ],
                ),
              ),
            ),
            BottomNavbar(
              activeIndex: 3,
              onCenterTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ServicePage())),
              onHomeTap: () => _goHome(context),
              onHistoryTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HistoryPage())),
              onChatTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: AppColors.white80, size: 21),
      );
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.warmBorder), borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [
            Icon(Icons.search, color: AppColors.gray, size: 24),
            SizedBox(width: 8),
            Text('Cari percakapan...', style: TextStyle(color: AppColors.gray, fontSize: 13)),
          ]),
        ),
      );
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();
  @override
  Widget build(BuildContext context) {
    final tabs = ['Semua', 'Bengkel', 'Mekanik', 'CS Support'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((t) {
          final active = t == 'Semua';
          return Expanded(
            flex: t == 'CS Support' ? 14 : 11,
            child: Container(
              height: 31,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                color: active ? AppColors.navy : AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: active ? AppColors.navy : AppColors.warmBorder),
              ),
              child: Center(
                child: Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? AppColors.white : AppColors.darkGray)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.asset, required this.name, required this.message, required this.sub, required this.time, required this.unread, this.online = false, required this.onTap});
  final String asset, name, message, sub, time, unread;
  final bool online;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 75,
          padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
          color: AppColors.background,
          child: Row(
            children: [
              Stack(children: [
                Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle), child: Center(child: Image.asset(asset, width: 42))),
                if (online) const Positioned(right: 1, bottom: 2, child: CircleAvatar(radius: 6, backgroundColor: AppColors.brightGreen)),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                if (sub.isNotEmpty) Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ])),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.orange)),
                const SizedBox(height: 9),
                Container(width: 21, height: 21, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle), child: Center(child: Text(unread, style: const TextStyle(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.w700)))),
              ]),
            ],
          ),
        ),
      );
}

class _InitialTile extends StatelessWidget {
  const _InitialTile({required this.initial, required this.name, required this.message, required this.sub, required this.time, this.verified = false});
  final String initial, name, message, sub, time;
  final bool verified;
  @override
  Widget build(BuildContext context) => Container(
        height: 75,
        padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
        child: Row(children: [
          Stack(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: verified ? AppColors.navy : AppColors.mint, shape: BoxShape.circle), child: Center(child: Text(initial, style: TextStyle(fontSize: initial.length > 2 ? 7 : 13, color: verified ? AppColors.orange : const Color(0xFFFF2965), fontWeight: FontWeight.w800)))),
            if (verified) const Positioned(right: 0, top: 0, child: CircleAvatar(radius: 8, backgroundColor: AppColors.blue, child: Icon(Icons.check, color: AppColors.white, size: 10))),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            Text(message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.gray)),
            Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
          ])),
          Text(time, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
        ]),
      );
}
