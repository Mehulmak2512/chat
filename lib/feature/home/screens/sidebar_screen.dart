import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/auth/screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/sidebar_controller.dart';



class MenuList {
  final IconData icon;
  final String title;

  MenuList({required this.icon, required this.title});
}

class SidebarScreen extends StatelessWidget {
  final SidebarController controller = Get.put(SidebarController());
  final List<MenuList> _menulist = [
    MenuList(icon: Icons.home_outlined, title: "Home"),
    MenuList(icon: Icons.person_outline, title: "Edit Profile"),
    MenuList(icon: Icons.help_outline, title: "Help"),
    MenuList(icon: Icons.logout_outlined, title: "Logout"),
  ];

   SidebarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff89246D), Color(0xffC1236D)],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.25,
              width: width,
              margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    topRight: Radius.circular(60)),
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/profile/Rectangle 32.jpg",
                    ),
                    fit: BoxFit.cover),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where("id", isEqualTo: controller.auth.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.indigo));
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: snapshot.data!.docs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                snapshot.data!.docs[index]
                                    .get('image_url')
                                    .toString(),
                              ),
                              radius: 60,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              snapshot.data!.docs[index]
                                  .get("name")
                                  .toString(),
                              style: GoogleFonts.mulish(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            ListView.builder(
              itemCount: _menulist.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Get.back();
                    }
                    if (index == 1) {
                      Get.to(() => SignUpScreen(),arguments: {
                        "update": true, "docId": controller.docId.value
                      });
                    }
                    if (index == 3) {
                      controller.signOut();
                    }
                  },
                  child: Column(
                    children: [
                      ListTile(
                        minVerticalPadding: 0,
                        dense: true,
                        visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          _menulist[index].title,
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: Icon(
                          _menulist[index].icon,
                          size: 23,
                          color: Colors.pink.withOpacity(0.7),
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Colors.grey.shade400.withOpacity(0.6),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chatapp/ui/auth/screens/login_screen.dart';
// import 'package:chatapp/ui/auth/screens/signup_screen.dart';
// import 'package:chatapp/ui/auth/screens/signup_screen.dart';
// import 'package:chatapp/ui/home/home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class SidebarScreen extends StatefulWidget {
//   const SidebarScreen({super.key});
//
//   @override
//   State<SidebarScreen> createState() => _SidebarScreenState();
// }
//
// class MenuList {
//   final IconData icon;
//   final String title;
//
//   MenuList({required this.icon, required this.title});
// }
//
// class _SidebarScreenState extends State<SidebarScreen> {
//   final List<MenuList> _menulist = [
//     MenuList(icon: Icons.home_outlined, title: "Home"),
//     MenuList(icon: Icons.person_outline, title: "Edit Profile"),
//     MenuList(icon: Icons.help_outline, title: "Help"),
//     MenuList(icon: Icons.logout_outlined, title: "Logout"),
//   ];
//
//   final auth = FirebaseAuth.instance;
//    var docid;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDocId();
//   }
//
//
//    getDocId() {
//     final usersRef = FirebaseFirestore.instance.collection('users');
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       usersRef.where('id', isEqualTo: uid).get().then((DocumentSnapshot) {
//         if (DocumentSnapshot.docs.isNotEmpty) {
//           String? docId = DocumentSnapshot.docs[0].id;
//           print(docId);
//           setState(() {
//             docid = docId;
//
//           });
//         }
//       });
//     }
//     return "empty";
//   }
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.pink.shade50,
//
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xff89246D), Color(0xffC1236D)],
//             ),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         title: Text(
//           "Profile",
//           style: GoogleFonts.mulish(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: height * 0.25,
//               width: width,
//               margin: const EdgeInsets.all(15),
//               decoration:  const BoxDecoration(
//                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60),topRight: Radius.circular(60)),
//                 image: DecorationImage(
//                       image: AssetImage(
//                         "assets/images/profile/Rectangle 32.jpg",
//                       ),
//                       fit: BoxFit.cover),
//               ),
//               child: StreamBuilder(
//                 stream:FirebaseFirestore.instance
//                     .collection('users')
//                     .where("id", isEqualTo: auth.currentUser!.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child:  CircularProgressIndicator(color: Colors.indigo,));
//                   }
//                   if (snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text('',style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),),
//                     );
//                   }
//                   return ListView.builder(
//                       padding: const EdgeInsets.all(15),
//                       itemCount: snapshot.data!.docs.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               backgroundImage:
//                                   CachedNetworkImageProvider(
//                                     snapshot.data!.docs[index].get('image_url').toString(),
//                                   ),
//                               radius: 60,
//                             ),
//
//                             SizedBox(
//                               height: height * 0.02,
//                             ),
//                             Text(
//                               snapshot.data!.docs[index].get("name").toString(),
//                               style: GoogleFonts.mulish(
//                                   fontSize: 23,
//                                   fontWeight:FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                           ],
//                         );
//                       });
//                 },
//               ),
//             ),
//             SizedBox(
//               height: height * 0.05,
//             ),
//             ListView.builder(
//               itemCount: _menulist.length,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: const EdgeInsets.symmetric(
//                 vertical: 10,
//                 horizontal: 20,
//               ),
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//
//                   onTap: () {
//
//                     if(index == 0){
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);
//                     }
//
//                     if(index == 1){
//                       print("docid is $docid");
//                       Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                           SignUpScreen(isUpdate: true, docId: docid)
//                       ),
//                       );
//                     }
//                     if (index == 3) {
//
//                       auth.signOut().then((value) {
//                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>  LoginScreen()), (route) => false);
//
//                       }).onError((error, stackTrace) {
//                         Fluttertoast.showToast(msg: error.toString());
//                       });
//                     }
//                   },
//                   child: Column(
//                     children: [
//                       ListTile(
//                         minVerticalPadding: 0,
//                         dense: true,
//                         visualDensity:
//                             const VisualDensity(horizontal: 0, vertical: -4),
//                         contentPadding: const EdgeInsets.all(0),
//                         title: Text(
//                           _menulist[index].title,
//                           style: GoogleFonts.mulish(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         leading: Icon(
//                           _menulist[index].icon,
//                           size: 23,
//                           color: Colors.pink.withOpacity(0.7),
//                         ),
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                         color: Colors.grey.shade400.withOpacity(0.6),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
