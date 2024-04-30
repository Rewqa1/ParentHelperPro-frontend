import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:PHelperPro/Pages/Login/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:PHelperPro/Pages/Home/HomePage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';




void main()  {
  AppMetrica.activate(AppMetricaConfig("a6c7e534-e120-4de9-b905-4f9045bb7f59"));
  AppMetrica.reportEvent('My first AppMetrica event!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEventWithJson('App Open', '{"key1": "value1", "key2": "value2"}');
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

