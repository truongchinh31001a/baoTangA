// lib/services/ticket_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class TicketService {
  static const String baseUrl = 'http://192.168.1.197:3000';

  /// Gửi mã TicketId để kích hoạt vé
  static Future<bool> activateTicket(String ticketId) async {
    final url = Uri.parse('$baseUrl/api/tickets/active');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'TicketId': ticketId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Lỗi kích hoạt: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Lỗi mạng: $e");
      return false;
    }
  }
}
