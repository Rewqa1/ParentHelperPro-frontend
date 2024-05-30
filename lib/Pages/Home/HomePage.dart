import 'package:flutter/material.dart';
import '../Categorys/CategorysPage.dart';
import '../Profile/ProfilePage.dart';
import '../Hints/HintGames.dart';
import '../Hints/HintSport.dart';
import '../Hints/HintParenting.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        automaticallyImplyLeading: false, // убираем стрелку назад
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () {
              AppMetrica.reportEvent('toProfilePage');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Советы от приложения',
              style: TextStyle(fontSize: 24, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: [
                  hitImg(context, 'assets/Images/hitImg1.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg2.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg3.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg4.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg5.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg6.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg7.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg8.png', HintGames()),
                  hitImg(context, 'assets/Images/hitImg9.png', HintGames()),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            AppMetrica.reportEvent('toCategorysPage');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategorysPage()),
            );
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  Widget hitImg(BuildContext context, String imagePath, Widget route) {
    return GestureDetector(
      onTap: () {
        AppMetrica.reportEvent('toGamesPage');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}