import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/views/routes/route_name.dart';

import '../../../data/models/task/task_model.dart';
import '../../widgets/card/task/task_card_2.dart';

class MyCompletedTasks extends StatefulWidget {
  const MyCompletedTasks({super.key, required this.tasks, required this.name});

  final List<TaskModel> tasks;
  final String name;

  @override
  State<MyCompletedTasks> createState() => _MyCompletedTasksState();
}

class _MyCompletedTasksState extends State<MyCompletedTasks> {
  late final List<TaskModel> finishedTasks =
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
      itemCount: finishedTasks.length,
      itemBuilder: (context, index) {
        if (widget.name.isEmpty) {
          return MyTaskCard2(
            task: finishedTasks[index],
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteName.task_detail,
                arguments: finishedTasks[index].id.toString(),
              );
            },
          );
        } else if (finishedTasks[index]
            .name!
            .toLowerCase()
            .startsWith(widget.name)) {
          return MyTaskCard2(
            task: finishedTasks[index],
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteName.task_detail,
                arguments: finishedTasks[index].id.toString(),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
