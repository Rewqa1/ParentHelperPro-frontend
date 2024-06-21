import 'package:flutter/material.dart';

class HintFriends extends StatelessWidget {
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
                    'Друзья детей',
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
                'Дружба играет важную роль в жизни детей, поскольку способствует их эмоциональному, социальному и когнитивному развитию. Важно поддерживать положительные дружеские отношения, учить детей уважать чувства других и быть терпимыми к различиям. Помогайте детям развивать навыки коммуникации и сотрудничества, поощряя их участие в групповых занятиях и играх. Обеспечивайте безопасное окружение для дружеских встреч и игр, где дети могут общаться и развивать эмпатию и социальные навыки. Поддерживайте интересы и хобби детей, которые могут стать основой для формирования долгосрочных дружеских отношений. Важно также обучать детей разрешать конфликты мирным путем и быть открытыми к новым знакомствам и переживаниям.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
