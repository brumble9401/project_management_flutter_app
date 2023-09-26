import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/appbar/default_appbar.dart';
import 'package:pma_dclv/views/widgets/card/chat_card.dart';
import 'package:pma_dclv/views/widgets/loading/chat_shimmer.dart';
import 'package:shimmer/shimmer.dart';

enum _MenuValues {
  createRoom,
}

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final _auth = FirebaseAuth.instance;
  String roomUid = "";

  Future<void> createRoom(String userId1, String userId2) async {
    roomUid = await context.read<ChatCubit>().createChatRoom(userId1, userId2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
        child: Scaffold(
          appBar: MyAppBar(
            title: "Chat",
            btn: SizedBox(
              width: 40.w, // Set the desired width
              height: 40.w,
            ),
          ),
          body: Container(
            color: white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: StreamBuilder<List<WorkspaceModel>>(
                        stream: context
                            .read<WorkspaceCubit>()
                            .getWorkspaceFromUser(_auth.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String workspaceId = snapshot.data![0].uid!;
                            return Column(
                              children: [
                                Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: white,
                                  ),
                                  child: StreamBuilder<List<UserModel>>(
                                    stream: context
                                        .read<UserCubit>()
                                        .getUsersFromWorkspace(workspaceId),
                                    builder: (context, snap) {
                                      // bool isLoading = false;
                                      if (snap.hasData) {
                                        List<UserModel> users = snap.data!;
                                        // return buidChatAva(users);
                                        return buidChatAva(users);
                                      } else {
                                        return buidChatAva([]);
                                      }
                                    },
                                  ),
                                ),
                                StreamBuilder<List<ChatRoom>>(
                                  stream: context
                                      .read<ChatCubit>()
                                      .getChatRooms(_auth.currentUser!.uid),
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      List<ChatRoom> rooms = snap.data!;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: rooms.length,
                                        itemBuilder: (context, index) {
                                          return MyChatCard(
                                            chatRoom: rooms[index],
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, RouteName.chat_room,
                                                  arguments: rooms[index].id);
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return const ShimmerList();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buidChatAva(List<UserModel> users) {
    return ListView.builder(
      itemCount: users.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (users[index].id == _auth.currentUser!.uid) {
          return Container();
        }
        return StreamBuilder<List<ChatRoom>>(
          stream:
              context.read<ChatCubit>().getChatRooms(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatRoom> rooms = snapshot.data!;
              String roomId = "";
              for (ChatRoom room in rooms) {
                if (room.users!.contains(users[index].id)) {
                  roomId = room.id.toString();
                }
              }
              return Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Column(
                  children: [
                    Container(
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: neutral_grey),
                      ),
                      child: OutlinedButton(
                        onPressed: () async {
                          if (roomId == "") {
                            await createRoom(
                                users[index].id!, _auth.currentUser!.uid);
                            if (roomUid != "") {
                              Navigator.pushNamed(context, RouteName.chat_room,
                                  arguments: roomUid);
                            }
                          } else {
                            Navigator.pushNamed(context, RouteName.chat_room,
                                arguments: roomId);
                          }
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero,
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.transparent),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.w),
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: users[index].avatar != ''
                              ? NetworkImage(users[index].avatar.toString())
                              : const NetworkImage(
                                  'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                      child: Container(
                        child: Text(users[index].firstName.toString()),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Shimmer.fromColors(
                baseColor: neutral_lightgrey,
                highlightColor: neutral_grey,
                child: ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Column(
                        children: [
                          Container(
                            width: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: neutral_grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                            child: Container(
                              height: 10.h,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
