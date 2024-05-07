import 'package:flutter/material.dart';
import 'package:PHelperPro/Pages/Home/HomePage.dart';
import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}