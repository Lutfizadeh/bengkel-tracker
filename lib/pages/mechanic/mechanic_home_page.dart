import 'package:flutter/material.dart';
import '../../services/api.dart';
import 'package:dio/dio.dart';
import '../../constants/app_colors.dart';
import 'mechanic_tracking_page.dart';
import 'mechanic_menu_chat_page.dart';
import 'mechanic_chat_page.dart';
import 'mechanic_profile_page.dart';

class MechanicHomePage extends StatefulWidget {
  const MechanicHomePage({super.key});

  @override
  State<MechanicHomePage> createState() => _MechanicHomePageState();
}

class _MechanicHomePageState extends State<MechanicHomePage> {
  int activeIndex = 0;
  List<dynamic> orders = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

Future<void> loadOrders() async {
  try {
    final response = await ApiService.client.get('/mechanic/orders');

    print('================================');
    print('STATUS CODE = ${response.statusCode}');
    print('RESPONSE DATA = ${response.data}');
    print('================================');

    setState(() {
      orders = List<dynamic>.from(response.data['data'] ?? []);
      isLoading = false;
    });

    print('ORDER DI FLUTTER = ${orders.length}');
  } on DioException catch (e) {
    print('ERROR STATUS = ${e.response?.statusCode}');
    print('ERROR DATA = ${e.response?.data}');

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('ERROR = $e');

    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 95),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: orders.map((order) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _buildOrderCard(
                                  isNew: true,
                                  orderId: order['order_code'] ?? '',
                                  dbOrderId: order['id'],
                                  time: 'Baru',
                                  customerName: order['customer_name'] ?? '',
                                  phone: order['customer_phone'] ?? '',
                                  address:
                                      '${order['user_latitude']}, ${order['user_longitude']}',
                                  serviceName: 'Servis Kendaraan',
                                  problem: order['problem'] ?? '',
                                  distance: '',
                                  buttonType:
                                      order['status'] == 'pending'
                                          ? OrderButtonType.acceptReject
                                          : OrderButtonType.tracking,
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF10163A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Order Masuk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: 
                   _buildCounterItem(
                     title: 'Order Baru',
                     value: orders
                         .where((o) => o['status'] == 'pending')
                         .length
                         .toString(),
                  ),
                ),
                Container(width: 1, height: 42, color: const Color(0xFFE5E7EB)),
                Expanded(
                  child:
                  _buildCounterItem(
                    title: 'Order Aktif',
                    value: orders
                        .where((o) =>
                            o['status'] == 'on_the_way' ||
                            o['status'] == 'service')
                        .length
                        .toString(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem({required String title, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8A8FA3),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard({
    required bool isNew,
    required String orderId,
    required int dbOrderId,
    required String time,
    required String customerName,
    required String phone,
    required String address,
    required String serviceName,
    required String problem,
    required String distance,
    required OrderButtonType buttonType,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderTopInfo(isNew: isNew, orderId: orderId, time: time),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 13,
                height: 13,
                margin: const EdgeInsets.only(top: 3),
                decoration: const BoxDecoration(
                  color: Color(0xFF10163A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phone,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            address,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (serviceName.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              serviceName,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          if (problem.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              problem,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (buttonType == OrderButtonType.tracking)
            _buildTrackingAction(distance, dbOrderId,)
          else
            _buildAcceptRejectAction(dbOrderId),
        ],
      ),
    );
  }

  Widget _buildOrderTopInfo({
    required bool isNew,
    required String orderId,
    required String time,
  }) {
    return Row(
      children: [
        if (isNew)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7043),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'BARU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            orderId,
            style: const TextStyle(
              color: Color(0xFF8A8FA3),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingAction(String distance, int orderId,) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$distance\n',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const TextSpan(
                  text: 'dari lokasi Anda',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Tombol chat
        SizedBox(
          width: 38,
          height: 38,
          child: Material(
            color: const Color(0xFFF9B55F),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const MechanicChatPage(
                          customerName: 'Budi Speed',
                          orderId: '#ORD-20240521-001',
                        ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_bubble_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Tombol tracking
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 92, maxWidth: 110),
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MechanicTrackingPage(orderId: orderId,),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Tracking',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  } 

  Widget _buildAcceptRejectAction(int orderId) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 39,
            child: ElevatedButton(
              onPressed: () {
                // nanti aksi tolak order
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Tolak',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 39,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  print('TOMBOL TERIMA ORDER DIKLIK');

                  final response = await ApiService.client.post(
                    '/orders/$orderId/accept',
                  );

                  print('STATUS CODE: ${response.statusCode}');
                  print('RESPONSE: ${response.data}');

                  if (response.statusCode == 200) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order berhasil diterima'),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MechanicTrackingPage(
                          orderId: orderId,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print('ERROR ACCEPT ORDER: $e');

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menerima order: $e'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Terima Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavbar() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(index: 0, icon: Icons.home_rounded, label: 'Beranda'),
          _navItem(
            index: 1,
            icon: Icons.location_on_rounded,
            label: 'Tracking',
          ),
          _navItem(
            index: 2,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
          ),
          _navItem(index: 3, icon: Icons.person_rounded, label: 'Profil'),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool active = activeIndex == index;

    return GestureDetector(
    onTap: () {
        if (index == 0) {
          return;
        }

        if (index == 1) {

          final activeOrder = orders.firstWhere(
            (o) =>
                o['status'] == 'on_the_way' ||
                o['status'] == 'service',
            orElse: () => null,
          );

          if (activeOrder == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Belum ada order aktif'),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MechanicTrackingPage(
                orderId: activeOrder['id'],
              ),
            ),
          );
        }

        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MechanicChatListPage()),
          );
        }

        if (index == 3) {
          Navigator.push(
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

enum OrderButtonType { tracking, acceptReject }
