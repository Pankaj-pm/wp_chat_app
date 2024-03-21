import 'package:cloud_firestore/cloud_firestore.dart';
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
            child: StreamBuilder<QuerySnapshot>(
                // stream: FirebaseFirestore.instance.collection("${controller.senderId}-${controller.id}").doc("message").snapshots(),
                stream: FirebaseFirestore.instance.collection("chat").doc(controller.chatRoomId??"").collection("messages").snapshots(),
                builder: (context, snapshot) {
                  List<QueryDocumentSnapshot> data = snapshot.data?.docs??[];
                  print("data => $data");
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index].data() as Map<String,dynamic>;
                      // var item = data[index].data();
                      return ListTile(
                        onTap: () async{
                          // var future = await FirebaseFirestore.instance.collection(controller.chatRoomId??"").doc().get();
                          var future = await FirebaseFirestore.instance.collection("chat").doc(controller.chatRoomId??"").collection("messages").get();
                          // var msg=await future.reference.collection("messages").get();
                          print(controller.chatRoomId);
                          // var future2 = future as Map<String,dynamic>;
                          print(future.docs);
                          // print(msg.docs);
                        },
                        title: Text(item["msg"]),
                      );
                    },
                  );
                }),
          ),
          TextFormField(
            controller: controller.chatMsg,
            onFieldSubmitted: (value) {
              var currentUser = FirebaseAuth.instance.currentUser;
              var uid = currentUser?.uid ?? "";
              FsModel().chat(uid, controller.id ?? "", currentUser?.email ?? "", controller.email ?? "",
                  controller.chatMsg.text);
            },
            decoration: InputDecoration(
                hintText: "Enter message",
                suffixIcon: IconButton(
                    onPressed: () {
                      var currentUser = FirebaseAuth.instance.currentUser;
                      var uid = currentUser?.uid ?? "";
                      FsModel().chat(uid, controller.id ?? "", currentUser?.email ?? "", controller.email ?? "",
                          controller.chatMsg.text);
                    },
                    icon: Icon(Icons.send))),
          ),
        ],
      ),
    );
  }
}
