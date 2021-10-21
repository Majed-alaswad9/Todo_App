

import 'package:TodoApp2/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'ArchiveScreen.dart';
import 'DoneScreen.dart';
import 'NewTasksScreen.dart';
import 'cubit/states.dart';
import 'shared/listdata.dart';


class Todoscreen extends StatelessWidget {
    var titleController=TextEditingController();
    var timeController=TextEditingController();
    var DateController=TextEditingController();
    var keyScaffold = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (BuildContext context)=>AppCubit()..CreateDatabase(),
        child: BlocConsumer<AppCubit,AppState>(
          listener: (BuildContext context,AppState state) {
            if (state is AppInsertDatabasestate) {
              Navigator.pop(context);
              titleController.text = '';
              timeController.text = '';
              DateController.text = '';
            }
            if((AppCubit.get(context).indexItem==1||AppCubit.get(context).indexItem==2) && AppCubit.get(context).isBottomShet){
              Navigator.pop(context);
              titleController.text = '';
              timeController.text = '';
              DateController.text = '';
            }
          },
          builder: (BuildContext context,AppState state){
            AppCubit cubit=AppCubit.get(context);
            bool isVisible=cubit.indexItem==0?true:false;
            return Scaffold(
              key: keyScaffold,
              appBar: AppBar(
                backgroundColor: Colors.tealAccent,
                title: Text(
                  cubit.Bar[cubit.indexItem],
                ),
              ),
              body: cubit.screen[cubit.indexItem],
              floatingActionButton: isVisible? FloatingActionButton(
                backgroundColor: Colors.tealAccent,
                onPressed: () {
                  if(cubit.isBottomShet){
                    if(formKey.currentState.validate()){
                      cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: DateController.text);
                    }
                  }
                  else if(cubit.indexItem==0){
                    keyScaffold.currentState.showBottomSheet((context)
                    => Container(
                      padding: EdgeInsets.all(20.0),
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value){
                                showTimePicker(context: null, initialTime: TimeOfDay.now());
                              },
                              validator: (String value){
                                if(value.isEmpty)return 'must not Empity';
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Text',
                                prefixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validator: (String value){
                                if(value.isEmpty)return 'must not Empity';
                                return null;
                              },
                              onTap: (){
                                showTimePicker(context: context,initialTime: TimeOfDay.now()
                                ).then((value) {
                                  timeController.text=value.format(context);
                                });
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Time',
                                  prefixIcon: Icon(
                                    Icons.watch_later_outlined,
                                  )
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: DateController,
                              keyboardType: TextInputType.datetime,
                              validator: (String value){
                                if(value.isEmpty)return 'must not Empity';
                                return null;
                              },
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime.now(),
                                  lastDate: DateTime.parse('2022-09-16'),
                                ).then((value) {
                                  DateController.text=DateFormat.yMMMd().format(value);
                                });
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Date',
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    ).closed.then((value) {
                      cubit.ChangeButtomShet(icon: Icons.edit, isShow: false);
                    });
                    cubit.ChangeButtomShet(icon: Icons.add, isShow: true);
                  }
                },
                child: Icon(
                  cubit.fbicon,
                ),
              ) : null,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 20,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.indexItem,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'archive'),
                ],
              ),
            );
          },
        )
      );
    }

  }

