import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool initialObscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.initialObscureText,
  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscureText;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth - 30;
    final height = 35.0;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            width: width, 
            height: height, 
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5), 
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                fillColor: Color(0xFFD9D9D9),
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Color(0xFF000000).withOpacity(0.2)),
                suffixIcon: widget.initialObscureText
                    ? IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
