import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wp_chat_app/model/auth_user.dart';
import 'package:wp_chat_app/model/chat_model.dart';

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


  void chat(String senderId, String receiverId, String senderEmail,String receiverEmail, String msg) async{


    print("senderId $senderId");
    print("receiverId $receiverId");
    var doc = await  FirebaseFirestore.instance.collection("chat").doc("$senderId-$receiverId").get();

    if(!doc.exists){
      doc = await FirebaseFirestore.instance.collection("chat").doc("$receiverId-$senderId").get();
    }

    doc.reference.set({
      "last_msg": msg,
      "sender_email": senderEmail,
      "email": receiverEmail,
      "senderId": senderId,
      "receiverId": receiverId,
    });

    print(doc.exists);

    doc.reference.collection("messages").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
          ChatModel(time: DateTime.now().toString(), senderId: senderId, senderEmail: senderEmail, msg: msg).toJson(),
        );
  }
}

