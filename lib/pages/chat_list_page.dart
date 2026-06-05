import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_detail_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'service_page.dart';
import 'profil_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';
  ChatFilter selectedFilter = ChatFilter.all;

  void _goHome(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );

@override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

List<_ChatData> get chats => const [
      _ChatData(
        type: ChatFilter.mechanic,
        asset: AppAssets.slamet,
        name: 'Bengkel Pak Slamet',
        message: 'Siap! ETA 8 menit lagi ya.',
        sub: 'Mekanik Bengkel Pak Slamet',
        time: '19:22',
        unread: '2',
        online: true,
      ),
      _ChatData(
        type: ChatFilter.mechanic,
        asset: AppAssets.karya,
        name: 'Auto Part Motor',
        message: 'Harga ban belakang Rp 95.000...',
        sub: 'Mekanik',
        time: 'Kemarin',
        unread: '1',
      ),
      _ChatData(
        type: ChatFilter.mechanic,
        initial: 'GARAGE',
        name: 'Novi Garage',
        message: 'Anda: Oke siap Pak, makasih 🙏',
        sub: 'Order selesai',
        time: '14 Apr',
      ),
      _ChatData(
        type: ChatFilter.support,
        initial: 'BT',
        name: 'Bengkel Track Support',
        message: 'Selamat datang di BengkelTrack!',
        sub: 'CS Support',
        time: '10 Apr',
        verified: true,
      ),
    ];

List<_ChatData> get filteredChats {
  final query = searchQuery.trim().toLowerCase();

  return chats.where((chat) {
    final matchFilter =
        selectedFilter == ChatFilter.all || chat.type == selectedFilter;

    final matchSearch = query.isEmpty ||
        chat.name.toLowerCase().contains(query) ||
        chat.message.toLowerCase().contains(query) ||
        chat.sub.toLowerCase().contains(query);

    return matchFilter && matchSearch;
  }).toList();
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
                          Positioned(
                          right: 18,
                          top: 47,
                          child: _HeaderIcon(
                            icon: Icons.search,
                            onTap: () {
                              searchFocusNode.requestFocus();
                            },
                          ),
                        ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SearchBox(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      onClear: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _FilterTabs(
                      selectedFilter: selectedFilter,
                      onChanged: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                    const SizedBox(height: 13),
                    if (filteredChats.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Percakapan tidak ditemukan.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredChats.map((chat) {
                        if (chat.asset != null) {
                          return _ChatTile(
                            asset: chat.asset!,
                            name: chat.name,
                            message: chat.message,
                            sub: chat.sub,
                            time: chat.time,
                            unread: chat.unread,
                            online: chat.online,
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ChatDetailPage(),
                                  ),
                                ),
                          );
                        }

                        return _InitialTile(
                          initial: chat.initial!,
                          name: chat.name,
                          message: chat.message,
                          sub: chat.sub,
                          time: chat.time,
                          verified: chat.verified,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ChatDetailPage(),
                                ),
                              ),
                        );
                      }),
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
              onProfileTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ChatFilter { all, mechanic, support }

class _ChatTab {
  const _ChatTab({required this.label, required this.filter});

  final String label;
  final ChatFilter filter;
}

class _ChatData {
  const _ChatData({
    required this.type,
    required this.name,
    required this.message,
    required this.sub,
    required this.time,
    this.asset,
    this.initial,
    this.unread = '',
    this.online = false,
    this.verified = false,
  });

  final ChatFilter type;
  final String name;
  final String message;
  final String sub;
  final String time;
  final String? asset;
  final String? initial;
  final String unread;
  final bool online;
  final bool verified;
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.white15,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: AppColors.white80, size: 21),
    ),
  );
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.warmBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.gray, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Cari percakapan...',
                hintStyle: TextStyle(color: AppColors.gray, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, color: AppColors.gray, size: 20),
            ),
        ],
      ),
    ),
  );
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selectedFilter, required this.onChanged});

  final ChatFilter selectedFilter;
  final ValueChanged<ChatFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _ChatTab(label: 'Semua', filter: ChatFilter.all),
      _ChatTab(label: 'Mekanik', filter: ChatFilter.mechanic),
      _ChatTab(label: 'CS Support', filter: ChatFilter.support),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            tabs.map((tab) {
              final active = selectedFilter == tab.filter;

              return Expanded(
                flex: tab.label == 'CS Support' ? 14 : 11,
                child: GestureDetector(
                  onTap: () => onChanged(tab.filter),
                  child: Container(
                    height: 31,
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: active ? AppColors.navy : AppColors.warmBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: active ? AppColors.white : AppColors.darkGray,
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
  const _InitialTile({
    required this.initial,
    required this.name,
    required this.message,
    required this.sub,
    required this.time,
    required this.onTap,
    this.verified = false,
  });

  final String initial, name, message, sub, time;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 75,
      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: verified ? AppColors.navy : AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: initial.length > 2 ? 7 : 13,
                      color:
                          verified ? AppColors.orange : const Color(0xFFFF2965),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              if (verified)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.blue,
                    child: Icon(Icons.check, color: AppColors.white, size: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: AppColors.gray),
          ),
        ],
      ),
    ),
  );
}
