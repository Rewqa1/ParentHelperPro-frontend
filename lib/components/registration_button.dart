import 'package:flutter/material.dart';

class RegButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const RegButton({Key? key, required this.onTap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth - 15;
    final buttonHeight = 40.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0), // Исправлено значение отступа
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          padding: const EdgeInsets.all(8.0), // Исправлено значение отступа
          decoration: BoxDecoration(
            color: Color(0xFFE09B58),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFFFFFFB0),
                fontSize: 19.0,
              ),
            ),
          ),
        ),  
      ),
    );
  }
}