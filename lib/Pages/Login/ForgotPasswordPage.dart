import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:PHelperPro/components/icon.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/registration_button.dart';
import 'package:PHelperPro/djangoRequest.dart';
import 'package:PHelperPro/Pages/Login/LoginPage.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final usernameController = TextEditingController();
  final secretWordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  Future<void> updateUserPassword(BuildContext context) async {
    final username = usernameController.text;
    final secretWord = secretWordController.text;
    final newPassword = newPasswordController.text;
    final confirmNewPassword = confirmNewPasswordController.text;

    try {
      if (await passwordReset(username, secretWord, newPassword, confirmNewPassword)) {
        _showSuccessDialog(context, 'Пароль успешно изменен');
      } else {
        _showErrorDialog(context, 'Не удалось изменить пароль, проверьте введенные данные и попробуйте снова');
      }
    } catch (e) {
      _showErrorDialog(context, 'Произошла ошибка, попробуйте снова');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Успешное изменение пароля'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('ОК'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          )
        ],
      ),
    );
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
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: backArrowIcon,
                          onPressed: () {
                            AppMetrica.reportEvent('ForgotPasswordPageBackToLoginPage');
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
                  'Восстановление пароля',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 35),
                LoginTextField(
                  controller: usernameController,
                  hintText: 'Логин',
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
                  controller: newPasswordController,
                  hintText: 'Новый пароль',
                  initialObscureText: true,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: confirmNewPasswordController,
                  hintText: 'Подтвердите новый пароль',
                  initialObscureText: true,
                ),
                const SizedBox(height: 40),
                RegButton(
                  text: 'Изменить пароль',
                  onTap: () {
                    AppMetrica.reportEvent('ForgotPasswordButton');
                    updateUserPassword(context);
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