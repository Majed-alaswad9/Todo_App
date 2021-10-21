import 'package:TodoApp2/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../ArchiveScreen.dart';
import '../../DoneScreen.dart';
import '../../NewTasksScreen.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit():super(Initionstate());
  static AppCubit get(context)=>BlocProvider.of(context);
  Database database;
  List<Map> newTask=[];
  List<Map> doneTask=[];
  List<Map> archiveTask=[];
  int indexItem = 0;
  List<Widget> screen = [NewTask_Screen(), Done_Screen(), ArchiveScreen()];
  List<String> Bar = ['New Task', 'Check', 'Archive'];
  IconData fbicon=Icons.edit;
  bool isBottomShet=false;
  bool isMode=true;
  IconData IconMode=Icons.light_mode;

  //Change Index the buttom navigation bar
  void changeIndex(int index){
    indexItem=index;
    emit(AppChangeIndexBNB());
  }
  void CreateDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version){
        print('created dataase');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)').then((value){
          print('table created');
        }).catchError((error){
          print('${error.toString()} error creted table');
        }
        );
      },
      onOpen: (database){
        GetData(database);
        print('database openned');
      },

    ).then((value) {
      database=value;
      emit(AppCreateDatabasestate());
    });
  }
   insertToDatabase({
    @required String title,
    @required String time,
    @required String date}
      ) async{
     await database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","new")').then((value)
      {
        print('$value inserted sucssufuly');
        emit(AppInsertDatabasestate());
        GetData(database);
      }
      ).catchError((error){
        print('error when inserted table ${error.toString()}');
      });
      return null;
    }
    );
  }
   void GetData( database) {
    newTask=[];
    doneTask=[];
    archiveTask=[];
     database.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element) {
         if(element['status']=='new')
           newTask.add(element);
         else if(element['status']=='done')
           doneTask.add(element);
         else archiveTask.add(element);
       });
       emit(AppGetDatabasestate());
     });
  }
  void ChangeButtomShet({
    @required IconData icon,
    @required bool isShow
}){
    fbicon=icon;
    isBottomShet=isShow;
    emit(AppChangeButtomSheet());
  }
  void UpdateDatabase(
      {@required String status,
       @required int id}
      )async
  {
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          emit(AppUpdateDataState());
          GetData(database);
      });
  }
  void deleteDatabade({@required int id})async{
    database.rawDelete('DELETE FROM tasks WHERE id=?',[id]).then((value){
      GetData(database);
      emit(AppDeleteDataState());
    });
  }
}