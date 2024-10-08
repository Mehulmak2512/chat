import 'package:chatapp/auth/controller/auth_controller.dart';
import 'package:chatapp/constants/constansts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/common/round_button.dart';

class SignUpScreen extends StatelessWidget {


  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;



    return PopScope(
      onPopInvoked: (didPop) async {
        controller.resetFields();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            controller.isUpdate ? "Edit Profile" : "Sign Up",
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff89246D),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Obx(() {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image
                        Center(
                          child: GestureDetector(
                              onTap: () {
                                controller.getImage(source: ImageSource.camera);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: height * 0.2,
                                    width: width / 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff89246D),
                                          Color(0xffC1236D)
                                        ],
                                      ),
                                      image: controller.isUpdate &&
                                              controller.imageUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  controller.imageUrl.value),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: controller.imageFile.value != null
                                        ? Container(
                                            height: height * 0.2,
                                            width: width / 2,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: FileImage(controller
                                                    .imageFile.value!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: height * 0.2,
                                            width: width / 2,
                                            child: controller.isUpdate
                                                ? const SizedBox()
                                                : const Icon(
                                                    Icons.person_outline,
                                                    size: 100,
                                                    color: Colors.white),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 30,
                                          color: Colors.purple),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: height * 0.02),

                        // Name field
                        _buildTextField(
                          controller: controller.nameController,
                          label: "Name",
                          hint: "Abc",
                        ),
                        SizedBox(height: height * 0.015),

                        // Email field
                        _buildTextField(
                          controller: controller.emailController,
                          label: "Email",
                          hint: "abc@gmail.com",
                          isUpdate: controller.isUpdate ? true : false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                       controller.isUpdate ?

                        Column(
                          children: [
                            SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  "Can't change the email",
                                  style: GoogleFonts.mulish(color: Colors.red),
                                )
                              ],
                            ),
                          ],
                        ) : SizedBox(),
                        SizedBox(height: height * 0.01),

                        // City dropdown
                        Text(
                          "City",
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: controller.selectedCity.value,
                            items: controller.cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city, style: GoogleFonts.mulish()),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              controller.selectedCity.value = value;
                            },
                            decoration: _inputDecoration(hint: "Select a city"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a city";
                              }
                              return null;
                            },
                          );
                        }),
                        SizedBox(height: height * 0.015),

                        // Password fields (only for sign up)
                        if (!controller.isUpdate) ...[
                          _buildTextField(
                            controller: controller.passwordController,
                            label: "Password",
                            hint: "*************",
                            isPassword: true,
                            obscureText: controller.hidePass,
                          ),
                          SizedBox(height: height * 0.015),
                          _buildTextField(
                            controller: controller.confirmPasswordController,
                            label: "Confirm Password",
                            hint: "*************",
                            isPassword: true,
                            obscureText: controller.hideConfirmPass,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter confirm Password";
                              } else if (value !=
                                  controller.passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                SizedBox(height: height * 0.028),
                Obx(() => RoundButton(
                      title: controller.isUpdate ? "Submit" : "Sign Up",
                      loading: controller.isLoading.value,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (controller.isUpdate) {
                            controller.updateUserDetails(controller.docId);
                          } else {
                            controller.signUp();
                          }
                        }
                      },
                    )),
                SizedBox(height: height * 0.02),
                if (!controller.isUpdate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Have an Account? ",
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w700,
                            color: Colors.purple,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {
        required TextEditingController controller,
      required String label,
      required String hint,
      TextInputType keyboardType = TextInputType.text,
      bool isPassword = false,
      RxBool? obscureText,
      String? Function(String?)? validator,
      bool isUpdate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: isUpdate? true : false,
          controller: controller,
          keyboardType: keyboardType,
          onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
          obscureText: isPassword ? obscureText!.value : false,
          style: GoogleFonts.mulish(),
          decoration: _inputDecoration(
            hint: hint,
            isPassword: isPassword,
            obscureText: obscureText,
          ),
          validator: validator ??
              (value) {
                if (value!.isEmpty) {
                  return "Enter $label";
                }
                return null;
              },
        )
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    bool isPassword = false,
    RxBool? obscureText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.mulish(),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      border: border,
      enabledBorder: border,
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () => obscureText.toggle(),
              icon: Icon(
                obscureText!.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
