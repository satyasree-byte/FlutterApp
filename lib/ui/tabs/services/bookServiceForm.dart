import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../data/tabs_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController requirementController = TextEditingController();
  String userType = 'Select'; // Default value for dropdown
  String phoneNumber = ''; // Store full phone number with country code
  final _formKey = GlobalKey<FormState>(); // FormKey for validation
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN'); // Default country code (India)

  bool isEmailSent = false; // Track if email is sent
  bool isLoading = false; // Track loading state

  // Email validation regex
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Name validation regex (alphabets only, minimum 4 letters)
  bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z]{4,}$').hasMatch(name);
  }

  // Phone number validation for India (10 digits)
  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // Method to send email
  Future<void> sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      final response = await http.post(
        Uri.parse('http://localhost:3000/send-email'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumber,
          'category': userType,
          'message': requirementController.text,
        }),
      );

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200) {
        setState(() {
          isEmailSent = true; // Show success message
        });

        // Hide the success message after 10 seconds
        Future.delayed(Duration(seconds: 10), () {
          setState(() {
            isEmailSent = false;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Consultation")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Responsive width
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                         tabBackgroundColors[1],
                         tabGradientColors[1],  // Replace with your color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
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
                        // Name TextFormField
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Your Name",
                                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (!isValidName(value)) {
                                    return 'Name should contain only alphabets and be at least 4 letters long';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Phone Number with Country Code
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Enter Phone Number",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  setState(() {
                                    _phoneNumber = number;
                                    phoneNumber = _phoneNumber.phoneNumber!;
                                  });
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                  showFlags: true,
                                ),
                                selectorTextStyle: TextStyle(color: Colors.white),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                initialValue: _phoneNumber,
                                textFieldController: phoneController,
                                formatInput: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  // Remove non-numeric characters and validate
                                  final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                                  if (!isValidPhoneNumber(cleanedValue)) {
                                    return 'Please enter a valid 10-digit phone number';
                                  }
                                  return null;
                                },
                                inputDecoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                                textStyle: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Email TextFormField (Optional)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Enter Email (Optional)",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Email is optional, but it helps us assist you better.",
                                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  if (!isValidEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Specify Your Requirement TextFormField
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Specify Your Requirement",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: requirementController,
                                maxLines: 3, // Allow multiple lines
                                maxLength: 250, // Limit to 250 characters
                                decoration: InputDecoration(
                                  hintText: "Enter your requirement within one or two sentences so that we can assist you better!",
                                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your requirement';
                                  }
                                  if (value.split(' ').length > 50) {
                                    return 'Requirement should not exceed 250 words';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),

                        // Dropdown Button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Who Are You?",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: userType,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: ['Select', 'School Student','College Student', 'Working Professional']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.black, fontSize: 16))))
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
                          ),
                        ),
                        SizedBox(height: 20),

                        // Connect with Us Button
                        ElevatedButton(
                          onPressed: isLoading ? null : sendEmail,
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Connect with Us"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 70), // Full width button
                            backgroundColor: Colors.green,
                            textStyle: TextStyle(fontSize: 20),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Green success bar at the top
          if (isEmailSent)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.green,
                child: Text(
                  'Thank you, ${nameController.text}, we have received your request. We will connect with you within 24hrs.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}