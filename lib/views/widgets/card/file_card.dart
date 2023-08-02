import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyFileCard extends StatefulWidget {
  const MyFileCard({super.key, this.fileName, this.fileUrl});

  final String? fileName;
  final String? fileUrl;

  @override
  State<MyFileCard> createState() => _MyFileCardState();
}

class _MyFileCardState extends State<MyFileCard> {
  String getFileExtension(String fileUrl) {
    final fileParts = fileUrl.split('.');
    final fileStyle = fileParts.last.split('?');
    return fileStyle.isNotEmpty ? fileStyle.first.toUpperCase() : '';
  }

  IconData getFileIcon(String fileUrl) {
    String fileExtension = getFileExtension(fileUrl);
    switch (fileExtension) {
      case 'PDF':
        return FontAwesomeIcons.filePdf;
      case 'PPTX':
        return FontAwesomeIcons.filePowerpoint;
      case 'DOC':
        return FontAwesomeIcons.fileWord;
      case 'DOCX':
        return FontAwesomeIcons.fileWord;
      case 'XLSX':
        return FontAwesomeIcons.fileExcel;
      case 'CSV':
        return FontAwesomeIcons.fileCsv;
      default:
        return FontAwesomeIcons.file;
    }
  }

  Color getFileColor(String fileUrl) {
    String fileExtension = getFileExtension(fileUrl);
    switch (fileExtension) {
      case 'PDF':
        return Colors.red;
      case 'PPTX':
        return Colors.orange;
      case 'DOC':
        return Colors.blue;
      case 'DOCX':
        return Colors.blue;
      case 'XLSX':
        return Colors.green;
      case 'CSV':
        return Colors.green;
      default:
        return neutral_grey;
    }
  }

  void openFile(String fileUrl) async {
    if (await canLaunchUrlString(fileUrl)) {
      try {
        await launchUrlString(fileUrl);
      } catch (e) {
        print("Can not open this file!");
      }
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: neutral_lightgrey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: const [
          BoxShadow(
            color: neutral_lightgrey,
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 200.w,
      child: OutlinedButton(
        onPressed: () {
          openFile(widget.fileUrl.toString());
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.zero,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.w),
              ),
            ),
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getFileColor(widget.fileUrl.toString()),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Center(
                  child: Icon(
                    getFileIcon(widget.fileUrl.toString()),
                    size: 15.sp,
                    color: white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 130.w,
              child: Text(
                widget.fileName.toString(),
                style: TextStyle(
                  color: neutral_dark,
                  fontSize: 13.sp,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
