import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/task/task_model.dart';
import '../../widgets/card/task_card_2.dart';

class MyCompletedTasks extends StatefulWidget {
  const MyCompletedTasks({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  State<MyCompletedTasks> createState() => _MyCompletedTasksState();
}

class _MyCompletedTasksState extends State<MyCompletedTasks> {
  late final List<TaskModel> finishedProject =
      widget.tasks.where((task) => task.state == "finished").toList();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.8,
      ),
      itemCount: finishedProject.length,
      itemBuilder: (context, index) {
        return MyTaskCard2(
          task: finishedProject[index],
        );
      },
    );
  }
}
