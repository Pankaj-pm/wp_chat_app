import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            child: Obx(
              () {
                print("controller.chatRoomId.value  ${controller.chatRoomId.value}");
                return StreamBuilder<QuerySnapshot>(
                    // stream: FirebaseFirestore.instance.collection("${controller.senderId}-${controller.id}").doc("message").snapshots(),
                    stream: FirebaseFirestore.instance
                        .collection("chat")
                        .doc(controller.chatRoomId.value)
                        .collection("messages")
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<QueryDocumentSnapshot> data = snapshot.data?.docs ?? [];
                      print("data => $data");
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var item = data[index].data() as Map<String, dynamic>;
                          var isLoginUser = controller.senderId == item["sender_id"];
                          // var item = data[index].data();
                          return Align(
                            alignment: isLoginUser?Alignment.centerRight:Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(isLoginUser ? 20 : 0),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(isLoginUser ? 0 : 20),
                                  )),
                              child: InkWell(
                                onTap: () async {
                                  // var future = await FirebaseFirestore.instance.collection(controller.chatRoomId??"").doc().get();
                                  var future = await FirebaseFirestore.instance
                                      .collection("chat")
                                      .doc(controller.chatRoomId.value)
                                      .collection("messages")
                                      .get();
                                  // var msg=await future.reference.collection("messages").get();
                                  print(controller.chatRoomId);
                                  // var future2 = future as Map<String,dynamic>;
                                  print(future.docs);
                                  // print(msg.docs);
                                },
                                child: Text(item["msg"],style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            ),
          ),
          TextFormField(
            controller: controller.chatMsg,
            onFieldSubmitted: (value) {
              var currentUser = FirebaseAuth.instance.currentUser;
              var uid = currentUser?.uid ?? "";
              FsModel().chat(
                  uid, controller.id ?? "", currentUser?.email ?? "", controller.email ?? "", controller.chatMsg.text);
            },
            decoration: InputDecoration(
                hintText: "Enter message",
                suffixIcon: IconButton(
                    onPressed: () {
                      var currentUser = FirebaseAuth.instance.currentUser;
                      var uid = currentUser?.uid ?? "";
                      FsModel().chat(uid, controller.id ?? "", currentUser?.email ?? "", controller.email ?? "",
                          controller.chatMsg.text);
                      controller.chatMsg.clear();
                    },
                    icon: Icon(Icons.send))),
          ),
        ],
      ),
    );
  }
}
