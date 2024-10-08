
import 'package:chatapp/auth/controller/auth_controller.dart';
import 'package:chatapp/auth/screens/forget_password_screen.dart';
import 'package:chatapp/auth/screens/signup_screen.dart';
import 'package:chatapp/constants/constansts.dart';
import 'package:chatapp/common/round_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   final formKey = GlobalKey<FormState>();
   final controller = Get.put( LoginController());


   @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/auth/chat-bubble-left-right.png"),
                      Text(
                        "Chatting",
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.08,
              ),
              Text(
                "Login",
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.purple),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Form(
                key: formKey,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.mulish(),
                    onTapOutside:(event) => FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      hintText: "abc@gmail.com",
                      hintStyle: GoogleFonts.mulish(),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.25),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      border: border,

                      enabledBorder:border,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Text(
                    "Password",
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Obx(
                    () {
                      return TextFormField(
                        controller: controller.passwordController,
                        style: GoogleFonts.mulish(),
                        obscureText: controller.hidePass.value,
                        obscuringCharacter: "*",
                        onTapOutside:(event) => Get.focusScope?.unfocus(),
                        decoration: InputDecoration(
                          hintText: "*************",
                          hintStyle: GoogleFonts.mulish(),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.25),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePass.value = !controller.hidePass.value;
                            },
                            icon: Icon(
                              controller.hidePass.value ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: border,

                          enabledBorder:border,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                      );
                    }
                  ),
                ],
              ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      controller.resetFields();
                       Get.to(()=> ForgetPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.07,
              ),

              Obx(
                 () {
                  return RoundButton(
                      title: "Login",
                      loading: controller.isLoading.value,
                      onTap: (){
                            if(formKey.currentState!.validate()){
                                 controller.login(data:
                                     {
                                       "email":controller.emailController.text.toString(),
                                       "password":controller.passwordController.text.toString(),
                                     }
                                 );
                            }
                      },
                  );
                }
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Have an Account? ",
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.resetFields();

                      Get.to(()=> SignUpScreen(),arguments: {
                        "update": false,
                        "docId": '',
                      });
                    },
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w700,
                        color: Colors.purple,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
