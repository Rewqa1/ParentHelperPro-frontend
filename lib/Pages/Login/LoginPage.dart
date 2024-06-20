import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PHelperPro/Pages/Home/HomePage.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/login_button.dart';
import 'package:PHelperPro/components/registration_button.dart';
import 'package:PHelperPro/Pages/Login/RegisterPage.dart';
import 'package:PHelperPro/Pages/Login/ForgotPasswordPage.dart';
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUserIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    try {
      final url = Uri.parse('http://195.10.205.87:8000/api/token/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseData['access']);
        await prefs.setString('refreshToken', responseData['refresh']);
        await prefs.setString('username', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showErrorDialog(context, 'Неверные учетные данные');
      }
    } catch (e) {
      _showErrorDialog(context, 'Произошла ошибка. Попробуйте снова.');
    }
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('ОК'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }


  void registration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(height: 0),
                Container(
                  width: 208,
                  height: 189,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 208,
                      height: 189,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Вход в систему',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 35),
                LoginTextField(
                  controller: usernameController,
                  hintText: 'Логин',
                  initialObscureText: false,
                ),
                const SizedBox(height: 45),
                LoginTextField(
                  controller: passwordController,
                  hintText: 'Пароль',
                  initialObscureText: true,
                ),
                const SizedBox(height: 55),
                LoginButton(
                  onTap: () {
                    signUserIn(context);
                  },
                ),
                const SizedBox(height: 25),
                RegButton(
                  text: 'Регистрация',
                  onTap: () {
                    registration(context);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    'Забыли пароль?',
                    style: TextStyle(
                      color: Color(0xFF000000).withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
