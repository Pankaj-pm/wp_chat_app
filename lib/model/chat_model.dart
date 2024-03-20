// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String? msg;
  String? senderId;
  String? senderEmail;
  String? time;

  ChatModel({
    this.msg,
    this.senderId,
    this.senderEmail,
    this.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    msg: json["msg"],
    senderId: json["sender_id"],
    senderEmail: json["sender_email"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "sender_id": senderId,
    "sender_email": senderEmail,
    "time": time,
  };
}
