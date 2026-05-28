import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({
    super.key,
    this.title = 'Pak Slamet Riyadi',
    this.subtitle = 'Online · Mekanik Senior',
    this.asset = AppAssets.slamet,
  });

  final String title;
  final String subtitle;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 92,
              color: AppColors.navy,
              child: Stack(
                children: [
                  Positioned(
                    left: 18,
                    top: 51,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chevron_left, color: AppColors.white, size: 23)),
                    ),
                  ),
                  Positioned(
                    left: 60,
                    top: 49,
                    child: Row(
                      children: [
                        Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(12)), child: Center(child: Image.asset(asset, width: 38))),
                        const SizedBox(width: 9),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 15.5, color: AppColors.white, fontWeight: FontWeight.w700, height: 1)),
                            const SizedBox(height: 3),
                            Row(children: [const CircleAvatar(radius: 4, backgroundColor: AppColors.brightGreen), const SizedBox(width: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.gray))]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(right: 17, top: 51, child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.more_horiz, color: AppColors.white))),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
                children: const [
                  Center(child: Text('Hari ini, 09:24', style: TextStyle(fontSize: 11, color: AppColors.gray))),
                  SizedBox(height: 13),
                  _Bubble(text: 'Halo! Saya sudah terima orderan\nsampean. Otw ke lokasi ya 🔧', time: '09:24', me: false),
                  _Bubble(text: 'Oke Pak, saya tunggu ya.\nMotornya mogok di depan\nminimarket Indomaret', time: '09:25', me: true),
                  _Bubble(text: 'Siap! ETA 8 menit lagi. Kalau\nbisa, jangan coba-coba nyalain\nmesin dulu ya, biar aman 🙏', time: '09:25', me: false),
                  _Bubble(text: 'Siap Pak, makasih!🙏', time: '09:26', me: true),
                  _Bubble(text: 'Saya sudah sampai! Di mana? 📍', time: '09:33', me: false),
                  _Bubble(text: 'Di sebelah ATM BSI, Pak!', time: '09:33', me: true),
                  SizedBox(height: 4),
                  _TypingBubble(),
                ],
              ),
            ),
            Container(
              height: 60,
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 14, 8),
              child: Row(
                children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(19)), child: const Icon(Icons.attach_file, color: AppColors.gray, size: 22)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      decoration: BoxDecoration(
                        color: AppColors.softCream,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.warmBorder),
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ketik pesan...',
                          style: TextStyle(fontSize: 12, color: Color(0xFFC0BBB4)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 42, height: 42, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle), child: const Icon(Icons.navigation_rounded, color: AppColors.white, size: 22)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.time, required this.me});
  final String text, time;
  final bool me;
  @override
  Widget build(BuildContext context) => Align(
        alignment: me ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(left: me ? 72 : 0, right: me ? 0 : 72, bottom: 10),
          padding: const EdgeInsets.fromLTRB(14, 11, 14, 8),
          decoration: BoxDecoration(color: me ? AppColors.orange : AppColors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(text, style: TextStyle(fontSize: 12.6, height: 1.3, color: me ? AppColors.white : AppColors.textDark)),
            const SizedBox(height: 2),
            Text('$time ${me ? '✓✓' : ''}', style: TextStyle(fontSize: 10, color: me ? AppColors.white70 : AppColors.gray)),
          ]),
        ),
      );
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 66,
          height: 34,
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(radius: 4, backgroundColor: AppColors.gray), SizedBox(width: 7), CircleAvatar(radius: 4, backgroundColor: AppColors.gray), SizedBox(width: 7), CircleAvatar(radius: 4, backgroundColor: AppColors.gray),
          ]),
        ),
      );
}
