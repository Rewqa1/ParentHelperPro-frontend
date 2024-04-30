import 'package:PHelperPro/components/icon.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/registration_button.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // удалить тень под AppBar
        leading: IconButton(
          icon: backArrowIcon, // Путь к вашему изображению кнопки назад
          onPressed: () {
            Navigator.pop(context); // вернуться на предыдущий экран
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 47),
              Container(
                width: 208,
                height: 189,
                child: Center(
                  child: Image.asset(
                    'assets/logo.png', // Путь к вашему изображению логотипа
                    width: 208,
                    height: 189,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Регистрация',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 32,
                  fontFamily: 'Montserrat', // Только указываем семейство шрифта
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
                controller: passwordController,
                hintText: 'Пароль',
                initialObscureText: true,
              ),
              const SizedBox(height: 40),
              RegButton(
                text: 'Зарегистрироваться',
                onTap: () {
                  AppMetrica.reportEvent('Registration button');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}