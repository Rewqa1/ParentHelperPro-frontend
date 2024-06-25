import 'dart:convert';
import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:PHelperPro/Pages/Home/HomePage.dart';
import 'package:PHelperPro/components/icon.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/registration_button.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final secretWordController = TextEditingController();
  
  Future<void> registerUser(BuildContext context) async {
    final lastName = lastNameController.text.trim();
    final firstName = firstNameController.text.trim();
    final username = loginController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final secretWord = secretWordController.text.trim();
    final email = emailController.text.trim();
    
    if (lastName.isEmpty || firstName.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty || secretWord.isEmpty || email.isEmpty) {
      _showErrorDialog(context, 'Пожалуйста, заполните все необходимые поля');
      return;
    }

    try {
      final url = Uri.parse('http://195.10.205.87:8000/register/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'password': password,
          'secret_word': secretWord,
          'confirm_password': confirmPassword
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        _showErrorDialog(context, 'Ошибка при регистрации, проверьте поля на корректность');
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: backArrowIcon,
                          onPressed: () {
                            AppMetrica.reportEvent('RegisterPageBackToLoginPage');
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
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
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Регистрация',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 35),
                LoginTextField(
                  controller: lastNameController,
                  hintText: 'Фамилия',
                  initialObscureText: false,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: firstNameController,
                  hintText: 'Имя',
                  initialObscureText: false,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: loginController,
                  hintText: 'Логин',
                  initialObscureText: false,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: emailController,
                  hintText: 'Почта',
                  initialObscureText: false,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: secretWordController,
                  hintText: 'Секретное слово',
                  initialObscureText: false,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: passwordController,
                  hintText: 'Пароль',
                  initialObscureText: true,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: confirmPasswordController,
                  hintText: 'Подтвердите пароль',
                  initialObscureText: true,
                ),
                const SizedBox(height: 25),
                RegButton(
                  text: 'Зарегистрироваться',
                  onTap: () {
                    AppMetrica.reportEvent('Registration');
                    registerUser(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
