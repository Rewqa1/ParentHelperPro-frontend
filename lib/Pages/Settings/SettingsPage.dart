import 'package:flutter/material.dart';
import 'package:PHelperPro/components/icon.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController(text: 'name');
  final TextEditingController _familyController = TextEditingController(text: 'family');
  final TextEditingController _loginController = TextEditingController(text: 'login');
  final TextEditingController _passwordController = TextEditingController(text: 'password');
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: backArrowIcon, // Путь к вашему изображению кнопки назад
          onPressed: () {
            AppMetrica.reportEvent('toHomePage');
            Navigator.pop(context); // вернуться на предыдущий экран
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/background.jpg'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFFFFCED4),
              ),
              child: Text('Изменить фото'),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Имя', _nameController),
            SizedBox(height: 16.0),
            _buildTextField('Фамилия', _familyController),
            SizedBox(height: 16.0),
            _buildTextField('Логин', _loginController),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
              ),
              child: Text('Сохранить изменения'),
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {

              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              child: Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
