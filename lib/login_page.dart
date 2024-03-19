import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wp_chat_app/fs_model.dart';
import 'package:wp_chat_app/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            decoration: InputDecoration(hintText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: password,
            decoration: InputDecoration(hintText: "Password"),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: email.text, password: password.text);
                      FsModel().addUser(user.user);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      print(e.message);
                    }
                  },
                  child: Text("Login"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    UserCredential user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: email.text, password: password.text);
                    FsModel().addUser(user.user);
                  },
                  child: Text("Register"),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              // UserCredential user=await FirebaseAuth.instance.signInAnonymously();
              // print("user.user ===> ${user.user}");

              //gradlew signingReport (to get  SHA-1 key and add this key to your firebase console)
              //keytool -list -v -keystore "/Users/rasher/.android/debug.keystore" -alias androiddebugkey -storepass android -keypass android
              var cu = FirebaseAuth.instance.currentUser;
              print(cu);
              if (cu != null) {
                print("Already Login");
              } else {
                var google = await GoogleSignIn().signIn();
                var auth = await google?.authentication;
                var credential = GoogleAuthProvider.credential(accessToken: auth?.accessToken, idToken: auth?.idToken);
                var data = await FirebaseAuth.instance.signInWithCredential(credential);
                print(data);
                FsModel().addUser(data.user);

                print(google?.displayName);
                print(google?.photoUrl);

                print("object $google");
              }
            },
            child: Text("Login with Google"),
          )
        ],
      ),
    );
  }
}
