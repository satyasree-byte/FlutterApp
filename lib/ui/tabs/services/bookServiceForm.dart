import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isInternational = false;
  final TextEditingController _countryCodeController = TextEditingController(text: '+');
  final _formKey = GlobalKey<FormState>();
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
      
      if (cleanedPhone.isEmpty) return;
      if (userType == 'Select') return;

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
      } else {
        throw Exception('Failed to save booking');
      }
    } catch (e) {
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
      
      final response = await http.post(
        Uri.parse('https://eduvise.ai/sendEmail'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(emailData),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Email failed');
      }
    } catch (_) {
      // email failure is non-blocking
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
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 40),
              ),
              const SizedBox(height: 16),
              Text('Request Sent!',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('We will reach out within 24 hours.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.confirmation_number_rounded, color: Color(0xFFB794F4), size: 16),
                    const SizedBox(width: 8),
                    Text('Ref: $_bookingId',
                        style: GoogleFonts.poppins(color: const Color(0xFFB794F4), fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.07),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Done', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMobileWhatsApp(String encodedMessage) {
    final whatsappUrl = "https://wa.me/$_whatsappNumber?text=$encodedMessage";
    html.window.open(whatsappUrl, '_blank');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.open_in_new_rounded, color: Color(0xFF25D366), size: 40),
              ),
              const SizedBox(height: 16),
              Text('WhatsApp Opened',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Switch to WhatsApp and tap Send.\nWe\'ll reply within minutes.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.confirmation_number_rounded, color: Color(0xFFB794F4), size: 16),
                    const SizedBox(width: 8),
                    Text('Ref: $_bookingId',
                        style: GoogleFonts.poppins(color: const Color(0xFFB794F4), fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.07),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Got It', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDesktopWhatsApp(String message, String encodedMessage) {
    final whatsappUrl = "https://wa.me/$_whatsappNumber?text=$encodedMessage";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scan to Open WhatsApp',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Scan with your phone camera, then tap Send',
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(whatsappUrl)}',
                  height: 180, width: 180,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.confirmation_number_rounded, color: Color(0xFFB794F4), size: 16),
                    const SizedBox(width: 8),
                    Text('Ref: $_bookingId',
                        style: GoogleFonts.poppins(color: const Color(0xFFB794F4), fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.07),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Close', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => html.window.open(whatsappUrl, '_blank'),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366).withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: const Color(0xFF25D366).withOpacity(0.4)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Open Web', style: GoogleFonts.poppins(color: const Color(0xFF25D366), fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        // ── Primary: WhatsApp ──────────────────────────────────
        _actionButton(
          onPressed: isWhatsAppLoading ? null : _handleWhatsAppBooking,
          gradient: const LinearGradient(
              colors: [Color(0xFF075E54), Color(0xFF25D366)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          height: 60,
          child: isWhatsAppLoading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.whatsapp,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Book via WhatsApp',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        Text('Fastest — we reply within minutes',
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 10),

        // ── Secondary: Email ──────────────────────────────────
        _actionButton(
          onPressed: isLoading ? null : _handleEmailBooking,
          gradient: const LinearGradient(
              colors: [Color(0xFF1C3A6B), Color(0xFF2563EB)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          height: 52,
          child: isLoading
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.envelope,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Book via Email  —  reply in 24 hrs',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
        ),

        const SizedBox(height: 20),

        // ── "What happens next" steps ─────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _nextStep(Icons.send_rounded, '1', 'You submit'),
              _stepDivider(),
              _nextStep(Icons.chat_rounded, '2', 'We reach out'),
              _stepDivider(),
              _nextStep(Icons.video_call_rounded, '3', 'Session booked'),
            ],
          ),
        ),

        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_rounded, color: Colors.white30, size: 13),
            const SizedBox(width: 5),
            Text('Your details are private and never shared.',
                style: GoogleFonts.poppins(color: Colors.white30, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _nextStep(IconData icon, String step, String label) {
    return Column(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(0.18),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.4)),
          ),
          child: Icon(icon, color: const Color(0xFFB794F4), size: 16),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _stepDivider() => Expanded(
    child: Container(height: 1, color: Colors.white.withOpacity(0.08)),
  );

  Widget _actionButton({
    required VoidCallback? onPressed,
    required LinearGradient gradient,
    required Widget child,
    double height = 56,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade700])
            : gradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: onPressed == null
            ? []
            : [BoxShadow(color: gradient.colors.last.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;
    return Scaffold(
      backgroundColor: const Color(0xFF060818),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book a Consultation',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060818), Color(0xFF0D1B2A), Color(0xFF0A0F1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -60, left: -80, child: _glowOrb(300, const Color(0xFF7C3AED))),
            Positioned(bottom: -40, right: -60, child: _glowOrb(260, const Color(0xFF0EA5E9))),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : (w > 1000 ? (w - 700) / 2 : 40),
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    children: [
                      // Header card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                        margin: const EdgeInsets.only(bottom: 28),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.bolt_rounded, color: Colors.white, size: 36),
                            const SizedBox(height: 8),
                            Text('Book a Free Consultation',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text('Takes 60 seconds. Talk to a real expert — not a bot.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      // Form card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildFormField(
                                label: "Your Name",
                                hintText: "What should we call you?",
                                icon: Icons.person_outline_rounded,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildUserTypeDropdown(),
                              const SizedBox(height: 16),
                              _buildPhoneField(),
                              const SizedBox(height: 16),
                              _buildFormField(
                                label: "Email (Optional)",
                                hintText: "For session confirmation",
                                icon: Icons.mail_outline_rounded,
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
                                label: "What do you need help with?",
                                hintText: "e.g. career after 12th, first IT job, switch to QA...",
                                icon: Icons.notes_rounded,
                                controller: requirementController,
                                maxLines: 2,
                                maxLength: 150,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please describe what you need';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              _buildActionButtons(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.0)],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFF7C3AED), size: 20)
                : null,
            fillColor: Colors.white.withOpacity(0.06),
            filled: true,
            counterStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 11),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
            errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Phone Number",
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            GestureDetector(
              onTap: () => setState(() {
                _isInternational = !_isInternational;
                phoneController.clear();
                _countryCodeController.text = '+';
                phoneNumber = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isInternational
                      ? const Color(0xFF0EA5E9).withOpacity(0.18)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isInternational
                        ? const Color(0xFF0EA5E9).withOpacity(0.5)
                        : Colors.white.withOpacity(0.15),
                  ),
                ),
                child: Text(
                  _isInternational ? '🌍  International' : '🇮🇳  India (+91)',
                  style: GoogleFonts.poppins(
                    color: _isInternational ? const Color(0xFF7DD3FC) : Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code prefix (editable only for international)
            if (_isInternational) ...[
              SizedBox(
                width: 72,
                child: TextFormField(
                  controller: _countryCodeController,
                  keyboardType: TextInputType.phone,
                  maxLength: 5,
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFB794F4), fontSize: 15, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                  onChanged: (val) {
                    final digits = phoneController.text.replaceAll(RegExp(r'\D'), '');
                    phoneNumber = '${_countryCodeController.text}$digits';
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '+1',
                    hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
                    fillColor: const Color(0xFF7C3AED).withOpacity(0.12),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color(0xFF7C3AED).withOpacity(0.35))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color(0xFF7C3AED).withOpacity(0.35))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent)),
                  ),
                  validator: (_) {
                    final code = _countryCodeController.text.trim();
                    if (!code.startsWith('+') || code.length < 2) {
                      return 'e.g. +1';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
            // Main phone number input
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: _isInternational ? 15 : 10,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                onChanged: (val) {
                  final digits = val.replaceAll(RegExp(r'\D'), '');
                  phoneNumber = _isInternational
                      ? '${_countryCodeController.text}$digits'
                      : '+91$digits';
                },
                decoration: InputDecoration(
                  hintText: _isInternational ? "Your number" : "10-digit mobile number",
                  hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
                  counterText: '',
                  prefixIcon: _isInternational
                      ? null
                      : Container(
                          margin: const EdgeInsets.only(left: 12, right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.35)),
                          ),
                          child: Text('+91',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFFB794F4),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  fillColor: Colors.white.withOpacity(0.06),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                  errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  final digits = value.replaceAll(RegExp(r'\D'), '');
                  if (!_isInternational && digits.length != 10) {
                    return 'Enter a valid 10-digit Indian mobile number';
                  }
                  if (_isInternational && digits.length < 6) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("I Am A...",
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: userType,
          dropdownColor: const Color(0xFF1A1A2E),
          iconEnabledColor: const Color(0xFF7C3AED),
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_pin_rounded, color: Color(0xFF7C3AED), size: 20),
            fillColor: Colors.white.withOpacity(0.06),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent)),
            errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
          ),
          items: ['Select', 'School Student', 'College Student', 'Working Professional']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
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