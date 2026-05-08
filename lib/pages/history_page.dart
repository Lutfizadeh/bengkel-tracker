import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_navbar.dart';
import 'chat_list_page.dart';
import 'home_page.dart';
import 'service_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 118,
                    color: AppColors.navy,
                    child: Stack(children: [
                      const Positioned(right: -18, top: -24, child: CircleAvatar(radius: 65, backgroundColor: AppColors.blueNavy)),
                      const Positioned(left: 19, top: 16, child: Text('19:22', style: TextStyle(color: AppColors.gray, fontSize: 12))),
                      Positioned(left: 18, top: 45, child: Row(children: [GestureDetector(onTap: () => _goHome(context), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chevron_left, color: AppColors.white, size: 23))), const SizedBox(width: 8), const Text('Beranda', style: TextStyle(color: AppColors.gray, fontSize: 13))])),
                      const Positioned(left: 19, bottom: 14, child: Text('History Order', style: TextStyle(color: AppColors.white, fontSize: 22, fontFamily: 'Syne', fontWeight: FontWeight.w700))),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  const _Tabs(),
                  const SizedBox(height: 16),
                  const _HistoryCard(asset: AppAssets.slamet, title: 'Bengkel Pak Slamet', service: 'Mogok / Mesin', detail: 'Oli mesin + Busi NGK', date: '22 Apr 2026 · 09:45', price: 'Rp 100.000'),
                  const _HistoryCard(asset: AppAssets.karya, title: 'Auto Karya Motor', service: 'Ganti Ban + Tambal', detail: 'Ban belakang IRC 80/90–14', date: '14 Apr 2026 · 14:20', price: 'Rp 75.000'),
                  const _HistoryCard(asset: AppAssets.lainnya, title: 'Setia Motor', service: 'Aki Drop + Kabel', detail: 'Ganti aki + perbaikan kabel', date: '22 Apr 2026 · 10:15', price: 'Rp 180.000', process: true),
                  const _HistoryCard(asset: '', title: 'Novi Garage', service: 'Tune Up + Karburator', detail: 'Servis karburator + stel klep', date: '10 Apr 2026 · 13:00', price: 'Rp 65.000', garage: true),
                  Container(
                    height: 58,
                    margin: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.warmBorder), borderRadius: BorderRadius.circular(13)),
                    child: Row(children: [
                      const Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Total pengeluaran bulan ini', style: TextStyle(fontSize: 12, color: AppColors.gray)), SizedBox(height: 4), Text('4 transaksi · 3 bengkel berbeda', style: TextStyle(fontSize: 10.5, color: AppColors.gray))])),
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('Rp 420.000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 5), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: AppColors.paleOrange, borderRadius: BorderRadius.circular(7)), child: const Text('Lihat detail', style: TextStyle(fontSize: 10, color: AppColors.orange)))]),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget { const _Tabs(); @override Widget build(BuildContext context) { final tabs = ['Semua', 'Selesai', 'Proses', 'Batal']; return Container(height: 40, margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.warmBorder), borderRadius: BorderRadius.circular(12)), child: Row(children: tabs.map((t) { final a = t == 'Semua'; return Expanded(child: Container(decoration: BoxDecoration(color: a ? AppColors.navy : AppColors.white, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(t, style: TextStyle(fontSize: 11.5, color: a ? AppColors.white : AppColors.darkGray, fontWeight: a ? FontWeight.w700 : FontWeight.w400))))); }).toList())); } }

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.asset, required this.title, required this.service, required this.detail, required this.date, required this.price, this.process = false, this.garage = false});
  final String asset, title, service, detail, date, price;
  final bool process, garage;
  @override
  Widget build(BuildContext context) => Container(
    height: 108,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.warmBorder), borderRadius: BorderRadius.circular(14)),
    child: Stack(children: [
      if (process) const Positioned(left: 0, top: 0, bottom: 0, child: DecoratedBox(decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.horizontal(left: Radius.circular(14))), child: SizedBox(width: 5))),
      Padding(
        padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: garage ? AppColors.paleOrange : AppColors.black, borderRadius: BorderRadius.circular(10)), child: Center(child: garage ? const Text('GARAGE', style: TextStyle(color: Color(0xFFFF2965), fontSize: 8, fontWeight: FontWeight.w800)) : Image.asset(asset, width: 42))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))), _Status(process: process)]),
            const SizedBox(height: 1),
            Text(service, style: const TextStyle(fontSize: 12, color: AppColors.darkGray)),
            Text(detail, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
            const Spacer(),
            const Divider(height: 1, color: AppColors.warmBorder),
            const SizedBox(height: 8),
            Row(children: [Text(date, style: const TextStyle(fontSize: 11.5, color: AppColors.gray)), const Spacer(), Text(price, style: const TextStyle(fontSize: 15, color: AppColors.orange, fontWeight: FontWeight.w700))]),
          ])),
        ]),
      ),
    ]),
  );
}

class _Status extends StatelessWidget { const _Status({required this.process}); final bool process; @override Widget build(BuildContext context) => Container(height: 25, padding: const EdgeInsets.symmetric(horizontal: 11), decoration: BoxDecoration(color: process ? const Color(0xFFFEF3C7) : AppColors.lightGreen, borderRadius: BorderRadius.circular(7)), child: Center(child: Row(children: [CircleAvatar(radius: 3.5, backgroundColor: process ? AppColors.yellow : AppColors.brightGreen), const SizedBox(width: 8), Text(process ? 'Dalam Proses' : ' Selesai', style: TextStyle(fontSize: 10, color: process ? AppColors.brown : AppColors.green, fontWeight: FontWeight.w700))]))); }
