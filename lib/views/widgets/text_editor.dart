import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class MyTextEditor extends StatefulWidget {
  const MyTextEditor({super.key});

  @override
  State<MyTextEditor> createState() => _MyTextEditorState();
}

class _MyTextEditorState extends State<MyTextEditor> {
  late quill.QuillController _controller;
  late ScrollController _scrollController;
  // bool _showComment = false;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
    _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     setState(() {
  //       _showComment = true;
  //     });
  //   } else {
  //     setState(() {
  //       _showComment = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final ProjectModel project =
        ModalRoute.of(context)!.settings.arguments as ProjectModel;

    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
          child: SafeArea(
            child: Scaffold(
              appBar: MyCenterTitleAppBar(
                title: project.name.toString(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 10.w),
                child: Container(
                  decoration: const BoxDecoration(
                    color: white,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        quill.QuillToolbar.basic(
                          controller: _controller,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: quill.QuillEditor(
                            controller: _controller,
                            scrollable: true,
                            focusNode: FocusNode(),
                            autoFocus: true,
                            scrollController: ScrollController(),
                            readOnly: false,
                            padding: EdgeInsets.all(10.h),
                            expands: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
