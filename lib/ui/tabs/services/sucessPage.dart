import 'package:flutter/material.dart';
import 'whatsappService.dart';

class SuccessPage extends StatelessWidget {
  final String name;
  final String phone;
  final String userType;

  const SuccessPage({
    Key? key,
    required this.name,
    required this.phone,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking Success")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Booking Successful!", style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await WhatsAppService.sendWhatsAppMessage(phone, name, userType);
                  // Optional: You can show a confirmation after sending the message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('WhatsApp message sent successfully!'))
                  );
                },
                child: Text("Send WhatsApp Message"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
