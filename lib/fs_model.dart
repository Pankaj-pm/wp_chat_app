import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:wp_chat_app/model/auth_user.dart';
import 'package:wp_chat_app/model/chat_model.dart';

class FsModel {
  static final FsModel _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }

  void addUser(User? user) async {
    var token = await FirebaseMessaging.instance.getToken();
    print(token);
    AuthUser authUser = AuthUser(
      name: user?.displayName ?? "",
      number: "",
      email: user?.email ?? "",
      img: "",
      lastMsg: "",
      lastTime: "",
      online: true,
      status: "",
      fcmToken: token,
    );

    // FirebaseFirestore.instance.collection("user").add(authUser.toJson());

    FirebaseFirestore.instance.collection("user").doc(user?.uid ?? "").set(authUser.toJson());
  }

  void chat(String senderId, String receiverId, String senderEmail, String receiverEmail, String msg) async {
    print("senderId $senderId");
    print("receiverId $receiverId");
    var doc1 = await FirebaseFirestore.instance.collection("chat").doc("$senderId-$receiverId").get();
    var doc2 = await FirebaseFirestore.instance.collection("chat").doc("$receiverId-$senderId").get();
    var receiverData = await FirebaseFirestore.instance.collection("user").doc(receiverId).get();
    var receiverToken = receiverData.data()?["fcmToken"]??"";

    sendFCMNotification(receiverToken, senderEmail, msg);
    doc1.reference.set({
      "last_msg": msg,
      "sender_email": senderEmail,
      "email": receiverEmail,
      "senderId": senderId,
      "receiverId": receiverId,
    });

    doc2.reference.set({
      "last_msg": msg,
      "sender_email": receiverEmail,
      "email": senderEmail,
      "senderId": receiverId,
      "receiverId": senderId,
    });

    doc1.reference.collection("messages").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
          ChatModel(
            time: DateTime.now().toString(),
            senderId: senderId,
            senderEmail: senderEmail,
            msg: msg,
          ).toJson(),
        );
    doc2.reference.collection("messages").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
          ChatModel(
            time: DateTime.now().toString(),
            senderId: senderId,
            senderEmail: senderEmail,
            msg: msg,
          ).toJson(),
        );
  }

  void sendFCMNotification(String receiverToken, String senderName, String msg) async {
    Map<String, dynamic> map = {
      "to": receiverToken,
      "notification": {
        "title": senderName,
        "body": msg,
      }
    };
    print(map);

    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"), body: jsonEncode(map), headers: {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAAXEUH_zA:APA91bGtkfFge7iXxjwo3RSQX1TurKMJOEOunSZeO2PpDtfBJoyGMsg-t0J6IyqVqMaV7c0R6X0SG1Be4niZrdNQeDl3HsK5c-jdtARNlfHX6pTdVic9ODfSfil58pI7sfwuQdEg2umU"
    });
  }
}
