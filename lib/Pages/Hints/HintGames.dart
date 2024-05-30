import 'package:flutter/material.dart';

class HintGames extends StatelessWidget {

  final String userName = "Александра";
  final String userSurname = "Хилько";
  final String postTitle = "Ребенок ест из миски собаки: Какие меры предпринять и как избежать подобных ситуаций";
  final String postContent = "Для родителей ничто не может быть более тревожным, чем увидеть, как их ребенок ест из миски собаки. Это момент, когда всплывают вопросы о гигиене, безопасности и здоровье. Но важно сохранять спокойствие и принимать необходимые меры для предотвращения подобных ситуаций в будущем. Немедленные действия: Если вы заметили, что ваш ребенок ест из миски собаки, срочно остановите его и вымойте руки ребенка теплой водой и мылом. Объясните ему, что миска собаки предназначена для питомца, а не для людей, и объясните, почему это не безопасно. Гигиенические меры: После случая с миской собаки очень важно обеспечить чистоту и гигиену у вашего ребенка. ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(postTitle),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$userName $userSurname',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  postContent,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
