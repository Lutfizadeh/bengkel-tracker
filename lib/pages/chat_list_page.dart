import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_detail_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'service_page.dart';
import 'profile_page.dart';

enum _ChatCategory { bengkel, mekanik, csSupport }

class _ChatItem {
  const _ChatItem({
    required this.asset,
    required this.name,
    required this.message,
    required this.sub,
    required this.time,
    required this.unread,
    required this.category,
    this.online = false,
    this.verified = false,
  });

  final String asset;
  final String name;
  final String message;
  final String sub;
  final String time;
  final String unread;
  final _ChatCategory category;
  final bool online;
  final bool verified;
}

const List<_ChatItem> _chatItems = [
  _ChatItem(
    asset: AppAssets.slamet,
    name: 'Pak Slamet Riyadi',
    message: 'Siap! ETA 8 menit lagi ya.',
    sub: 'Bengkel Pak Slamet',
    time: '19:22',
    unread: '2',
    category: _ChatCategory.mekanik,
    online: true,
  ),
  _ChatItem(
    asset: AppAssets.karya,
    name: 'Auto Karya Motor',
    message: 'Harga ban belakang Rp 95.000...',
    sub: '',
    time: 'Kemarin',
    unread: '1',
    category: _ChatCategory.bengkel,
  ),
  _ChatItem(
    asset: AppAssets.lainnya,
    name: 'Novi Garage',
    message: 'Anda: Oke siap Pak, makasih 🙏',
    sub: 'Order selesai',
    time: '14 Apr',
    unread: '0',
    category: _ChatCategory.bengkel,
    verified: false,
  ),
  _ChatItem(
    asset: AppAssets.chat,
    name: 'Bengkel Track Support',
    message: 'Selamat datang di BengkelTrack!',
    sub: 'Otomatis',
    time: '10 Apr',
    unread: '0',
    category: _ChatCategory.csSupport,
    verified: true,
  ),
];

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  _ChatCategory? _selectedCategory;

  void _goHome(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );

  @override
  Widget build(BuildContext context) {
    final visibleItems = _chatItems.where((item) => _selectedCategory == null || item.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 104 + MediaQuery.of(context).viewPadding.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          Positioned(
                            left: 20,
                            top: 104,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Pesan', style: const TextStyle(color: AppColors.white, fontSize: 23, fontWeight: FontWeight.w700, fontFamily: 'Syne', height: 1)),
                                const SizedBox(width: 9),
                                Container(
                                  width: 22,
                                  height: 22,
                                  margin: const EdgeInsets.only(bottom: 2),
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.orange),
                                  child: const Center(child: Text('3', style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FilterTabs(
                      selectedCategory: _selectedCategory,
                      onSelected: (category) => setState(() => _selectedCategory = category),
                    ),
                    const SizedBox(height: 13),
                    ...visibleItems.map((item) => _ChatTile(
                          asset: item.asset,
                          name: item.name,
                          message: item.message,
                          sub: item.sub,
                          unread: item.unread,
                          online: item.online,
                          verified: item.verified,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatDetailPage(
                                title: item.name,
                                subtitle: item.sub.isEmpty ? 'Percakapan aktif' : item.sub,
                                asset: item.asset,
                              ),
                            ),
                          ),
                        )),
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
              onProfileTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage())),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selectedCategory, required this.onSelected});

  final _ChatCategory? selectedCategory;
  final ValueChanged<_ChatCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = <MapEntry<_ChatCategory?, String>>[
      const MapEntry(null, 'Semua'),
      const MapEntry(_ChatCategory.bengkel, 'Bengkel'),
      const MapEntry(_ChatCategory.mekanik, 'Mekanik'),
      const MapEntry(_ChatCategory.csSupport, 'CS Support'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((entry) {
          final active = entry.key == selectedCategory;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(entry.key),
              child: Container(
                height: 31,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  color: active ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: active ? AppColors.navy : AppColors.warmBorder),
                ),
                child: Center(
                  child: Text(entry.value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? AppColors.white : AppColors.darkGray)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.asset, required this.name, required this.message, required this.sub, required this.unread, this.online = false, this.verified = false, required this.onTap});
  final String asset, name, message, sub, unread;
  final bool online;
  final bool verified;
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
                Container(width: 48, height: 48, decoration: BoxDecoration(color: verified ? AppColors.navy : AppColors.black, shape: BoxShape.circle), child: Center(child: Image.asset(asset, width: 42))),
                if (online) const Positioned(right: 1, bottom: 2, child: CircleAvatar(radius: 6, backgroundColor: AppColors.brightGreen)),
                if (verified) const Positioned(right: 0, top: 0, child: CircleAvatar(radius: 8, backgroundColor: AppColors.blue, child: Icon(Icons.check, color: AppColors.white, size: 10))),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                if (sub.isNotEmpty) Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ])),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                if (unread != '0') Container(width: 21, height: 21, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle), child: Center(child: Text(unread, style: const TextStyle(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.w700)))),
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
