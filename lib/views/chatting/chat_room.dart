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
                                return ListView.builder(
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return buildMessageTile(
                                      messages[index].content,
                                      messages[index].senderId == userUid
                                          ? true
                                          : false,
                                      messages[index].createdDate,
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

  Widget buildMessageTile(String content, bool isMe, DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: isMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('h:mm a').format(time),
                    style: TextStyle(color: neutral_grey),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
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
                        content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
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
                          content,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            // overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    DateFormat('h:mm a').format(time),
                    style: TextStyle(color: neutral_grey),
                  ),
                ],
              ),
      ),
    );
  }
}
