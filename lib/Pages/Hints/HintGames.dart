import 'package:flutter/material.dart';

class HintGames extends StatelessWidget {
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
                    'Игры',
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
                'Игры играют важную роль в развитии детей, поэтому важно выбирать такие игры, которые способствуют их физическому, эмоциональному и когнитивному развитию. Организуйте игровое пространство, где ребенок может свободно и безопасно исследовать и экспериментировать. Стимулируйте их фантазию и творческое мышление, предлагая игры, которые включают ролевые элементы или решение различных задач. Не забывайте также о важности совместных игр с ребенком. Участвуйте активно в их игровых процессах, что не только укрепит вашу связь, но и поможет ребенку усвоить социальные навыки и учиться сотрудничать с другими. Важно создавать атмосферу, где игры становятся возможностью для учебы и развития, а также временем, которое проводится с пользой и удовольствием для обоих.', // Текст публикации
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
