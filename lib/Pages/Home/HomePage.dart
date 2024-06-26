import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Categorys/CategorysPage.dart';
import '../Profile/ProfilePage.dart';
import '../Hints/HintGames.dart';
import '../Hints/HintLearning.dart';
import '../Hints/HintSport.dart';
import '../Hints/HintNutrition.dart';
import '../Hints/HintPunishment.dart';
import '../Hints/HintFriends.dart';
import '../Hints/HintIllness.dart';
import '../Hints/HintDance.dart';
import '../Hints/HintArt.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

Future<bool> checkAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }
  
class HomePage extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () async {
              bool hasAccessToken = await checkAccessToken();
              if (hasAccessToken) {
                AppMetrica.reportEvent('toProfilePage');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
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
                  hitImg(context, 'assets/Images/hitImg2.png', HintLearning()),
                  hitImg(context, 'assets/Images/hitImg3.png', HintSport()),
                  hitImg(context, 'assets/Images/hitImg4.png', HintNutrition()),
                  hitImg(context, 'assets/Images/hitImg5.png', HintPunishment()),
                  hitImg(context, 'assets/Images/hitImg6.png', HintFriends()),
                  hitImg(context, 'assets/Images/hitImg7.png', HintIllness()),
                  hitImg(context, 'assets/Images/hitImg8.png', HintDance()),
                  hitImg(context, 'assets/Images/hitImg9.png', HintArt()),
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