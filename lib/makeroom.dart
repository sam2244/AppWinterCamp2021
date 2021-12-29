
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';


class MakeroomPage extends StatefulWidget {
  MakeroomPageState createState() => MakeroomPageState();
}

class MakeroomPageState extends State<MakeroomPage > {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _titlecontroller = TextEditingController();
  final _maxnumcontroller = TextEditingController();
  final _maxseccontroller = TextEditingController();
  final int _maxnum = 2;
  final int _maxsec = 60;
  final int _category = 0;
  final List maxnumdropbox = [
    {"code": "2", "title": "2명"},
    {"code": "3", "title": "3명"},
    {"code": "4", "title": "4명"},
  ];

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
              child: Text(''),
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
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titlecontroller,
                        decoration: const InputDecoration(
                          hintText: '방 이름',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '방 이름을 다시 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(width: 20),
                      TextFormField(
                        controller: _maxnumcontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '방 최대인원 (2-4(명))',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || int.parse(value) < 2 || int.parse(value) > 4) {
                            return '2-4 사이의 숫자를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(width: 20),
                      TextFormField(
                        controller: _maxseccontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '인당 최대 말하기 시간 (30-300(초))',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || int.parse(value) < 30 || int.parse(value) > 300) {
                            return '30-300 사이의 숫자를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                CustomRadioButton(
                    buttonLables: [
                      "상담",
                      "면접",
                      "토론",
                      "스터디",
                      "만남",
                      "수다",
                    ],
                    buttonValues: [
                      0,
                      1,
                      2,
                      3,
                      4,
                      5,
                    ],
                    defaultSelected: 0,
                    radioButtonValue: (value) => print(value),
                    //value = _category,
                    unSelectedColor: Theme.of(context).canvasColor,
                    selectedColor: Theme.of(context).primaryColor,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // = _category;
                      await addRoom(_titlecontroller.text, int.parse(_maxnumcontroller.text), int.parse(_maxseccontroller.text), await _Category(_category));
                      _titlecontroller.clear();
                      _maxnumcontroller.clear();
                      _maxseccontroller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add_rounded),
                      SizedBox(width: 4),
                      Text('방만들기'),
                    ],
                  ),
                ),
              ],
            ),

          ),
      ),
    );
  }

  Future addRoom(String title, int maxnum, int maxsec, String category) async {
    await FirebaseFirestore.instance.collection("rooms").add({
      "title": title,
      "maxnum": maxnum,
      'maxsec': maxsec,
      "category": category,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }
  Future<String> _Category(int index) async {
    String categorytext ="";
    if(index == 0){
      categorytext = "상담";
    }
    else if(index == 1){
      categorytext = "면접";
    }
    else if(index == 2){
      categorytext = "토론";
    }
    else if(index == 3){
      categorytext = "스터디";
    }
    else if(index == 4){
      categorytext= "만남";
    }
    else if(index == 5){
      categorytext = "수다";
    }
    return categorytext;
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
      Navigator.pushNamed(context, '/mypage',
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future signOut() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    await auth.signOut();
    uid = "";
    uid_google = "";
    name_user = "";
    email_user = "";
    url_user = "";
  }
}



