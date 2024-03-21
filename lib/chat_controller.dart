import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wp_chat_app/fs_model.dart';

class ChatController extends GetxController {
  String? id;
  String? senderId;
  String? email;
  String? chatRoomId;

  TextEditingController chatMsg = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      id = Get.arguments["id"];
      email = Get.arguments["email"];
      chatRoomId = Get.arguments["roomId"];
    }
    senderId= FirebaseAuth.instance.currentUser?.uid ?? "";
    // chatRoomId="$senderId-$id";
  }
}
