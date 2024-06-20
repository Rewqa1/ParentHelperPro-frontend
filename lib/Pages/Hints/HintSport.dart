import 'package:flutter/material.dart';

class HintSport extends StatelessWidget {
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
                    'Спорт',
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
                'Спорт играет важную роль в физическом и эмоциональном развитии детей. Важно поддерживать интерес ребенка к спортивным занятиям, предлагая ему разнообразные виды активности, которые соответствуют его возрасту и интересам. Участие в спорте помогает детям развивать координацию, гибкость и выносливость, а также укреплять иммунную систему и улучшать самочувствие. Организуйте регулярные тренировки или занятия по выбранному виду спорта, чтобы дети могли улучшать свои спортивные навыки и достигать новых целей. Важно также учить детей важности справедливости в спорте, учитывая чувства других участников и уважая правила игры. Спортивные занятия также могут стать отличным способом для семейного времени, где родители и дети могут вместе заниматься физическими упражнениями и укреплять взаимоотношения.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
