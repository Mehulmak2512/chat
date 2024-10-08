import 'package:chatapp/feature/home/controller/home_controller.dart';
import 'package:chatapp/feature/home/screens/sidebar_screen.dart';
import 'package:chatapp/feature/home/screens/widgets/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      drawer:  SidebarScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.purpleAccent,
        ),
        title: Text(
          "Let's Chat",
          style: GoogleFonts.mulish(
            color: Colors.purple,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: homeController.searchController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.mulish(),
              onTapOutside: (e)=> Get.focusScope?.unfocus(),
              onChanged: (value) {
                homeController.searchUser(value);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                hintText: "Search...",
                hintStyle: GoogleFonts.mulish(),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder(
              stream:FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No User Found', style: GoogleFonts.mulish()),
                  );
                }

                homeController.clonedUser.value = snapshot.data!.docs.where((user) => user.get("id") !=  homeController.currentUserUid).toList();

                return Obx(() {
                  var userList = homeController.searchController.text.isNotEmpty
                      ? homeController.searchedUser
                      : homeController.clonedUser;

                  return ListView.separated(
                    padding: const EdgeInsets.all(15),
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      var user = userList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>  ChatScreen(),
                              arguments: {
                            "image": user.get("image_url"),
                            "name": user.get("name"),
                            "id": user.get("id"),
                            "status": user.get("status"),
                          }
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(user.get("image_url")),
                                  radius: 25,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  user.get("name"),
                                  style: GoogleFonts.mulish(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
