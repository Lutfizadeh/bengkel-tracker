import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'mechanic_chat_page.dart';
import 'mechanic_tracking_page.dart';
import 'mechanic_profile_page.dart';

class MechanicChatListPage extends StatefulWidget {
  const MechanicChatListPage({super.key});

  @override
  State<MechanicChatListPage> createState() => _MechanicChatListPageState();
}

class _MechanicChatListPageState extends State<MechanicChatListPage> {
  int activeIndex = 2;
  String selectedFilter = 'semua';

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Ahmad Salim',
      'subtitle': 'Saya tunggu di depan indomar...',
      'time': '19:22',
      'initial': 'AS',
      'color': Color(0xFFFFB5C1),
      'unread': 3,
      'online': true,
    },
    {
      'name': 'Rizal Patung',
      'subtitle': 'Anda: Oke siap Pak, makasih 🙏\nOrder selesai: Rating 4.5',
      'time': '16 Apr',
      'initial': 'RP',
      'color': Color(0xFFC7D7FF),
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Budi Speed',
      'subtitle': 'Saya: Siap Pak, makasih ya 🙏\nOrder selesai: Rating 5.0',
      'time': '14 Apr',
      'initial': 'BS',
      'color': Color(0xFFB8F5C6),
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Bengkel Track Support',
      'subtitle': 'Penghasilan minggu ini: Rp 875.000\nSistem Otomatis',
      'time': '10 Apr',
      'initial': 'BT',
      'color': Color(0xFF131A3D),
      'unread': 0,
      'online': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      child: Column(
                        children: [
                          _buildSearchBox(),
                          const SizedBox(height: 12),
                          _buildFilterTabs(),
                          const SizedBox(height: 14),
                          _buildActiveOrderCard(),
                          const SizedBox(height: 16),
                          ...List.generate(chats.length, (index) {
                            return _buildChatItem(chats[index]);
                          }),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ada pesan lagi',
                            style: TextStyle(
                              color: Color(0xFFB5B5B5),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavbar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 18),
      decoration: const BoxDecoration(color: Color(0xFF10163A)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'pesa', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'n', style: TextStyle(color: Colors.white)),
              ],
            ),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7043).withOpacity(.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Role Mekanik',
                  style: TextStyle(
                    color: Color(0xFFFFB199),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const TextField(
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Cari percakapan...',
          hintStyle: TextStyle(color: Color(0xFFB5B5B5), fontSize: 12),
          prefixIcon: Icon(Icons.search, color: Color(0xFFB5B5B5), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _filterChip('Semua', 'semua'),
        const SizedBox(width: 8),
        _filterChip('Pelanggan', 'pelanggan'),
        const SizedBox(width: 8),
        _filterChip('Admin', 'admin'),
        const SizedBox(width: 8),
        _filterChip('CS Support', 'support'),
      ],
    );
  }

  Widget _filterChip(String title, String value) {
    final bool active = selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF10163A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? const Color(0xFF10163A) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF8A8FA3),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF7043).withOpacity(.45)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked,
            color: Color(0xFFFF7043),
            size: 20,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Aktif Sekarang',
                  style: TextStyle(
                    color: Color(0xFFFF7043),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ahmad Salim · Mogok / Mesin · OTW',
                  style: TextStyle(
                    color: Color(0xFFFF7043),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 28,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const MechanicChatPage(
                          customerName: 'Ahmad Salim',
                          orderId: '#ORD-20240521-001',
                        ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                side: const BorderSide(color: Color(0xFFFF7043)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat',
                style: TextStyle(
                  color: Color(0xFFFF7043),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => MechanicChatPage(
                  customerName: chat['name'],
                  orderId: '#ORD-20240521-001',
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: chat['color'],
                  child: Text(
                    chat['initial'],
                    style: TextStyle(
                      color:
                          chat['initial'] == 'BT'
                              ? Colors.white
                              : const Color(0xFF2563EB),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (chat['online'])
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 11),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat['name'],
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              chat['subtitle'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                height: 1.25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          chat['time'],
                          style: TextStyle(
                            color:
                                chat['unread'] > 0
                                    ? const Color(0xFFFF7043)
                                    : const Color(0xFF9CA3AF),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (chat['unread'] > 0)
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF7043),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${chat['unread']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildBottomNavbar(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context: context,
            index: 0,
            icon: Icons.home_rounded,
            label: 'Beranda',
          ),
          _navItem(
            context: context,
            index: 1,
            icon: Icons.location_on_rounded,
            label: 'Tracking',
          ),
          _navItem(
            context: context,
            index: 2,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
          ),
          _navItem(
            context: context,
            index: 3,
            icon: Icons.person_rounded,
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool active = activeIndex == index;

    return GestureDetector(
    onTap: () {
        if (index == 2) {
          return;
        }

        if (index == 0) {
          Navigator.pop(context);
        }

        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MechanicTrackingPage(hasActiveOrder: true),
            ),
          );
        }

        if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MechanicProfilePage()),
          );
        }
      },
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: active ? const Color(0xFFFF7043) : const Color(0xFFFF9B6A),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color:
                    active ? const Color(0xFFFF7043) : const Color(0xFFFF9B6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
