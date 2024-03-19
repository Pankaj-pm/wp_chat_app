// To parse this JSON data, do
//
//     final authUser = authUserFromJson(jsonString);

import 'dart:convert';

AuthUser authUserFromJson(String str) => AuthUser.fromJson(json.decode(str));

String authUserToJson(AuthUser data) => json.encode(data.toJson());

class AuthUser {
  String? name;
  String? email;
  String? number;
  String? status;
  String? lastMsg;
  String? lastTime;
  String? img;
  bool? online;

  AuthUser({
    this.name,
    this.email,
    this.number,
    this.status,
    this.lastMsg,
    this.lastTime,
    this.img,
    this.online,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    name: json["name"],
    email: json["email"],
    number: json["number"],
    status: json["status"],
    lastMsg: json["last_msg"],
    lastTime: json["last_time"],
    img: json["img"],
    online: json["online"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "number": number,
    "status": status,
    "last_msg": lastMsg,
    "last_time": lastTime,
    "img": img,
    "online": online,
  };
}
