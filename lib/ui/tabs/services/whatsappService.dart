import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  // Sender's WhatsApp number
  static const String senderNumber = '8884741673'; // Replace with your sender number

  // Method to send WhatsApp message
  static Future<void> sendWhatsAppMessage(String receiverNumber, String name, String userType) async {
    String message = "Hi, I'm $name, a $userType. I would like to book a consultation!";

    // Construct the WhatsApp URL
    String url = 'https://wa.me/$receiverNumber?text=${Uri.encodeComponent(message)}';

    // Try to open WhatsApp with the given URL
    try {
      if (await canLaunch(url)) {
        await launch(url); // Opens WhatsApp with the message
      } else {
        print('Could not open WhatsApp');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
