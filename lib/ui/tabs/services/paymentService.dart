import 'package:flutter/material.dart';
import 'package:js/js.dart'; // Add this import
import 'whatsappService.dart';
import 'sucessPage.dart';
import 'failurePage.dart';
import 'dart:js' as js;

class PaymentPage extends StatefulWidget {
  final String name;
  final String phone;
  final String userType;
  final double amount;

  PaymentPage({
    required this.name,
    required this.phone,
    required this.userType,
    required this.amount,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  bool _razorpayLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRazorpayScript();
  }

  void _loadRazorpayScript() {
    // Check if Razorpay is already loaded (might be in index.html)
    if (_isRazorpayAvailable()) {
      setState(() {
        _razorpayLoaded = true;
      });
      return;
    }

    // Load Razorpay script dynamically
    final document = js.context['document'];
    final script = document.callMethod('createElement', ['script']);
    script['src'] = 'https://checkout.razorpay.com/v1/checkout.js';
    script['onload'] = allowInterop(() {
      setState(() {
        _razorpayLoaded = true;
      });
    });
    
    document['head'].callMethod('appendChild', [script]);
  }

  bool _isRazorpayAvailable() {
    return js.context.hasProperty('Razorpay');
  }

  void _handlePaymentSuccess(dynamic response) {
    final paymentId = response['razorpay_payment_id']?.toString() ?? 'Unknown';
    
    // Send WhatsApp message
    WhatsAppService.sendWhatsAppMessage(
      widget.phone,
      "Welcome ${widget.name}! Your payment of ₹${widget.amount} was successful. Payment ID: $paymentId",
      widget.userType,
    );
    
    // Navigate to Success Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(
          name: widget.name, 
          phone: widget.phone, 
          userType: widget.userType
        ),
      ),
    );
  }

  void _handlePaymentError(String error) {
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: $error")),
    );
    
    // Navigate to Failure Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FailurePage(
          name: widget.name, 
          phone: widget.phone, 
          userType: widget.userType
        ),
      ),
    );
  }

  void startPayment() {
    if (!_razorpayLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment gateway is loading, please wait...")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final options = js.JsObject.jsify({
      'key': 'rzp_test_RZ5vu71uOG4oUs', // REPLACE WITH YOUR ACTUAL KEY
      'amount': (widget.amount * 100).toInt(), // Amount in paise
      'currency': 'INR',
      'name': 'Eduvise.ai',
      'description': 'Consultation Booking',
      'prefill': {
        'name': widget.name,
        'email': '${widget.phone}@eduvise.ai',
        'contact': widget.phone,
      },
      'theme': {
        'color': '#4F46E5',
      },
      'handler': allowInterop((response) {
        _handlePaymentSuccess(response);
      }),
      'modal': {
        'ondismiss': allowInterop(() {
          _handlePaymentError('Payment cancelled by user');
        })
      }
    });

    try {
      final razorpay = js.JsObject(js.context['Razorpay'], [options]);
      razorpay.callMethod('open');
    } catch (e) {
      _handlePaymentError('Failed to initialize payment: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Payment"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Payment Card
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.lock_outline, size: 50, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      "Secure Payment",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "₹${widget.amount}",
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.purple
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Eduvise.ai Consultation Booking",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    
                    // Loading or Pay Button
                    if (_isLoading)
                      Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Opening payment gateway..."),
                        ],
                      )
                    else if (!_razorpayLoaded)
                      Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Loading payment system..."),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: startPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Text(
                          "Pay Now - ₹${widget.amount}",
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          
            SizedBox(height: 10),
            Text(
              "🔒 Secure payment powered by Razorpay",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}