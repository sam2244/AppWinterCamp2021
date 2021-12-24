import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';


class MakeroomPage extends StatefulWidget {
  MakeroomPageState createState() => MakeroomPageState();
}

class MakeroomPageState extends State<MakeroomPage > {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Pages'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                signOut();
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Winter App"),
        centerTitle: true,
        actions: [
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedFontSize: 15,
        selectedIconTheme: IconThemeData(color: Color(0xFF03A9F4), size: 30),
        selectedItemColor: Color(0xFF03A9F4),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '방만들기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '전체 방 보기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '대기방',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: Container(
      ),
    );
  }
  void _onItemTapped(int index) {
    if(index == 0){
      Navigator.pushNamed(context, '/makeroom',
      );
    }
    else if(index == 1){
      Navigator.pushNamed(context, '/home',
      );
    }
    else if(index == 2){
      Navigator.pushNamed(context, '/chat',
      );
    }
    else if(index == 3){
      Navigator.pushNamed(context, '/mypage',
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }
  Future signOut() async {
    // Trigger the authentication flow
    final FirebaseAuth auth = await FirebaseAuth.instance;
    await auth.signOut();
    uid = "";
    uid_google = "";
    name_user = "";
    email_user = "";
    url_user = "";
  }
}



