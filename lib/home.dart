import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

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
        iconSize: 20,
        selectedFontSize: 12,
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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [
                0.8,
                0.99,
              ],
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).backgroundColor,
              ]),
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
            ],
          ),
        ),
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


class _CovidItemPanel extends StatefulWidget {
  _CovidItemPanel({required Key key, required this.title, required this.value, required this.textStyle}): super(key: key);

  String title;
  String value;
  TextStyle textStyle;

  @override
  _CovidItemPanelState createState() => _CovidItemPanelState();
}

class _CovidItemPanelState extends State<_CovidItemPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(10),
      height: 95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.7, 0.9],

              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withAlpha(180),
              ],
              tileMode: TileMode.repeated),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).backgroundColor,
                offset: const Offset(5, 5),
                blurRadius: 5,
                spreadRadius: 1),
          ]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              // "abasd",
              widget.value,
              style: widget.textStyle,
            ),
          )
        ],
      ),
    );
  }
}
class ScreenArgument{
  final int chartPlot1;
  final int chartPlot2;
  final int chartPlot3;
  ScreenArgument(this.chartPlot1, this.chartPlot2,this.chartPlot3);
}