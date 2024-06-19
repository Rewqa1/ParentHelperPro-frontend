// main.dart

import 'package:flutter/material.dart';
import 'package:PHelperPro/Pages/Home/HomePage.dart';
import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PHelperPro/djangoRequest.dart' as djangoRequest;

AppMetricaConfig get _config =>
    const AppMetricaConfig('a6c7e534-e120-4de9-b905-4f9045bb7f59', logs: true);

Future<void> main() async {
  AppMetrica.runZoneGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    AppMetrica.activate(_config);
    AppMetrica.reportAppOpen('https://appmetrica.yandex.com');

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Waiting for login status...');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          print('Error checking login status: ${snapshot.error}');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: Text('Ошибка при проверке статуса авторизации')),
            ),
          );
        } else {
          final bool isLoggedIn = snapshot.data as bool;
          print('Login status: $isLoggedIn');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? HomePage() : LoginPage(),
          );
        }
      },
    );
  }
  
  Future<bool> _checkLoginStatus() async { //Возвращение false ведет к бесконечной загрузке
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && refreshToken != null) {
      print('Tokens found: accessToken = $accessToken, refreshToken = $refreshToken');
      final isValid = await djangoRequest.verifyToken(accessToken); //Проверка токена
      if (!isValid) {
        print('Access token is not valid. Refreshing token...');
        try {
          await djangoRequest.refreshToken();
          print('Token refreshed successfully.');
          return true;
        } catch (e) {
          print('Error refreshing token: $e');
          return false;
        }
      }
      print('Access token is valid');
      return true;
    }
    print('No tokens found.');
    return false;
  }
}
