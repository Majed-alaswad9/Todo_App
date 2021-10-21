import 'package:TodoApp2/cubit/cubit.dart';
import 'package:TodoApp2/list/Utils.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

Widget buildTask(Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
  background: buildLeft(),
  secondaryBackground: buildRight(),
  child:   Padding(
      padding:const EdgeInsets.only(left: 10,top: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blueGrey,
            child: Text(
              '${model['time']}',
              style: (
              TextStyle(
                fontSize: 15,
                color: Colors.white,
              )
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: (
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                  ),
                ),
                Text(
                  '${model['date']}',
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(onPressed: (){
            Utils.showSnackBar(context, 'Task has been Done');
            AppCubit.get(context).UpdateDatabase(status: 'done',id: model['id']);
          },

              icon: Icon(

                Icons.check_circle_outline_outlined,

                color: Colors.green,

              ),

          ),
        ],
      ),
  ),
  onDismissed: (direction)=>dismissibleItem(context: context,index: model['id'],direction: direction),
);
Widget builderTasks({@required List<Map> task})=>ConditionalBuilder(
  condition: task.length > 0,
  builder: (context)=>ListView.separated(
      itemBuilder:(context,index)=> buildTask(task[index],context),
      separatorBuilder: (context,index)=> Padding(
        padding: const EdgeInsetsDirectional.only(start: 10.0),
        child: Container(
          color: Colors.grey,
          width: double.infinity,
          height: 1,
        ),
      ),
      itemCount: task.length
  ),
  fallback: (context)=>Container(
    child: Center(
      child: Text(
        'Not Tasks Yet',
        style: TextStyle(
          fontSize: 20,
          color: Colors.blueGrey,
        ),
      ),
    ),
  ),
);

Widget buildLeft()=>Container(
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.symmetric(horizontal: 20),
  color: Colors.green,
  child: Icon(Icons.archive,color: Colors.white,),
);

Widget buildRight()=>Container(
  alignment: Alignment.centerRight,
  padding: EdgeInsets.symmetric(horizontal: 20),
  color: Colors.red,
  child: Icon(Icons.delete,color: Colors.white,),
);

void dismissibleItem({
  @required BuildContext context,
  @required int index,
  @required DismissDirection direction
}){
  switch(direction) {
    case DismissDirection.startToEnd:
      {
        AppCubit.get(context).UpdateDatabase(status: 'archive', id: index);
        Utils.showSnackBar(context, 'Task has been archived');
        break;
      }
    case DismissDirection.endToStart:
      {
        AppCubit.get(context).deleteDatabade(id: index);
        Utils.showSnackBar(context, 'Task has been deleted');
        break;
      }
    case DismissDirection.up:
      {
        break;
      }
  }
  }

