import 'package:dropdown_model_list/dropdown_model_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/dashboard/analytics.dart';
import 'package:pma_dclv/views/dashboard/dashboard_tab.dart';
import 'package:pma_dclv/views/dashboard/overview.dart';
import 'package:pma_dclv/views/widgets/appbar/default_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/project_create_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view-model/user/user_cubit.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int _page = 0;
  final _auth = FirebaseAuth.instance;
  String workspaceUid = "";

  void onChangePage(index) {
    setState(() {
      _page = index;
    });
  }

  _loadSelectedWorkspaceUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedWorkspaceUid = prefs.getString('selectedWorkspaceUid');
    if (selectedWorkspaceUid != null && selectedWorkspaceUid.isNotEmpty) {
      setState(() {
        workspaceUid = selectedWorkspaceUid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedWorkspaceUid();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: white),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
          child: Scaffold(
            appBar: MyAppBar(
              title: "Dashboard",
              onTap: () => showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (BuildContext context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ProjectCubit(),
                    ),
                    BlocProvider(
                      create: (context) => UserCubit(),
                    ),
                  ],
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => WorkspaceCubit(),
                      ),
                      BlocProvider(
                        create: (context) => ProjectCubit(),
                      ),
                      BlocProvider(
                        create: (context) => UserCubit(),
                      ),
                    ],
                    child: MyProjectBottomModalSheet(
                      title: "Create Project",
                      workspaceUid: workspaceUid.toString(),
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.h),
                  decoration: const BoxDecoration(
                    color: white,
                  ),
                  child: Column(
                    children: [
                      _buildDropdown(),
                      MyDashboardTab(
                        page: _page,
                        onChangePage: onChangePage,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      _page == 0
                          ? MyOverView(
                              workspaceUid: workspaceUid,
                            )
                          : const MyAnalytics(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return StreamBuilder<List<WorkspaceModel>>(
      stream: context
          .read<WorkspaceCubit>()
          .getWorkspaceFromUser(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.length > 0) {
          List<OptionItem> options = snapshot.data!
              .map((workspace) => OptionItem(
                    // Create an OptionItem using workspace properties
                    id: workspace.uid,
                    title: workspace.workspaceName!,
                  ))
              .toList();
          DropListModel workspaces = DropListModel(options);
          OptionItem optionItemSelected = OptionItem(title: "Select workspace");
          if (options.isNotEmpty) {
            if (workspaceUid != "") {
              optionItemSelected =
                  options.firstWhere((item) => item.id == workspaceUid);
            } else {
              optionItemSelected = OptionItem(title: "Select workspace");
            }
          } else {
            optionItemSelected = OptionItem(title: "Select workspace");
          }
          return SelectDropList(
            itemSelected: optionItemSelected,
            dropListModel: workspaces,
            showIcon: true, // Show Icon in DropDown Title
            showArrowIcon: true, // Show Arrow Icon in DropDown
            showBorder: true,
            paddingTop: 0,
            paddingLeft: 0,
            paddingRight: 0,
            borderColor: neutral_grey,
            arrowColor: neutral_dark,
            heightBottomContainer: snapshot.data!.length.toDouble() * 40.h,
            icon: const Icon(
              Icons.workspace_premium_outlined,
              color: neutral_dark,
            ),
            onOptionSelected: (optionItem) async {
              optionItemSelected = optionItem;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedWorkspaceUid', optionItem.id!);

              setState(() {
                workspaceUid = optionItem.id!;
              });
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
