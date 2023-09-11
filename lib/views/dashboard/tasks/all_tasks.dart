import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/views/routes/route_name.dart';

import '../../widgets/card/task/task_card_2.dart';

class MyAllTasks extends StatefulWidget {
  const MyAllTasks({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  State<MyAllTasks> createState() => _MyAllTasksState();
}

class _MyAllTasksState extends State<MyAllTasks> {
  late final List<TaskModel> uncompletedTasks =
  widget.tasks.where((task) => task.state == "inprogress").toList();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.8,
      ),
      itemCount: uncompletedTasks.length,
      itemBuilder: (context, index) {
        return MyTaskCard2(
          task: uncompletedTasks[index],
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteName.task_detail,
              arguments: uncompletedTasks[index].id.toString(),
            );
          },
        );
      },
    );
  }
}
