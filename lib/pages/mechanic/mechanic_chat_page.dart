import 'package:flutter/material.dart';

class MechanicChatPage extends StatefulWidget {
  final String customerName;
  final String orderId;

  const MechanicChatPage({
    super.key,
    required this.customerName,
    required this.orderId,
  });

  @override
  State<MechanicChatPage> createState() => _MechanicChatPageState();
}

class _MechanicChatPageState extends State<MechanicChatPage> {
  final TextEditingController _messageCtrl = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      'text': 'Halo Pak, saya mekanik\nyang akan bantu bapak',
      'time': '09:30',
      'isMe': true,
    },
    {
      'text': 'Siap Pak, saya tunggu\ndi lokasi',
      'time': '09:31',
      'isMe': false,
    },
    {'text': 'Baik Pak, saya otw\nsekarang', 'time': '09:32', 'isMe': true},
    {'text': 'Oke Pak, terima kasih.', 'time': '09:33', 'isMe': false},
    {'text': 'Saya sudah sampai di\nlokasi pak', 'time': '09:45', 'isMe': true},
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({'text': text, 'time': '09:46', 'isMe': true});

      _messageCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildWarningInfo(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                children: [
                  const Center(
                    child: Text(
                      'Hari ini',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...messages.map((message) {
                    return _buildMessageBubble(
                      text: message['text'],
                      time: message['time'],
                      isMe: message['isMe'],
                    );
                  }),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 38, 14, 18),
      decoration: const BoxDecoration(color: Color(0xFF10163A)),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Material(
              color: Colors.white.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF9CA3AF), size: 25),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.orderId,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 42,
            height: 42,
            child: Material(
              color: const Color(0xFFFF7043),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const Icon(Icons.call, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningInfo() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4EA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '⚠ Jangan bagikan kode OTP atau informasi pribadi.',
          style: TextStyle(
            color: Color(0xFFC56A22),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 14,
          left: isMe ? 80 : 0,
          right: isMe ? 0 : 80,
        ),
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF5A1F) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF111827),
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : const Color(0xFF9CA3AF),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, color: Colors.white70, size: 13),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: Material(
              color: const Color(0xFFF3F4F6),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _messageCtrl,
                style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            height: 44,
            child: Material(
              color: const Color(0xFFFF5A1F),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _sendMessage,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
