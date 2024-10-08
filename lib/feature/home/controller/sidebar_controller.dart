import 'dart:developer';

import 'package:chatapp/auth/screens/login_screen.dart';
import 'package:chatapp/feature/home/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  final auth = FirebaseAuth.instance;
  var docId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDocId();
  }
  void getDocId() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final uid = auth.currentUser?.uid;
    if (uid != null) {
      var querySnapshot = await usersRef.where('id', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        String? docIdValue = querySnapshot.docs[0].id;
        docId.value = docIdValue;
      }
    }
  }

  void signOut() async {
    final homeController = Get.find<HomeController>();
    homeController.setStatus("Offline");
    await auth.signOut();
    Get.offAll(LoginScreen());
  }
}
