import 'package:flutter/material.dart';

class HintArt extends StatelessWidget {
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
                    'Творческие способности',
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
'Развитие творческих способностей у детей играет важную роль в их всестороннем развитии. Важно создать для ребенка подходящую среду, где он может свободно экспериментировать и выражать свои идеи. Поддерживайте интересы ребенка к различным видам творчества, будь то рисование, лепка, музыка, танцы или литературное творчество. Предоставляйте доступ к материалам и инструментам для творческой деятельности, стимулируя его фантазию и творческий потенциал. Важно учитывать индивидуальные предпочтения ребенка и не ограничивать его в выборе творческих занятий. Поощряйте и поддерживайте его усилия, независимо от их результатов, чтобы помочь ему развивать самооценку и уверенность в своих способностях. Создавайте совместные проекты и задания, где ребенок может проявить свое творческое мышление и работать в команде с другими детьми. Важно также обсуждать с ребенком его творческие идеи, помогая ему расширять горизонты и находить новые способы самовыражения.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
