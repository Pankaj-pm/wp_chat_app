import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            decoration: InputDecoration(
              hintText: "Email"
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: password,
            decoration: InputDecoration(
              hintText: "Password"
            ),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async{

                    try{
                      UserCredential user=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                      print("user Login==> ${user.user}");

                    }on FirebaseAuthException catch (e){
                      print(e.code);
                      print(e.message);
                    }
                  },
                  child: Text("Login"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: ()  async{
                    UserCredential user=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
                    print("user==> ${user.user}");
                  },
                  child: Text("Register"),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async{
              // UserCredential user=await FirebaseAuth.instance.signInAnonymously();
              // print("user.user ===> ${user.user}");

              //gradlew signingReport (to get  SHA-1 key and add this key to your firebase console)
              //keytool -list -v -keystore "C:\Users\dhyey\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

              var google=await GoogleSignIn().signIn();
              print("object $google");
            },
            child: Text("Login with Google"),
          )
        ],
      ),
    );
  }
}
