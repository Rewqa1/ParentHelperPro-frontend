import 'package:flutter/material.dart';

class HintNutrition extends StatelessWidget {
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
                    'Питание',
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
'Правильное питание играет ключевую роль в здоровье и развитии детей. Важно убедиться, что рацион ребенка включает разнообразные продукты, богатые питательными веществами, такими как фрукты, овощи, белковые продукты, злаки и молочные продукты. Поощряйте детей есть регулярно и правильно — три основных приема пищи и два-три перекуса, состоящих из здоровых закусок. Обучите детей осознанному подходу к питанию, объясняя им важность балансировки питательных веществ и выбора полезных продуктов. Избегайте излишеств в потреблении сахара, соли и насыщенных жиров, стимулируя предпочтение натуральных и незагруженных химическими добавками продуктов. Помимо этого, создавайте положительную атмосферу за столом, где еда становится временем для семейных обсуждений и обмена впечатлениями. Важно учитывать индивидуальные предпочтения и потребности ребенка, поддерживая разнообразие в рационе и стимулируя интерес к новым продуктам и блюдам.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
