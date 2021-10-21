import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'list/showDataOfScreen.dart';

class Done_Screen extends StatefulWidget {
  @override
  _Done_ScreenState createState() => _Done_ScreenState();
}

class _Done_ScreenState extends State<Done_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        listener: (context,state){},
        builder: (context,state){
          var task = AppCubit.get(context).doneTask;
          return builderTasks(task: task);
        }
    );
  }
}
