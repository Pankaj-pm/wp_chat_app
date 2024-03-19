import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wp_chat_app/model/auth_user.dart';

class FsModel {
  static final FsModel _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }

  void addUser(User? user) {
    AuthUser authUser = AuthUser(
      name: user?.displayName ?? "",
      number: "",
      email: user?.email ?? "",
      img: "",
      lastMsg: "",
      lastTime: "",
      online: true,
      status: "",
    );

    // FirebaseFirestore.instance.collection("user").add(authUser.toJson());

    FirebaseFirestore.instance.collection("user").doc(user?.uid ?? "").set(authUser.toJson());
  }
}
