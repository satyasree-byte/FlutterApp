import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'paymentService.dart';
import 'whatsappService.dart';
import 'sucessPage.dart';
import 'failurePage.dart';
import '../../../data/tabs_layout.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String userType = 'Select'; // Default value for dropdown
  String phoneNumber = ''; // Store full phone number with country code
  final _formKey = GlobalKey<FormState>(); // FormKey for validation
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US'); // Default country code (USA)

  bool isWhatsAppMessageSent = false; // Track if WhatsApp message is sent

  // Method that handles the booking and WhatsApp message
  Future<void> proceedToPayment() async {
    String name = nameController.text;

    if (_formKey.currentState?.validate() ?? false) {
      // Dynamically passing the userType (from the dropdown)
      await WhatsAppService.sendWhatsAppMessage(phoneNumber, name, userType);

      if (isWhatsAppMessageSent) {
        setState(() {
          isWhatsAppMessageSent = true; // Update state to show payment button
        });

        // Assuming the payment is successful, navigate to SuccessPage
        bool isPaymentSuccess = true; // Just a placeholder logic for payment status

        if (isPaymentSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(name: name, phone: phoneNumber, userType: userType),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FailurePage(name: name, phone: phoneNumber, userType: userType),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Consultation")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tabBackgroundColors[0],
                  tabGradientColors[0],
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
                          "Enter Full Name",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Enter Full Name",
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
                              return 'Please enter your full name';
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

                  // Dropdown Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          items: ['Select', 'College Student', 'School Student', 'Working Professional']
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

                  // Connect via WhatsApp Button
                  if (!isWhatsAppMessageSent)
                    ElevatedButton(
                      onPressed: () async {
                        // Send WhatsApp message and then show proceed payment button
                        await proceedToPayment();
                      },
                      child: Text("Connect via WhatsApp"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(180, 50),
                        backgroundColor: Colors.green,
                        textStyle: TextStyle(fontSize: 20),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),

                  // Proceed to Payment Button (Only after WhatsApp message is sent)
                  if (isWhatsAppMessageSent)
                    ElevatedButton(
                      onPressed: () {
                        // Proceed to Razorpay (payment logic)
                      },
                      child: Text("Proceed to Payment"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(180, 50),
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
    );
  }
}
