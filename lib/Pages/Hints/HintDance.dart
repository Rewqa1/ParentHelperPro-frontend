import 'package:flutter/material.dart';

class HintDance extends StatelessWidget {
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
                    'Танцы',
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
'Танцы представляют собой отличный способ для детей не только выразить себя, но и развить физическую активность и координацию движений. Поддерживайте интерес ребенка к танцам, предлагая ему разнообразные стили и направления, которые соответствуют его возрасту и интересам. Это может включать классические танцы, современные стили, хип-хоп, бальные танцы и многие другие. Организуйте регулярные занятия или уроки танцев, где дети смогут развивать свои танцевальные навыки под руководством профессиональных инструкторов. Танцевальные занятия не только способствуют физическому развитию, но и помогают детям улучшать самооценку, выражать свои чувства и эмоции через движение. Создавайте позитивную атмосферу и поддерживайте ребенка в его танцевальных усилиях, поощряя его творческий подход к исполнению движений и развитию сценической уверенности. Важно также учитывать, что танцы могут быть отличной возможностью для семейного времяпрепровождения, где родители и дети могут учиться и развиваться вместе.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
