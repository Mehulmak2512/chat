import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final searchController = TextEditingController();
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid.toString();

  var docid = ''.obs;
  var searchedUser = [].obs;
  var clonedUser = [].obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await getDocId();
    setStatus('Online');
  }



  Future<void> getDocId() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {

      var snapshot = await usersRef.where('id', isEqualTo: uid).get();
      if (snapshot.docs.isNotEmpty) {
        log(snapshot.docs.isNotEmpty.toString());
        docid.value = snapshot.docs[0].id;
      }
    }
  }

  Future<void> setStatus(String status) async {

    if (docid.value.isNotEmpty) {
      log("docId : ${docid.value}");
      log("status : ${status}");
      await FirebaseFirestore.instance.collection('users').doc(docid.value).update({
        'status': status,
      });
    } else {
      log('Error: docId is null or empty.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('Online');
    } else if  (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setStatus('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }



  void searchUser(String query) {
    if (clonedUser.isNotEmpty) {
      searchedUser.value = clonedUser.where((element) =>
          element['name'].toString().toLowerCase().contains(query.toLowerCase(),)).toList();
    }
  }
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }
}
