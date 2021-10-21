import 'package:TodoApp2/cubit/cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'TodoScreen.dart';
import 'shared/listdata.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Todoscreen(),
    );
  }
}
