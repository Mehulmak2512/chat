import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/feature/home/controller/chat_controller.dart';
import 'package:chatapp/feature/home/screens/widgets/video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatelessWidget {

   ChatScreen({super.key});
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(height, width),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
          child: _buildBody(height, width, context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(double height, double width) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: 70,
      backgroundColor: const Color(0xff89246D),
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(controller.receiverImage),
                radius: 24,
              ),
               Positioned(
                top: 35,
                left: 36,
                child: CircleAvatar(
                  backgroundColor: controller.receiverStatus == "unavailable" || controller.receiverStatus == "Offline" ? Colors.transparent : Colors.green,
                  radius: 5,
                ),
              ),
            ],
          ),
          SizedBox(width: width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.receiverName,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.receiverStatus == "unavailable" || controller.receiverStatus == "Offline" ? "Offline" : "Online",
                style: GoogleFonts.mulish(
                  color: Colors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_outlined),
        ),
        SizedBox(width: width * 0.02),
      ],
    );
  }

  Widget _buildBody(double height, double width, BuildContext context) {
    return Obx(() {
      if (controller.imageFile.value == null && controller.videoFile.value == null) {
        return Column(
          children: [_buildMessageList(height, width, context), _buildInputArea(height, width)],
        );
      } else if (controller.imageFile.value != null) {
        return Column(
          children: [_buildImagePreview(height, width), _buildSendButton(height, width, context)],
        );
      } else {
        return Column(
          children: [_buildVideoPreview(height, width), _buildSendButton(height, width, context)],
        );
      }
    });
  }

  Widget _buildMessageList(double height, double width, BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15, top: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: controller.messagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.purple));
            }

            List<QueryDocumentSnapshot> allMessages = snapshot.data!.docs.reversed.toList();

            return ListView.builder(
              controller: controller.scrollController,
              itemCount: allMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = allMessages[index].get("message").toString();
                final image = allMessages[index].get("image").toString();
                final video = allMessages[index].get("video").toString();
                final time = DateFormat.jm().format(allMessages[index].get("time").toDate());
                final currentMsg = allMessages[index].get("senderId") == controller.auth.currentUser!.uid.toString();

                return _buildMessageItem(message, image, video, time, currentMsg, height, width, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSendButton(double height, double width, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
      ),
      onPressed: controller.sendMessage,
      child: Text(
        "Send",
        style: GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageItem(
      String message, String image, String video, String time, bool currentMsg, double height, double width, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: currentMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (message.isNotEmpty) _buildTextMessage(message, time, currentMsg, width),
            if (image.isNotEmpty) _buildImageMessage(image, time, currentMsg, height, width, context),
            if (video.isNotEmpty) _buildVideoMessage(video, time, currentMsg, height, width),
          ],
        ),
      ],
    );
  }

  Widget _buildTextMessage(String message, String time, bool currentMsg, double width) {
    return Column(
      crossAxisAlignment: currentMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          width: message.length > 30 ? width / 1.35 : null,

          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
            color: currentMsg ? const Color(0xff89246D) :  Colors.black38,

          ),
          child: Wrap(direction: Axis.horizontal,crossAxisAlignment: WrapCrossAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(padding: EdgeInsets.only(right: 7,bottom: 3),
                child: Text(
                  message,
                  style: GoogleFonts.mulish(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              Transform.translate(offset: Offset(0,1) ,
                child: Text(
                  time,
                  style: GoogleFonts.mulish(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                      color: currentMsg ? Colors.grey.shade100 : Colors.white
                  ),
                ),
              )
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildImageMessage(String image, String time, bool currentMsg, double height, double width, BuildContext context) {
    return Column(
      crossAxisAlignment: currentMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => showImageViewer(context, CachedNetworkImageProvider(image)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: height * 0.3,
            width: width / 1.4,
            decoration: BoxDecoration(
              image: DecorationImage(image: CachedNetworkImageProvider(image), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Text(time, style: GoogleFonts.mulish(fontSize: 8, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildVideoMessage(String video, String time, bool currentMsg, double height, double width) {
    return Column(
      crossAxisAlignment: currentMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              height: height * 0.3,
              width: width / 1.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FlickVideoPlayer(
                  flickVideoWithControls: const FlickVideoWithControls(videoFit: BoxFit.cover),
                  flickManager: FlickManager(
                    videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(video)),
                    autoPlay: false,
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.11,
              left: width / 3.4,
              child: InkWell(
                onTap: () => Get.to(() => ChatVideoScreen(video: video)),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  radius: 28,
                  child: const Icon(Icons.play_arrow_outlined, color: Colors.black, size: 40),
                ),
              ),
            )
          ],
        ),
        Text(time, style: GoogleFonts.mulish(fontSize: 8, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildImagePreview(double height, double width) {
    return Expanded(
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: FileImage(controller.imageFile.value!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPreview(double height, double width) {
    return Expanded(
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlickVideoPlayer(
            flickManager: FlickManager(
              videoPlayerController: VideoPlayerController.file(controller.videoFile.value!),
              autoPlay: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(double height, double width) {
    return Padding(
      // padding: const EdgeInsets.symmetric(vertical: 8.0),
      padding:  EdgeInsets.zero,
      child: Row(
        children: [
          InkWell(
            onTap: () => _showMediaOptions(Get.context!),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff89246D), Color(0xffC1236D)],
                ),
              ),
              child: const Icon(Icons.add, size: 35, color: Colors.white),
            ),
          ),
          SizedBox(width: width * 0.02),
          Expanded(
            child: TextFormField(
              controller: controller.messageController,
              style: GoogleFonts.mulish(),
              decoration: InputDecoration(
                hintStyle: GoogleFonts.mulish(),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.25),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                suffixIcon: IconButton(
                  onPressed: controller.sendMessage,
                  icon: const Icon(Icons.send, size: 28, color: Colors.purple),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showMediaOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _mediaOption(
                icon: Icons.image,
                label: "Image",
                onTap: () => _showImageSourceOptions(context),
              ),
              _mediaOption(
                icon: Icons.video_camera_back_outlined,
                label: "Video",
                onTap: () => _showVideoSourceOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediaOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 35, color: Colors.black),
          Text(
            label,
            style: GoogleFonts.mulish(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          )
        ],
      ),
    );
  }

  void _showImageSourceOptions(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _mediaOption(
                icon: Icons.camera_alt_outlined,
                label: "Camera",
                onTap: () {
                  controller.getImage(source: ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              _mediaOption(
                icon: Icons.photo,
                label: "Gallery",
                onTap: () {
                  controller.getImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoSourceOptions(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _mediaOption(
                      icon: Icons.videocam_outlined,
                      label: "Camera",
                      onTap: () {
                        controller.getVideo(source: ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                    _mediaOption(
                      icon: Icons.video_library_outlined,
                      label: "Gallery",
                      onTap: () {
                        controller.getVideo(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ));
  }
}
