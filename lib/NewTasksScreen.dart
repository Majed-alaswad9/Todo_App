import 'package:TodoApp2/cubit/cubit.dart';
import 'package:TodoApp2/list/showDataOfScreen.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/states.dart';
import 'shared/listdata.dart';

class NewTask_Screen extends StatefulWidget {
  @override
  _NewTask_ScreenState createState() => _NewTask_ScreenState();
}

class _NewTask_ScreenState extends State<NewTask_Screen> {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppState>(
        listener: (context,state){},
        builder: (context,state){
          var task = AppCubit.get(context).newTask;
          return builderTasks(task: task);
        }
    );
  }
}
