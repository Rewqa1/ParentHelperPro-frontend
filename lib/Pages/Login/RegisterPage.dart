import 'package:PHelperPro/components/icon.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/registration_button.dart';
import 'package:flutter/material.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

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
                  AppMetrica.reportEvent('RegistrationButton');
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
