import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:PHelperPro/components/login_reg_textfield.dart';
import 'package:PHelperPro/components/login_button.dart';
import 'package:PHelperPro/components/registration_button.dart';
import 'package:PHelperPro/Pages/Login/RegisterPage.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(){}
  void registration(){}

  @override
  Widget build(BuildContext context){
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
          children: [
            const SizedBox(height: 0,),
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
            const SizedBox(height: 15,),
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
            // sign in button
            LoginButton(
              onTap: signUserIn,
            ),
            const SizedBox(height: 25),
            RegButton(
              text: 'Регистрация',
              onTap: () {
                AppMetrica.reportEvent('toRegistrationPage');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Забыли пароль?',
              style: TextStyle(
                color: Color(0xFF000000).withOpacity(0.5),
                fontSize: 15,
              ),
            )
          ],
        ),
        
      ),
      ),
      ),
    );
  }
}
