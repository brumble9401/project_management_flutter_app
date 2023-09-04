import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.chatRoomUid});

  final String chatRoomUid;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    context
        .read<ChatCubit>()
        .sendMessage(widget.chatRoomUid, userUid, _messageController.text);
    _messageController.clear();
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
                                return const CircularProgressIndicator();
                              }
                            }),
                      ],
                    ),
                  ),
                  body: Column(
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
                                child: InputBox(
                                  label: 'Type a message...',
                                  controller: _messageController,
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Handle send message
                                  sendMessage();
                                },
                                child: Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
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
                    style: const TextStyle(color: neutral_grey),
                  ),
                  SizedBox(
                    width: 15.w,
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
                            child: Text(
                              message.content,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
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
                                    child: Text(
                                      message.content,
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                        // overflow: TextOverflow.fade,
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
                    style: const TextStyle(color: neutral_grey),
                  ),
                ],
              ),
      ),
    );
  }
}
