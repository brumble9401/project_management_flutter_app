import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.chatRoomUid});

  final String chatRoomUid;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _messageController = TextEditingController();
  late UserModel user;
  bool _showEmoji = false, _isUploading = false;

  Future<void> sendMessage(UserModel user) async {
    await context
        .read<ChatCubit>()
        .sendMessage(widget.chatRoomUid, userUid, _messageController.text, user, 'text');
    _messageController.clear();
  }

  Future<void> sendImageMessage(UserModel user, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        'images/${widget.chatRoomUid}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    // await sendMessage(chatUser, imageUrl, Type.image);
    await context.read<ChatCubit>().sendMessage(widget.chatRoomUid, userUid, imageUrl, user, 'image');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w),
          child: StreamBuilder<ChatRoom>(
            stream: context
                .read<ChatCubit>()
                .getRoomFromRoomUid(widget.chatRoomUid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String friendUid = snapshot.data!.users!
                    .firstWhere((element) => element != userUid);
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    backgroundColor: white,
                    centerTitle: false,
                    shadowColor: Colors.transparent,
                    title: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.chevron_left,
                            color: neutral_dark,
                            size: 19.sp,
                          ),
                        ),
                        StreamBuilder<UserModel>(
                            stream: context
                                .read<UserCubit>()
                                .getUserFromUid(friendUid),
                            builder: (context, userSnap) {
                              if (userSnap.hasData) {
                                user = userSnap.data!;
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 19.w,
                                      backgroundImage: userSnap.data!.avatar ==
                                              ''
                                          ? const NetworkImage(
                                              'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                                          : NetworkImage(
                                              userSnap.data!.avatar!),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "${userSnap.data!.firstName} ${userSnap.data!.lastName}",
                                      style: TextStyle(
                                        color: neutral_dark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                user = UserModel();
                                return const CircularProgressIndicator();
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                  body: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: neutral_dark,
                        ),
                      )
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                            child: StreamBuilder<List<MessageModel>>(
                              stream: context
                                  .read<ChatCubit>()
                                  .getMessages(widget.chatRoomUid),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  List<MessageModel> messages = snap.data!;
                                  messages.sort((a, b) =>
                                      a.createdDate.compareTo(b.createdDate));

                                  int lastIndexReadByFriend =
                                      messages.lastIndexWhere((message) =>
                                          message.readBy.contains(friendUid));

                                  return ListView.builder(
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      bool isLastMessageRead =
                                          index == lastIndexReadByFriend;
                                      return buildMessageTile(
                                        messages[index].senderId == userUid,
                                        messages[index],
                                        isLastMessageRead,
                                        friendUid,
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: const BoxDecoration(
                            color: white,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        //emoji button
                                        IconButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            setState(() => _showEmoji = !_showEmoji);
                                            print(_showEmoji);
                                          },
                                          icon: const Icon(
                                            Icons.emoji_emotions,
                                            color: primary, size: 25,
                                          ),
                                        ),

                                        Expanded(
                                          child: TextField(
                                            controller: _messageController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            onTap: () {
                                              if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                                            },
                                            decoration: const InputDecoration(
                                                hintText: 'Type Something...',
                                                hintStyle: TextStyle(color: neutral_grey),
                                                border: InputBorder.none,
                                            ),
                                          ),
                                        ),

                                        //pick image from gallery button
                                        IconButton(
                                          onPressed: () async {
                                            final ImagePicker picker = ImagePicker();

                                            // Picking multiple images
                                            final List<XFile> images =
                                            await picker.pickMultiImage(imageQuality: 70);

                                            // uploading & sending image one by one
                                            for (var i in images) {
                                              print('Image Path: ${i.path}');
                                              setState(() => _isUploading = true);
                                              // await APIs.sendChatImage(widget.user, File(i.path));
                                              await sendImageMessage(user, File(i.path));
                                              setState(() => _isUploading = false);
                                            }
                                          },
                                          icon: const Icon(Icons.image,
                                            color: primary,
                                            size: 26,
                                          ),
                                        ),

                                        //take image from camera button
                                        IconButton(
                                          onPressed: () async {
                                            final ImagePicker picker = ImagePicker();

                                            // Pick an image
                                            final XFile? image = await picker.pickImage(
                                                source: ImageSource.camera, imageQuality: 70);
                                            if (image != null) {
                                              print('Image Path: ${image.path}');
                                              setState(() => _isUploading = true);
                                              //
                                              // await APIs.sendChatImage(
                                              //     widget.user, File(image.path));
                                              await sendImageMessage(user, File(image.path));
                                              setState(() => _isUploading = false);
                                            }
                                          },
                                          icon: const Icon(Icons.camera_alt_rounded,
                                            color: primary,
                                            size: 26,
                                          ),
                                        ),

                                        //adding some space
                                        SizedBox(width: 5.w),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Handle send message
                                    sendMessage(user);
                                  },
                                  child: const Icon(Icons.send),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (_showEmoji)
                          SizedBox(
                            height: 250.h,
                            child: EmojiPicker(
                              textEditingController: _messageController,
                              config: Config(
                                bgColor: const Color.fromARGB(255, 234, 248, 255),
                                columns: 8,
                                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildMessageTile(
    bool isMe,
    MessageModel message,
    bool isLastMessageRead,
    String friendUid,
  ) {
    if (message.readBy.isEmpty) {
      if (userUid != message.senderId) {
        context
            .read<ChatCubit>()
            .updateReadStatus(userUid, widget.chatRoomUid, message.id);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 7.w),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: isMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // else if (message.readBy.isEmpty)
                  Text(
                    DateFormat('h:mm a').format(message.createdDate),
                    style: TextStyle(
                      color: neutral_grey,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe ? primary : neutral_lightgrey,
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(13.sp),
                                    topRight: Radius.circular(13.sp),
                                    bottomLeft: Radius.circular(13.sp),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(13.sp),
                                    topRight: Radius.circular(13.sp),
                                    bottomRight: Radius.circular(13.sp),
                                  ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: message.type == 'text' ? Text(
                              message.content,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ) : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: message.content,

                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                              ),
                            ),
                          ),
                        ),
                        if (isLastMessageRead)
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "read",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: neutral_grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Icon(Icons.done_all_rounded,
                                    color: primary, size: 14.sp),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: StreamBuilder<UserModel>(
                        stream:
                            context.read<UserCubit>().getUserFromUid(friendUid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 15.sp,
                                  backgroundImage: snapshot.data!.avatar == ''
                                      ? const NetworkImage(
                                          'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                                      : NetworkImage(snapshot.data!.avatar!),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isMe ? primary : neutral_lightgrey,
                                      borderRadius: isMe
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(13.sp),
                                              topRight: Radius.circular(13.sp),
                                              bottomLeft:
                                                  Radius.circular(13.sp),
                                            )
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(13.sp),
                                              topRight: Radius.circular(13.sp),
                                              bottomRight:
                                                  Radius.circular(13.sp),
                                            ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      child: message.type == 'text' ? Text(
                                        message.content,
                                        style: TextStyle(
                                          color: isMe ? Colors.white : Colors.black,
                                        ),
                                      ) : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: message.content,

                                          placeholder: (context, url) => const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.image, size: 70),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    DateFormat('h:mm a').format(message.createdDate),
                    style: TextStyle(
                      color: neutral_grey,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
