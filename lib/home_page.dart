import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wp_chat_app/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cu = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(children: [
        UserAccountsDrawerHeader(
          accountName: Text(cu?.displayName ?? ""),
          accountEmail: Text(cu?.email ?? ""),
        ),
        ListTile(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ));
          },
          title: Text("Logout"),
        )
      ]),
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) => Text("data"),
      ),
    );
  }
}
