import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/card/task/no_task_card.dart';

import '../../widgets/card/task/task_card_2.dart';

class MyAllTasks extends StatefulWidget {
  const MyAllTasks({super.key, required this.tasks, required this.name});

  final List<TaskModel> tasks;
  final String name;

  @override
  State<MyAllTasks> createState() => _MyAllTasksState();
}

class _MyAllTasksState extends State<MyAllTasks> {
  late final List<TaskModel> uncompletedTasks =
      widget.tasks.where((task) => task.state == "inprogress").toList();
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapDownDetails) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapDownDetails.globalPosition);
      print(_tapPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uncompletedTasks.isEmpty) {
      return const NoTaskCard();
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 10.w,
          childAspectRatio: 0.8,
        ),
        itemCount: uncompletedTasks.length,
        itemBuilder: (context, index) {
          if (widget.name.isEmpty) {
            return MyTaskCard2(
              task: uncompletedTasks[index],
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteName.task_detail,
                  arguments: uncompletedTasks[index].id.toString(),
                );
              },
              onLongPressed: () async {
                final selectedItem = await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    _tapPosition.dx,
                    _tapPosition.dy,
                    _tapPosition.dx,
                    _tapPosition.dy,
                  ),
                  items: [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: const Text('Delete Task'),
                    ),
                    PopupMenuItem<String>(
                      value: 'markDone',
                      child: const Text('Mark as Done'),
                    ),
                  ],
                );

                if (selectedItem == 'delete') {
                  // Handle delete task action
                } else if (selectedItem == 'markDone') {
                  // Handle mark as done action
                }
              },
            );
          } else if (uncompletedTasks[index]
              .name!
              .toLowerCase()
              .startsWith(widget.name)) {
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
          } else {
            return Container();
          }
        },
      );
    }
  }
}
