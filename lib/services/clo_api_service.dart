import 'dart:convert';
import 'package:http/http.dart' as http;

class CloApiService {
  // ✅ Correct base URL for Android Emulator to access local backend
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<String> getCloReply(String userMessage) async {
    final url = Uri.parse('$baseUrl/chat');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? "I'm here for you 💜";
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return "Sorry, I'm having trouble understanding you right now.";
      }
    } catch (e) {
      print('❌ Error connecting to Clo API: $e');
      return "Oops! Something went wrong. Try again later.";
    }
  }
}
