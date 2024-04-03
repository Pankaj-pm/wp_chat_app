import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wp_chat_app/chat_page.dart';
import 'package:wp_chat_app/login_page.dart';
import 'package:wp_chat_app/main.dart';
import 'package:wp_chat_app/model/auth_user.dart';
import 'package:wp_chat_app/user_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var cu = FirebaseAuth.instance.currentUser;
  String? filePath;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("user").get().then((value) {});
    WidgetsBinding.instance.addObserver(this);

    FirebaseMessaging.onMessage.listen(
      (event) {
        showLocalNotification(event);
        print("FirebaseMessaging.onMessage $event");
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(FirebaseAuth.instance.currentUser?.uid ?? "");
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
        .update({"online": state == AppLifecycleState.resumed});
    print("state >>> $state");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: double.infinity,
        child: NavigationDrawer(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: InkWell(
                onTap: () async {
                  var pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickImage != null) {
                    filePath = pickImage?.path ?? '';
                    var readAsBytes = await pickImage.readAsBytes();
                    var base64encode = base64Encode(readAsBytes);

                    FirebaseFirestore.instance.collection("user").doc(cu?.uid ?? "").update({
                      "img": base64encode,
                    });
                  }

                  setState(() {});
                },
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection("user").doc(cu?.uid ?? "").snapshots(),
                  builder: (context, snapshot) {
                    String? img = (snapshot.data?.data() as Map<String,dynamic>?)?["img"];
                    Uint8List? decodeimg;
                    if(img!=null){
                      decodeimg = base64Decode(img);
                    }

                    return CircleAvatar(
                      backgroundImage: decodeimg != null ? MemoryImage(decodeimg) : null,
                    );
                  }
                ),
              ),
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
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showLocalNotification2();
              },
              icon: Icon(Icons.notification_add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chat")
              .where("email", isNotEqualTo: FirebaseAuth.instance.currentUser?.email ?? "")
              .snapshots(),
          builder: (context, snapshot) {
            var list = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                var data = item.data() as Map<String, dynamic>;
                return ListTile(
                  onTap: () {
                    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";

                    String id = (uid == data["receiverId"]) ? data["senderId"] : data["receiverId"];
                    String email = (uid == data["receiverId"]) ? data["sender_email"] : data["email"];

                    Get.to(() => ChatPage(), arguments: {
                      "id": id,
                      "email": email,
                      "roomId": item.id,
                    });
                  },
                  title: Text("${data["email"]}"),
                  subtitle: Text("${data["last_msg"]}"),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showLocalNotification();
          // Get.to(() => UserListPage());
        },
      ),
    );
  }
}
