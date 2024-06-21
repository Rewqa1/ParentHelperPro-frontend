import 'package:flutter/material.dart';

class HintIllness extends StatelessWidget {
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
                    'Детская простуда',
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
'Детская простуда — распространенное явление, требующее внимательного и профессионального подхода. Важно помнить, что профилактика играет ключевую роль в предотвращении заболеваний. Обучите детей правилам гигиены, таким как регулярное мытье рук и избегание контакта с больными людьми в период эпидемий. Если ребенок заболел, уделяйте особое внимание его состоянию и обеспечивайте комфортное окружение для выздоровления. Поддерживайте детей достаточным отдыхом и увлажнением воздуха в помещении. Обратитесь к врачу при первых признаках болезни, чтобы получить рекомендации по лечению и предотвращению осложнений. Используйте безопасные и эффективные методы для снятия симптомов простуды, такие как парацетамол для снижения температуры и горячие напитки для облегчения горла. Важно оказывать поддержку и заботу ребенку во время болезни, чтобы ускорить его выздоровление и предотвратить распространение инфекции среди семьи.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
