import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wp_chat_app/fs_model.dart';

class ChatController extends GetxController {
  String? id;
  String? senderId;
  String? email;
  RxString chatRoomId = "".obs;

  TextEditingController chatMsg = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      id = Get.arguments["id"];
      email = Get.arguments["email"];

    }
    senderId = FirebaseAuth.instance.currentUser?.uid ?? "";

    chatRoomId.value = "$senderId-$id";
  }
}
