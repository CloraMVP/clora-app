import 'package:flutter/material.dart';
import '../services/clo_api_service.dart'; // ✅ Import backend service
import '../widgets/gynecologist_carousel.dart';
import 'consultation_chat_screen.dart';

class CloChatScreen extends StatefulWidget {
  const CloChatScreen({super.key});

  @override
  State<CloChatScreen> createState() => _CloChatScreenState();
}

class _CloChatScreenState extends State<CloChatScreen> {
  final List<Map<String, String>> messages = [
    {"from": "clo", "text": "Hey! I’m Clo, your care companion 😊"},
    {"from": "clo", "text": "I can help with periods, pregnancy, and more!"},
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty || _isLoading) return;

    setState(() {
      messages.add({"from": "user", "text": input});
      _isLoading = true;
    });

    _controller.clear();

    final reply = await CloApiService.getCloReply(input);

    setState(() {
      _isLoading = false;
      messages.add({"from": "clo", "text": reply});
    });

    // Auto-show gynecologist list for certain keywords
    final lower = input.toLowerCase();
    if (lower.contains("consult") || lower.contains("doctor")) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showGynecologistList();
      });
    }
  }

  void _showGynecologistList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: GynecologistCarousel(
            doctors: _dummyDoctors,
            onConsultNow: (doc) {
              Navigator.pop(context); // Close bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConsultationChatScreen(
                    doctorName: doc.name,
                    doctorImage: doc.image,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  final List<Gynecologist> _dummyDoctors = [
    Gynecologist(
      name: "Dr. Anjali Mehra",
      qualification: "MBBS, MD",
      specialization: "Gynecology",
      experience: 12,
      image: "assets/gynecologist_placeholder.png",
      fee: 499,
    ),
    Gynecologist(
      name: "Dr. Ritu Nair",
      qualification: "MBBS, DGO",
      specialization: "Prenatal Care",
      experience: 8,
      image: "assets/gynecologist_placeholder.png",
      fee: 599,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Clo"),
        backgroundColor: Colors.purple.shade400,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFCDF), Color(0xFFD8CFF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final message = messages[index];
                  final isUser = message['from'] == 'user';

                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.pink.shade200
                            : Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontFamily: 'ComicNeue'),
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.purple),
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
