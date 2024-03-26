import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wp_chat_app/chat_page.dart';
import 'package:wp_chat_app/login_page.dart';
import 'package:wp_chat_app/model/auth_user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  var cu = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
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
                    Get.to(() => ChatPage(), arguments: {
                      "id": item.id,
                      "email": data["email"],
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
