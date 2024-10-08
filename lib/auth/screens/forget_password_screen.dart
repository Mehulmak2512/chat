
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/common/round_button.dart';
import '../controller/auth_controller.dart';


class ForgetPasswordScreen extends StatelessWidget {
   ForgetPasswordScreen({super.key});

  final forgetPassController = Get.put( ForgetPasswordController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff89246D),
        leading: IconButton(onPressed: (){
          Get.back();
          forgetPassController.emailController.clear();
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),

        title: const Text("Forget Password",style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white
        ),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            children: [
              const SizedBox(height: 50),

              Form(
                key: formKey,
                child: TextFormField(
                  controller: forgetPassController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.mulish(),
                  decoration: InputDecoration(
                    // hintText: "andrewmark111@gmail.com",
                    labelStyle: GoogleFonts.mulish(),
                    labelText: "Enter Email",
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.25),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please the enter email";
                    }
                    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                      return "Please enter valid email";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              Obx(
                () {
                  return RoundButton(
                    title: 'Submit',
                    loading: forgetPassController.isLoading.value,
                    onTap: () async {
                      if(formKey.currentState!.validate()){
                               forgetPassController.forgetPassword(email: forgetPassController.emailController.text.toString().trim());
                      }

                    },);
                }
              )


            ],
          ),
        ),
      ),

    );
  }
}
