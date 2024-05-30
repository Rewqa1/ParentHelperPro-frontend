import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;

  const LoginButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth - 15;
    final buttonHeight = 40.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0), 
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          padding: const EdgeInsets.all(8.0), 
          decoration: BoxDecoration(
            color: Color(0xFF007BED),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              "Вход",
              style: TextStyle(
                color: Color(0xFF00E7FD),
                fontFamily: 'Montserrat',
                fontSize: 19.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}