import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'whatsappService.dart';
import 'sucessPage.dart'; // Import SuccessPage
import 'failurePage.dart';

class PaymentPage extends StatefulWidget {
  final String name;
  final String phone;
  final String userType;
  final double amount; // Add a dynamic amount field

  PaymentPage({
    required this.name,
    required this.phone,
    required this.userType,
    required this.amount, // Pass amount dynamically
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Send WhatsApp message on success
    WhatsAppService.sendWhatsAppMessage(
      widget.phone,
      "Welcome ${widget.name}! Your payment of ₹${widget.amount} was successful.",
      widget.userType,
    );
    
    // Navigate to SuccessPage after payment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(name: widget.name, phone: widget.phone, userType: widget.userType),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed!")));
    
    // Navigate to FailurePage after error
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FailurePage(name: widget.name, phone: widget.phone, userType: widget.userType),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("External Wallet Used")));
  }

  void startPayment() {
    var options = {
      'key': 'your_razorpay_key', // Replace with your Razorpay key
      'amount': (widget.amount * 100).toInt(), // Amount in paise (₹500 = 50000 paise)
      'name': widget.name,
      'description': 'Booking Consultation',
      'prefill': {
        'contact': widget.phone,
        'email': 'test@example.com',
      },
      'theme': {
        'color': '#F37254',
      },
    };

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: startPayment,
          child: Text("Pay Now"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
