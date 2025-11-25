import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String contactName;
  final String contactInitial;

  const ChatDetailScreen({
    Key? key,
    required this.contactName,
    this.contactInitial = 'A',
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Halo, ada yang bisa saya bantu?',
      isMe: false,
      time: '10:25',
      senderName: 'Andy Wijaya',
    ),
    ChatMessage(
      text: 'Saya tertarik dengan jasa desain logo Anda',
      isMe: true,
      time: '10:26',
    ),
    ChatMessage(
      text: 'Silahkan order kak',
      isMe: false,
      time: '10:27',
      senderName: 'Andy Wijaya',
    ),
    ChatMessage(
      text: 'Pengerjaan berapa lama?',
      isMe: true,
      time: '10:28',
    ),
    ChatMessage(
      text: 'Biasanya 3-5 hari kerja kak',
      isMe: false,
      time: '10:29',
      senderName: 'Andy Wijaya',
    ),
    ChatMessage(
      text: 'Bisa lebih cepat kalau urgent?',
      isMe: true,
      time: '10:30',
    ),
    ChatMessage(
      text: 'Bisa kak, tapi ada tambahan biaya',
      isMe: false,
      time: '10:31',
      senderName: 'Andy Wijaya',
    ),
    ChatMessage(
      text: 'Berapa tambahan biayanya?',
      isMe: true,
      time: '10:32',
    ),
    ChatMessage(
      text: 'Untuk urgent +50% dari harga normal',
      isMe: false,
      time: '10:33',
      senderName: 'Andy Wijaya',
    ),
  ];

  bool _isTyping = false;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isMe: true,
          time: _getCurrentTime(),
        ),
      );
    });

    _messageController.clear();

    // Simulate typing indicator and reply
    _simulateReply();
  }

  void _simulateReply() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: 'Terima kasih sudah bertanya. Ada yang lain yang bisa dibantu?',
            isMe: false,
            time: _getCurrentTime(),
            senderName: widget.contactName,
          ),
        );
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                widget.contactInitial,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone, color: Colors.blue),
            onPressed: () {
              _showCallDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.blue),
            onPressed: () {
              _showVideoCallDialog();
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              _handleMenuSelection(value);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'info', child: Text('Info Kontak')),
              PopupMenuItem(value: 'media', child: Text('Media, File & Link')),
              PopupMenuItem(value: 'block', child: Text('Blokir')),
              PopupMenuItem(value: 'report', child: Text('Laporkan')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping) _buildTypingIndicator(),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue,
              child: Text(
                message.senderName != null && message.senderName!.isNotEmpty 
                    ? message.senderName![0] 
                    : widget.contactInitial,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!message.isMe && message.senderName != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      message.senderName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isMe ? Colors.blue : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        message.time,
                        style: TextStyle(
                          color: message.isMe ? Colors.white70 : Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green,
              child: Text(
                'Me',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue,
            child: Text(
              widget.contactInitial,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                SizedBox(width: 4),
                _buildTypingDot(1),
                SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Typing...',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              _showAttachmentOptions();
            },
          ),
          
          // Emoji Button
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {
              // Emoji picker
            },
          ),
          
          // Message Input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ),
          
          // Send Button
          IconButton(
            icon: Icon(
              Icons.send,
              color: _messageController.text.trim().isNotEmpty ? Colors.blue : Colors.grey,
            ),
            onPressed: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo, color: Colors.blue),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Open gallery
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.green),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // Open camera
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.orange),
                title: Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  // Open document picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Panggilan Suara'),
        content: Text('Memanggil ${widget.contactName}...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showVideoCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Panggilan Video'),
        content: Text('Memanggil ${widget.contactName}...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'info':
        // Show contact info
        break;
      case 'media':
        // Show media files
        break;
      case 'block':
        _showBlockDialog();
        break;
      case 'report':
        _showReportDialog();
        break;
    }
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Blokir ${widget.contactName}'),
        content: Text('Anda tidak akan menerima pesan dari ${widget.contactName} lagi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Block user logic
            },
            child: Text('Blokir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Laporkan ${widget.contactName}'),
        content: Text('Pilih alasan pelaporan:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Report user logic
            },
            child: Text('Laporkan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String? senderName;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.senderName,
  });
}