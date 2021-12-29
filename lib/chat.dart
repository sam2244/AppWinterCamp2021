import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'colors.dart';

bool isEdit = false;
TextEditingController _editingController =TextEditingController(text: initialText);
String initialText = "";

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String chats = "";
    String local_chats = "";
    final fb = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios_new_rounded),
          color: OnBackground,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('대화방',
            style: TextStyle(
                color: OnBackground
            )
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            color: OnBackground,
            onPressed: () {
              signOut();
              Navigator.pushNamed(context, '/login',);
            },
          ),
        ],
        backgroundColor: Bar,
        centerTitle: true,
      ),
      //backgroundColor: ChatBackground,
      backgroundColor: Background,
      body: Column(children: <Widget>[
          //Image.asset('assets/codelab.png'),
        const SizedBox(height: 8),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: fb.collection("chats").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                //   if (!(snapshot.hasError)) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    if ((snapshot.data?.docs[index]['userId'] == uid_google)) {
                      String chats = (snapshot.data?.docs[index]['text'])
                          .toString();
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                              child: Row(children: [
                                Text((snapshot.data?.docs[index]['name'])
                                    .toString()),
                                const SizedBox(width: 8),
                                isEdit ? Expanded(
                                  child: TextField(
                                    controller: TextEditingController(text: chats),
                                    onChanged: (newValue){
                                        local_chats = newValue;
                                      }
                                  ),
                                )
                                :Text(chats)
                              ]),
                            ),
                          ),
                          isEdit ?
                          Row(children: [
                            TextButton(
                              child: const Text('save'),
                              onPressed: () async {
                                await updateStatus(local_chats);
                                setState(() {
                                  isEdit = !isEdit;
                                });
                                //_showMyDialog();
                              },
                            ),
                          ]) : Row(children: [
                            IconButton(
                              icon: const Icon(
                                Icons.create,
                                semanticLabel: 'edit',
                              ),
                              onPressed: () async {
                                setState(() {
                                  isEdit = !isEdit;
                                });
                                //_showMyDialog();
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                semanticLabel: 'delete',
                              ),
                              onPressed: () async {
                                _showMyDialog();
                              },
                            ),
                          ])
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                              child: Row(children: [
                                Text((snapshot.data?.docs[index]['name'])
                                    .toString()),
                                const SizedBox(width: 8),
                                isEdit ? Text((snapshot.data?.docs[index]['text'])
                                    .toString()) : Text((snapshot.data?.docs[index]['text'])
                                    .toString())
                              ]),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: Colors.white,
                        hintText: '메세지를 입력하세요',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '메세지를 입력하세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: new Icon(Icons.arrow_upward),
                    color: Primary,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await addMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
  }

  Future addMessage(String text) async {
    await FirebaseFirestore.instance.collection("chats").add({
      "text": text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deletion Confirm Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure to delete the message?'),
                //Text('Would you like to confirm this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                print('Confirmed');
                final QuerySnapshot result = await FirebaseFirestore.instance
                    .collection('chats')
                    .get();
                final List<DocumentSnapshot> documents = result.docs;
                String targetDoc = "";
                String creatorUID = "";
                documents.forEach((data) {
                  if (data['email'] == email_user) {
                    targetDoc = data.id;
                    creatorUID = data['userId'];
                  }
                });
                if (creatorUID == uid_google) {
                  var firebaseUser = FirebaseAuth.instance.currentUser;
                  FirebaseFirestore.instance
                      .collection("chats")
                      .doc(targetDoc)
                      .delete()
                      .then((data) {
                    print("Deleted!");
                  });
                } else {
                  print("not matching the user id");
                  print(email_user);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future updateStatus(String text) async{
    final firestoreInstance = FirebaseFirestore.instance;
    final QuerySnapshot result =
    await firestoreInstance.collection('chats').get();
    final List<DocumentSnapshot> documents = result.docs;
    final User user_uid = FirebaseAuth.instance.currentUser!;
    String targetDoc = "";
    String creatorUID = "";
    documents.forEach((data) {if(data['userId'] == user_uid.uid) {targetDoc = data.id;}});
    //  modified_local =FieldValue.serverTimestamp();
    print(targetDoc);
    print(user_uid.uid);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("chats")
        .doc(targetDoc)
        .update({"text": text}).then((_) {
      print("success!");
    });

    // Navigator.pop(context);
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