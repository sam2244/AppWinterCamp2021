import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';
import 'colors.dart';


class MakeroomPage extends StatefulWidget {
  MakeroomPageState createState() => MakeroomPageState();
}

class MakeroomPageState extends State<MakeroomPage > {
  int _selectedbutton = 0;
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _titlecontroller = TextEditingController();
  final _maxnumcontroller = TextEditingController();
  final _maxseccontroller = TextEditingController();
  final _hashtagcontroller = TextEditingController();
  final int _maxnum = 2;
  final int _maxsec = 60;
  final int _category = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.close),
          color: OnBackground,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('방 만들기',
            style: TextStyle(
            color: OnBackground
            )
        ),
        actions: <Widget>[
          new TextButton(
            style: TextButton.styleFrom(
              primary: OnBackground,
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: () async {
              //print(_selectedbutton);
              if (_formKey.currentState!.validate()) {
                await addRoom(
                    _titlecontroller.text,
                    int.parse(_maxnumcontroller.text),
                    int.parse(_maxseccontroller.text),
                    await _Category(_category),
                    _hashtagcontroller.text
                );
                _titlecontroller.clear();
                _maxnumcontroller.clear();
                _maxseccontroller.clear();
              }
            },
            child: const Text('완료'),
          ),
        ],
        backgroundColor: Bar,
        centerTitle: true,
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
                      const SizedBox(height: 20),
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
                        radioButtonValue: (value) => _selectedbutton,
                        //_selectedbutton = value.checked,
                        unSelectedColor: Theme.of(context).canvasColor,
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _hashtagcontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '예시) #사랑 #믿음 #소망',
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
              ],
            ),
          ),
      ),
    );
  }

  Future addRoom(String title, int maxnum, int maxsec, String category, String hashtag) async {
    await FirebaseFirestore.instance.collection("rooms").add({
      "title": title,
      "maxnum": maxnum,
      'maxsec': maxsec,
      "category": category,
      "hashtag": hashtag,
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



