import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:wp_chat_app/chat_controller.dart';
import 'package:wp_chat_app/fs_model.dart';

class ChatPage extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.email ?? "")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Text("msg");
              },
            ),
          ),
          TextFormField(
            controller: controller.chatMsg,
            decoration: InputDecoration(
                hintText: "Enter message",
                suffixIcon: IconButton(
                    onPressed: () {
                      var currentUser = FirebaseAuth.instance.currentUser;
                      var uid = currentUser?.uid ?? "";
                      FsModel().chat(uid, controller.id ?? "", currentUser?.email ?? "", controller.chatMsg.text);
                    },
                    icon: Icon(Icons.send))),
          ),
        ],
      ),
    );
  }
}
