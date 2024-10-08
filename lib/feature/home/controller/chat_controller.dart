import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final Rx<File?> imageFile = Rx<File?>(null);
  final Rx<File?> videoFile = Rx<File?>(null);

  late String receiverId;
  late String receiverName;
  late String receiverImage;
  late String receiverStatus;
  late Stream<QuerySnapshot> messagesStream;

  @override
  void onInit() {
    super.onInit();
    receiverId = Get.arguments['id'];
    receiverName = Get.arguments['name'];
    receiverImage = Get.arguments['image'];
    receiverStatus = Get.arguments['status'];

    messagesStream = _firestore
        .collection("messages")
        .where(Filter.or(Filter.and(Filter("senderId", isEqualTo: auth.currentUser!.uid), Filter("rid", isEqualTo: receiverId)),
            Filter.and(Filter("senderId", isEqualTo: receiverId), Filter("rid", isEqualTo: auth.currentUser!.uid))))
        .orderBy("time", descending: false)
        .snapshots();
    messagesStream.asBroadcastStream(onListen: (subscription) {
    },onCancel: (subscription) {
      log("Canceled");
    },);
    log("${Get.arguments}");
  }


  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      imageFile.value = File(file!.path);
    }
  }

  void getVideo({required ImageSource source}) async {
    final file = await ImagePicker().pickVideo(source: source);
    if (file?.path != null) {
      videoFile.value = File(file!.path);
    }
  }



  Future<void> sendMessage() async {
    String? imageURL;
    String? videoURL;

    if (imageFile.value != null) {
      imageURL = await _uploadFile(imageFile.value!, 'chat_send_images');
    }
    if (videoFile.value != null) {
      videoURL = await _uploadFile(videoFile.value!, 'chat_send_videos');
    }

    try {
      await _firestore.collection("messages").add({
        "senderId": auth.currentUser!.uid,
        "message": messageController.text.isNotEmpty ? messageController.text : "",
        "rid": receiverId,
        "image": imageURL ?? "",
        "video": videoURL ?? "",
        "rname": receiverName,
        'time': Timestamp.now(),
      });
      messageController.clear();
      imageFile.value = null;
      videoFile.value = null;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String> _uploadFile(File file, String folder) async {
    Reference ref = _storage.ref().child(folder).child("${DateTime.now()}");
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => print('File uploaded to Firebase Storage'));
    return await ref.getDownloadURL();
  }
}
