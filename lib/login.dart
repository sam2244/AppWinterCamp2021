import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String uid = "";
String uid_google = "";
String name_user= "";
String email_user = "";
String url_user = "";

Future<UserCredential> signInWithAnonynous() async {

  return FirebaseAuth.instance.signInAnonymously();
}
Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _flag = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0,160.0,50.0,10.0),
              child: Column(
                children: <Widget>[
                  //Image.asset('assets/chat.png'),
                  const SizedBox(height: 10.0),
                  Text('Winter App', style: TextStyle(
                    fontSize: 40,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Colors.blue[500]!,
                  ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
            const SizedBox(height: 120.0),

            Padding(
              padding: const EdgeInsets.fromLTRB(50.0,10.0,50.0,50.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('Google Login',style: TextStyle(
                          color: Colors.white,
                        ),),

                        onPressed: ()  async{
                          await signInWithGoogle();
                          setUserinfo();
                          setState(() => _flag = !_flag);
                          style: ElevatedButton.styleFrom(
                            primary: _flag ? Colors.blue : Colors.teal, // This is what you need!
                          );
                          Navigator.pushNamed(context, '/home',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future setUserinfo() async{

    final User? user_login = FirebaseAuth.instance.currentUser;
    final firestoreInstance = FirebaseFirestore.instance;
    final QuerySnapshot result =
    await firestoreInstance.collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;
    List<String> localUserId = [];
    documents.forEach((data) {
      localUserId.add(data['uid']);
    });
    if(!(user_login!.isAnonymous)){
      if(!localUserId.contains(user_login.uid)) {
        await FirebaseFirestore.instance.collection("users").add({
          "email": user_login.email,
          "name": user_login.displayName,
          "uid": user_login.uid,
        });
        name_user= user_login.displayName!;
        url_user = user_login.photoURL!;
        email_user = user_login.email!;
        uid_google = user_login.uid;
      }
      name_user= user_login.displayName!;
      url_user = user_login.photoURL!;
      email_user = user_login.email!;
      uid_google = user_login.uid;
    }

    else{
      if(!localUserId.contains(user_login.uid)) {
        await FirebaseFirestore.instance.collection("users").add({
          "uid": user_login.uid,
        });
      }
      name_user= user_login.uid;
      url_user =  'http://handong.edu/site/handong/res/img/logo.png';
      email_user= "Anonymous";
    }
  }
}