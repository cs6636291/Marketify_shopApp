import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketify_app/core/common/constants/app_constants.dart';

class ChatScreen extends StatefulWidget {
  final String shopName;
  const ChatScreen({super.key, this.shopName = 'TechHub Store'});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String id;
  final String? text;
  final String? imageUrl;
  final DateTime time;
  bool isMine;
  bool isRead;
  bool isTyping;

  ChatMessage({
    required this.id,
    this.text,
    this.imageUrl,
    DateTime? time,
    this.isMine = false,
    this.isRead = false,
    this.isTyping = false,
  }) : time = time ?? DateTime.now();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'รู้ยัง Markettify แอปโครตดี',
      time: DateTime.now().subtract(const Duration(minutes: 35)),
      isMine: false,
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      text: 'ดีจริง ไม่เชื่อดูหน้า',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      isMine: true,
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      imageUrl:
          'https://instagram.fbkk24-1.fna.fbcdn.net/v/t51.2885-19/135329731_220501839649929_3698531228271091242_n.jpg?efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLmRqYW5nby45OTguYzIifQ&_nc_ht=instagram.fbkk24-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QHfJpYly53EBr-mZb60yXgH-MY458utyaFpXFyf1oNilKrvoeT9X2Ol-Lns-cFuN1mf-RUx3NMQlp2arjOSWCFc&_nc_ohc=fpU6ggNqsaoQ7kNvwFvakXg&_nc_gid=1lKnaqASqAtSTUjKRwil7A&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AfwCPyNplkH-VEybjn0beOwDVQCZ41oHRhWaBlvHNTqjIg&oe=69AC4FD1&_nc_sid=7d3ac5',
      time: DateTime.now().subtract(const Duration(minutes: 28)),
      isMine: true,
      isRead: true,
    ),
    ChatMessage(
      id: '4',
      text: '55555555555555555555555555',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isMine: false,
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isTypingIndicator = false;
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    // simulate seller typing after a moment (example)
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() => _isTypingIndicator = true);
    // });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMine: true,
      isRead: false,
    );
    setState(() {
      _messages.add(msg);
      _textController.clear();
    });
    _scrollToBottom();
  }

  void _attachImage() {
    // demo: add a network image message
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl:
          'https://instagram.fbkk24-1.fna.fbcdn.net/v/t51.2885-19/135329731_220501839649929_3698531228271091242_n.jpg?efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLmRqYW5nby45OTguYzIifQ&_nc_ht=instagram.fbkk24-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QHfJpYly53EBr-mZb60yXgH-MY458utyaFpXFyf1oNilKrvoeT9X2Ol-Lns-cFuN1mf-RUx3NMQlp2arjOSWCFc&_nc_ohc=fpU6ggNqsaoQ7kNvwFvakXg&_nc_gid=1lKnaqASqAtSTUjKRwil7A&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AfwCPyNplkH-VEybjn0beOwDVQCZ41oHRhWaBlvHNTqjIg&oe=69AC4FD1&_nc_sid=7d3ac5',
      isMine: true,
    );
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildBubble(ChatMessage m) {
    final isMine = m.isMine;
    final bubbleColor = isMine
        ? AppConstants.primaryColor
        : Colors.grey.shade200;
    final textColor = isMine ? Colors.white : Colors.black87;

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isMine ? 12 : 0),
      topRight: Radius.circular(isMine ? 0 : 12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );

    Widget content;
    if (m.isTyping) {
      content = _TypingIndicator(
        controller: _dotsController,
        dotColor: textColor,
      );
    } else if (m.imageUrl != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          m.imageUrl!,
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          loadingBuilder: (c, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              width: 160,
              height: 160,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              ),
            );
          },
          errorBuilder: (c, e, s) => SizedBox(
            width: 160,
            height: 160,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      );
    } else {
      content = Text(
        m.text ?? '',
        style: GoogleFonts.outfit(color: textColor, fontSize: 15),
      );
    }

    return Column(
      crossAxisAlignment: isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 260),
          padding: m.imageUrl != null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: content,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                _formatTime(m.time),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              if (isMine)
                Text(
                  m.isRead ? 'Read' : 'Sent',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          widget.shopName,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                itemCount: _messages.length + (_isTypingIndicator ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTypingIndicator && index == _messages.length) {
                    final typingMsg = ChatMessage(
                      id: 'typing',
                      isTyping: true,
                      isMine: false,
                      text: null,
                    );
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: _buildBubble(typingMsg),
                    );
                  }
                  final m = _messages[index];
                  return Align(
                    alignment: m.isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: _buildBubble(m),
                  );
                },
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: _attachImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _attachImage,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              style: GoogleFonts.outfit(),
                              decoration: InputDecoration(
                                hintText: 'Write a message...',
                                hintStyle: GoogleFonts.outfit(
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendTextMessage(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: AppConstants.primaryColor,
                            ),
                            onPressed: _sendTextMessage,
                          ),
                        ],
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

class _TypingIndicator extends StatelessWidget {
  final AnimationController controller;
  final Color dotColor;
  const _TypingIndicator({
    Key? key,
    required this.controller,
    this.dotColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 36,
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final t = controller.value;
            double opacity(int i) {
              final phase = (t + i * 0.2) % 1.0;
              return 0.3 + (0.7 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2));
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor.withOpacity(opacity(i)),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
