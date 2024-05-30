import 'dart:convert';
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
  final emailController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    final lastName = lastNameController.text;
    final firstName = firstNameController.text;
    final username = loginController.text;
    final password = passwordController.text;
    final email = emailController.text;

    try {
      final url = Uri.parse('http://195.10.205.87:8000/register/users/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        print(response.statusCode);
        _showErrorDialog(context, 'Ошибка при регистрации');
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
          onTap: (){
            FocusScope.of(context).unfocus();
          },      
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  IconButton(
                    icon: backArrowIcon,
                    onPressed: () {
                      AppMetrica.reportEvent('RegisterPageBackToLoginPage');
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 17,),
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
                controller: emailController,
                hintText: 'Почта',
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
                controller: passwordController,
                hintText: 'Пароль',
                initialObscureText: true,
              ),
              const SizedBox(height: 40),
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
