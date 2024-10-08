import 'dart:developer';
import 'dart:io';

import 'package:chatapp/feature/home/screens/home_screen.dart';
import 'package:chatapp/feature/home/screens/sidebar_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/login_screen.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailController =  TextEditingController();
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emailController.clear();
      Get.back();
      Get.snackbar('Success', 'If an account exists for $email, a password reset link has been sent.');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      Get.snackbar('Error', errorMessage);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.');
    }
    finally {
      isLoading(false);
    }
  }

}


class LoginController extends GetxController  with WidgetsBindingObserver{
  RxBool isLoading = false.obs;
  RxBool hidePass = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

   @override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this);
       emailController.dispose();
       passwordController.dispose();
       super.dispose();
  }
  void resetFields() {
    emailController.clear();
    passwordController.clear();
    update();
  }




  Future<void> login({required Map<String, dynamic> data}) async {
    try {
      isLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data["email"].toString(),
          password: data["password"].toString()
      );      Get.offAll(() =>  HomeScreen());
      Get.snackbar('Success', 'User Login Successfully');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      log(e.code);
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'The user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'The user does not exist.';
          break;
        case 'wrong-password':
          errorMessage = 'The password is invalid.';
          break;
        case 'invalid-credential' :
          errorMessage = 'Enter Email not exists account';
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      Get.snackbar('Error', errorMessage);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.');
    }
    finally {
      isLoading(false);
    }
  }
}

class SignUpController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final Rx<File?> imageFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hidePass = true.obs;
  final RxBool hideConfirmPass = true.obs;
  final RxString imageUrl = ''.obs;
  final Rx<String?> selectedCity = Rx<String?>(null);
  late bool isUpdate = false;
  late String docId = '';


  final List<String> cities = [
    'Ahmedabad',
    'Delhi',
    'Gandhinagar',
    'Goa',
    'Hyderabad'
  ];

  @override
  void onInit() {
    isUpdate = Get.arguments['update'];
    docId = Get.arguments['docId'];

    if(isUpdate) {
      getUserDetails(docId);
    }
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      resetFields();
      super.dispose();
  }

  void resetFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    imageFile.value = null;
    selectedCity.value = null;
    imageUrl.value = '';
    update();
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      imageFile.value = File(file!.path);
    }
  }

  Future<void> getUserDetails(String docId) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("users").doc(docId).get();
    imageUrl.value = ds.get("image_url");
    nameController.text = ds.get("name");
    emailController.text = ds.get("email");
    selectedCity.value = ds.get("city");
  }

  Future<void> updateUserDetails(String docId) async {
    try {
      isLoading.value = true;
      if (imageFile.value != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child("User_profile_images").child("images/${DateTime.now()}");
        UploadTask uploadTask = ref.putFile(imageFile.value!);
        await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
        imageUrl.value = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("users").doc(docId).update({
        "name": nameController.text,
        "email": emailController.text,
        "city": selectedCity.value,
        "image_url": imageUrl.value,
      });
      Get.offAll(()=>HomeScreen());
      Get.snackbar("Success", "Profile updated successfully..");
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
      try {
        isLoading.value = true;
        if (imageFile.value != null) {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child("User_profile_images").child("images/${DateTime.now()}");
          UploadTask uploadTask = ref.putFile(imageFile.value!);
          await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
          imageUrl.value = await ref.getDownloadURL();
          Map<String,dynamic>  data =  {
            "name": nameController.text,
            "email":
            emailController.text,
            "city":
            selectedCity.value!,
            "image_url":
            imageUrl.value,
            'id':
            userCredential.user!.uid,
            'status' : "unavailable" ,
          };
          await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set(data);
          Get.offAll(() =>   LoginScreen());
          Get.snackbar("Success","Account created successfully!");
          resetFields();
        }else{
          Get.snackbar("Error","Please Select a Image");
        }



      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.message.toString());
      } finally {
        isLoading.value = false;
      }
  }
}