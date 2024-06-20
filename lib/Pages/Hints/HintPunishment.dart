import 'package:flutter/material.dart';

class HintPunishment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('советы от приложения'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Навигация на другую страницу профиля
              },
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Text(
                    'Наказание детей',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
'Наказание детей — это чувствительная тема, требующая сбалансированного подхода. Важно помнить, что наказание должно быть справедливым, пропорциональным и обучающим, а не унизительным или физически наказывающим. Вместо того чтобы фокусироваться на негативных последствиях, стимулируйте развитие положительного поведения через поощрение и признание усилий ребенка. Установите четкие правила и ожидания, объясните детям их значения и последствия. Важно предлагать альтернативы ненадобности наказания, используя дискуссионные ситуации, возникающие в обществе',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
