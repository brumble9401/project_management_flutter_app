import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pma_dclv/view-model/projects/project_cubit.dart';

class TextEditingPage extends StatefulWidget {
  const TextEditingPage({super.key, required this.controller, this.projectUid});

  final quill.QuillController controller;
  final String? projectUid;

  @override
  State<TextEditingPage> createState() => _TextEditingPageState();
}

class _TextEditingPageState extends State<TextEditingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: neutral_dark),
              onPressed: () => Navigator.pop(context, widget.controller.document.toPlainText().toString()),
            ),
            title: Text(
              "Description",
              style: TextStyle(
                color: neutral_dark,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
            backgroundColor: white,
            iconTheme: const IconThemeData(color: neutral_dark),
            actions: [
              TextButton(
                onPressed: (){
                  context.read<ProjectCubit>().updateDescription(widget.controller, widget.projectUid.toString());
                  Navigator.pop(context);
                  },
                child: const Text('Save'),
              ),
            ],
          ),
          body: Column(
            children: [
              quill.QuillToolbar.basic(controller: widget.controller),
              Expanded(
                  child: Container(
                    color: white,
                    padding: EdgeInsets.all(10.w),
                    child: quill.QuillEditor.basic(controller: widget.controller, readOnly: false),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
