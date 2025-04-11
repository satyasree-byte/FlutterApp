import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../data/tabs_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // Added for TimeoutException
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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

  bool isEmailSent = false;
  bool isLoading = false;
  String? apiError;

  bool isValidEmail(String email) {
    if (email.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  Future<void> sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        apiError = null;
      });

      try {
        final Map<String, dynamic> requestBody = {
          'name': nameController.text.trim(),
          'phoneNumber': phoneNumber,
          'category': userType,
          'message': requirementController.text.trim(),
        };

        if (emailController.text.trim().isNotEmpty) {
          requestBody['email'] = emailController.text.trim();
        }

        final response = await http.post(
          Uri.parse('https://eduvise.ai/api/send-email'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(requestBody),
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          setState(() {
            isEmailSent = true;
          });
          
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          requirementController.clear();
          setState(() {
            userType = 'Select';
            _phoneNumber = PhoneNumber(isoCode: 'IN');
          });

          Future.delayed(const Duration(seconds: 10), () {
            if (mounted) {
              setState(() {
                isEmailSent = false;
              });
            }
          });
        } else {
          String errorMessage = 'Failed to send request (${response.statusCode})';
          try {
            final errorResponse = jsonDecode(response.body);
            if (errorResponse.containsKey('message')) {
              errorMessage = errorResponse['message'];
            } else if (errorResponse.containsKey('error')) {
              errorMessage = errorResponse['error'];
            }
          } catch (e) {
            print('Error parsing error response: $e');
          }
          
          setState(() {
            apiError = errorMessage;
          });
        }
      } on http.ClientException catch (e) {
        setState(() {
          apiError = 'Network error: ${e.message}';
        });
      } on TimeoutException catch (_) {
        setState(() {
          apiError = 'Request timed out. Please try again.';
        });
      } catch (e) {
        setState(() {
          apiError = 'An unexpected error occurred: ${e.toString()}';
        });
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }

      if (apiError != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(apiError!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Consultation"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isEmailSent)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.green,
                child: SafeArea(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Thank you, we have received your request. We will connect with you within 24hrs.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
        ],
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
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
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
        const Text(
          "Enter Phone Number",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
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
            if (!isValidPhoneNumber(cleanedValue)) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
          inputDecoration: InputDecoration(
            hintText: "Enter phone number",
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
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
        const Text(
          "Who Are You?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: userType,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: isLoading ? null : sendEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Connect With Us",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}