import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../data/tabs_layout.dart';
import 'paymentService.dart'; 
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController requirementController = TextEditingController();
  String userType = 'Select';
  String phoneNumber = '';
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  String? _bookingId;
  final String _whatsappNumber = '919743997135';

  bool isLoading = false;
  bool isWhatsAppLoading = false; 
  String? apiError;

  // ========== DEVICE DETECTION ==========
  bool get isMobileWeb {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final isMobile = userAgent.contains('android') || 
                     userAgent.contains('iphone') || 
                     userAgent.contains('ipad') ||
                     userAgent.contains('mobile');
    final screenWidth = html.window.screen?.width ?? 0;
    final isSmallScreen = screenWidth < 768;
    return isMobile || isSmallScreen;
  }
  
  bool get isDesktopWeb => !isMobileWeb;

  // Build WhatsApp message
  String _buildWhatsAppMessage() {
    return '''
📋 *NEW CONSULTATION REQUEST*

🔢 *Reference:* ${_bookingId ?? 'Generating...'}
👤 *Name:* ${nameController.text}
📞 *Phone:* $phoneNumber
📧 *Email:* ${emailController.text.isNotEmpty ? emailController.text : "Not provided"}
🎓 *User Type:* $userType
📝 *Requirement:* ${requirementController.text}
💰 *Service Amount:* ₹699
⏰ *Submitted:* ${DateTime.now().toLocal()}
📍 *Source:* Eduvise.ai Website

_This is an automated booking request from the website form._
''';
  }

  // ✅ COMMON FUNCTION: Save booking data (used by both WhatsApp and Email)
  Future<void> _saveBookingData(String method) async {
    try {
      final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
      
      if (cleanedPhone.isEmpty) {
        print('❌ Phone number is empty');
        return;
      }
      
      if (userType == 'Select') {
        print('❌ userType cannot be "Select"');
        return;
      }

      final Map<String, dynamic> requestBody = {
        'name': nameController.text.trim(),
        'phone': cleanedPhone,
        'userType': userType,
        'requirement': requirementController.text.trim(),
        'bookingMethod': method,
      };

      if (emailController.text.trim().isNotEmpty) {
        requestBody['email'] = emailController.text.trim();
      }

      print('🚀 Saving to database via https://eduvise.ai/saveBooking');
      
      final response = await http.post(
        Uri.parse('https://eduvise.ai/saveBooking'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _bookingId = responseData['bookingId'];
        print('✅ Booking saved: $_bookingId');
      } else {
        print('⚠️ Save failed (${response.statusCode})');
        throw Exception('Failed to save booking');
      }
    } catch (e) {
      print('💥 _saveBookingData Error: $e');
      rethrow;
    }
  }

  // ✅ Send email to consulting@eduvise.ai
  Future<void> _sendBookingEmail() async {
    try {
      final Map<String, dynamic> emailData = {
        'name': nameController.text.trim(),
        'phoneNumber': phoneNumber.replaceAll(RegExp(r'\D'), ''),
        'message': requirementController.text.trim(),
        'email': emailController.text.trim().isNotEmpty ? emailController.text.trim() : '',
        'category': userType,
        'booking_reference': _bookingId,
      };
      
      print('📧 Sending email to consulting@eduvise.ai');
      
      final response = await http.post(
        // ✅ CORRECTED: Use capital E in "sendEmail"
        Uri.parse('https://eduvise.ai/sendEmail'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(emailData),
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        print('✅ Email sent successfully');
      } else {
        print('❌ Email failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Email sending error: $e');
    }
  }

  // ✅ WhatsApp flow: Save data + Open WhatsApp
  Future<void> _handleWhatsAppBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      isWhatsAppLoading = true;
      apiError = null;
    });

    try {
      // 1. Save booking data
      await _saveBookingData('whatsapp');
      
      // 2. Build and open WhatsApp
      final message = _buildWhatsAppMessage();
      final encodedMessage = Uri.encodeComponent(message);
      
      if (isMobileWeb) {
        _handleMobileWhatsApp(encodedMessage);
      } else {
        _handleDesktopWhatsApp(message, encodedMessage);
      }
    } catch (e) {
      setState(() {
        apiError = 'Error: ${e.toString()}';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(apiError!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isWhatsAppLoading = false;
      });
    }
  }

  // ✅ Email flow: Save data + Send email
  Future<void> _handleEmailBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      isLoading = true;
      apiError = null;
    });

    try {
      // 1. Save booking data
      await _saveBookingData('email');
      
      // 2. Send email
      await _sendBookingEmail();
      
      // 3. Show success dialog
      _showEmailSuccessDialog();
      
    } catch (e) {
      setState(() {
        apiError = 'Error: ${e.toString()}';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(apiError!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showEmailSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.email, color: Colors.blue),
            SizedBox(width: 10),
            Text('Request Sent Successfully'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Booking Reference:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$_bookingId', style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 15),
            Text('✅ Your request has been sent to consulting@eduvise.ai'),
            SizedBox(height: 10),
            Text('⏰ We will connect with you within 24 hours.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToPayment();
            },
            child: Text('Proceed to Payment'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleMobileWhatsApp(String encodedMessage) {
    final whatsappUrl = "https://wa.me/$_whatsappNumber?text=$encodedMessage";
    html.window.open(whatsappUrl, '_blank');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/images/whatsapp.jpg',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10),
            Text('WhatsApp Opened'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Booking Reference: $_bookingId'),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📱 Mobile Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('1. Switch to WhatsApp tab/app'),
                  Text('2. Click the GREEN SEND button'),
                  Text('3. We will confirm your booking shortly'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToPayment();
            },
            child: Text('Proceed to Payment'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It'),
          ),
        ],
      ),
    );
  }

  void _handleDesktopWhatsApp(String message, String encodedMessage) {
    final whatsappUrl = "https://wa.me/$_whatsappNumber?text=$encodedMessage";
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📱 Complete via WhatsApp'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.confirmation_number, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Booking Reference:', style: TextStyle(fontSize: 12)),
                          Text('$_bookingId', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code_scanner, size: 40, color: Colors.green),
                      SizedBox(height: 10),
                      Text('Scan QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(whatsappUrl)}',
                          height: 180,
                          width: 180,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => html.window.open(whatsappUrl, '_blank'),
                        icon: Icon(Icons.open_in_browser),
                        label: Text('Open WhatsApp Web'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _navigateToPayment(),
            child: Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    if (email.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(height: 16),
        
        // WhatsApp Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: isWhatsAppLoading ? null : _handleWhatsAppBooking,
            icon: Image.asset(
              'assets/images/whatsapp.jpg',
              width: 24,
              height: 24,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
            ),
            label: isWhatsAppLoading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Connect via WhatsApp',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF25D366),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        
        SizedBox(height: 12),
        
        // Email Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _handleEmailBooking,
            icon: Icon(Icons.email, color: Colors.white),
            label: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Connect via Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        
        SizedBox(height: 12),
        
        // Payment Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _navigateToPayment();
              }
            },
            icon: Icon(Icons.payment, color: Colors.white),
            label: Text(
              'Proceed to Payment - ₹699',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        
        SizedBox(height: 10),
        Text(
          'Choose your preferred contact method. Data will be saved to our database.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Consultation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tabBackgroundColors[1],
                      tabGradientColors[1],
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFormField(
                        label: "Name",
                        hintText: "Enter Your Name",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPhoneField(),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: "Enter Email (Optional)",
                        hintText: "Email is optional, but it helps us assist you better.",
                        controller: emailController,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && !isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: "Specify Your Requirement",
                        hintText: "Enter your requirement within one or two sentences so that we can assist you better!",
                        controller: requirementController,
                        maxLines: 3,
                        maxLength: 250,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your requirement';
                          }
                          if (value.split(' ').length > 50) {
                            return 'Requirement should not exceed 50 words';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildUserTypeDropdown(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter Phone Number", style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            setState(() {
              _phoneNumber = number;
              phoneNumber = _phoneNumber.phoneNumber ?? '';
            });
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            showFlags: true,
            useEmoji: true,
          ),
          selectorTextStyle: const TextStyle(color: Colors.black),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          initialValue: _phoneNumber,
          textFieldController: phoneController,
          formatInput: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (cleanedValue.length != 10) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
          inputDecoration: InputDecoration(
            hintText: "Enter phone number",
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
          ),
          textStyle: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildUserTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Who Are You?", style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: userType,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
          ),
          items: ['Select', 'School Student', 'College Student', 'Working Professional']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(color: Colors.black, fontSize: 16)),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              userType = val!;
            });
          },
          validator: (value) {
            if (value == 'Select') {
              return 'Please select who you are';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _navigateToPayment() {
    double amount = 699.0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          name: nameController.text.trim(),
          phone: phoneNumber,
          userType: userType,
          amount: amount,
        ),
      ),
    );
  }
}