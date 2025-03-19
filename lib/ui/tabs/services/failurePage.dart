import 'package:flutter/material.dart';
import 'whatsappService.dart';

class FailurePage extends StatelessWidget {
  final String name;
  final String phone;
  final String userType;

  const FailurePage({
    Key? key,
    required this.name,
    required this.phone,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking Failed")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Booking Failed! Please try again.", style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await WhatsAppService.sendWhatsAppMessage(phone, name, userType);
                  // Optional: You can show a failure message after sending the WhatsApp message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('WhatsApp message sent successfully!'))
                  );
                },
                child: Text("Send WhatsApp Message"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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
