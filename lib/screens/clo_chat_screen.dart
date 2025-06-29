import 'package:flutter/material.dart';
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

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add({"from": "user", "text": input});
      messages.add({"from": "clo", "text": _generateReply(input)});
    });

    _controller.clear();
  }

  String _generateReply(String input) {
    input = input.toLowerCase();

    if (input.contains("period")) {
      return "Tracking your period? I’ve got you! 💜";
    } else if (input.contains("pregnancy")) {
      return "Here’s a tip: stay hydrated and rest well 👶💧";
    } else if (input.contains("consult") || input.contains("doctor")) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showGynecologistList();
      });
      return "Here are some trusted gynecologists 🩺";
    }

    return "Let me get back to you on that 🦸‍♀️";
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['from'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.pink.shade200 : Colors.purple.shade100,
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
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
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
