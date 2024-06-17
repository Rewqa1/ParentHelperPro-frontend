import 'package:flutter/material.dart';
import '../Categorys/CategorysPage.dart';
import '../Home/HomePage.dart';
import '../Settings/SettingsPage.dart';
import '../Publications/NewPublicationPage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваш профиль'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        automaticallyImplyLeading: false, // убираем стрелку назад
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.settings),
            onPressed: () {
              AppMetrica.reportEvent('toSettingsPage');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/background.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Чуань Ци',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Цвет кнопки
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPublicationPage()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(height: 20),
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
          if (index == 0) {
            AppMetrica.reportEvent('toHomePage');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
          if(index == 1) {
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
}
