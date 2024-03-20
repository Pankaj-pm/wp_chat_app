import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wp_chat_app/chat_page.dart';
import 'package:wp_chat_app/login_page.dart';
import 'package:wp_chat_app/model/auth_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cu = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("user").get().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavigationDrawer(
        children: [
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
          ),
          ListTile(
            onTap: () async {
              AuthUser user = AuthUser(name: "abc");
              FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(
                    user.toJson(),
                  );
            },
            title: Text("Edit Name"),
          )
        ],
      ),
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("user").snapshots(),
          builder: (context, snapshot) {
            var list = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                var data = item.data() as Map<String, dynamic>;
                return ListTile(
                  onTap: () {

                    Get.to(() => ChatPage(),arguments: {
                      "id":item.id,
                      "email":data["email"],
                    });
                  },
                  title: Text("${data["email"]}"),
                );
              },
            );
          }),
    );
  }
}
