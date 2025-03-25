// lib/ui/tabs/contact/contact_info_card.dart
import 'package:flutter/material.dart';

class ContactInfoCard extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final bool isMobile;
  final bool isDesktop;

  const ContactInfoCard({
    required this.name,
    required this.phone,
    required this.email,
    this.isMobile = false,
    this.isDesktop = false,
    Key? key,
  }) : super(key: key);

  @override
  _ContactInfoCardState createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<ContactInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = widget.isMobile 
        ? MediaQuery.of(context).size.width * 0.8 
        : widget.isDesktop 
            ? 350.0 
            : 300.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: cardWidth,
        constraints: BoxConstraints(
          minHeight: widget.isMobile ? 160.0 : 180.0,
          maxHeight: widget.isDesktop ? 220.0 : 200.0,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 0.0 : 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: _isHovered
              ? LinearGradient(
                  colors: [
                    Colors.blueGrey.withOpacity(0.7),
                    Colors.blueAccent.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.blueGrey.withOpacity(0.5),
                    Colors.blueGrey.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.3 : 0.2),
              blurRadius: _isHovered ? 10.0 : 5.0,
              spreadRadius: _isHovered ? 2.0 : 1.0,
              offset: Offset(0.0, _isHovered ? 3.0 : 1.0),
            )
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {}, // Add functionality if needed
            child: Padding(
              padding: EdgeInsets.all(widget.isDesktop ? 24.0 : 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: widget.isDesktop ? 28.0 : (widget.isMobile ? 20.0 : 24.0),
                      fontWeight: FontWeight.bold,
                      color: _isHovered ? Colors.white : Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12.0),
                  
                  // Phone
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Phone: ${widget.phone}',
                      style: TextStyle(
                        fontSize: widget.isDesktop ? 20.0 : (widget.isMobile ? 16.0 : 18.0),
                        color: _isHovered ? Colors.white : Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  
                  // Email (with proper constraints)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Email: ${widget.email}',
                      style: TextStyle(
                        fontSize: widget.isDesktop ? 20.0 : (widget.isMobile ? 16.0 : 18.0),
                        color: _isHovered ? Colors.white : Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  
                  if (widget.isDesktop) const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}