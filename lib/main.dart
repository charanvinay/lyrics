import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyrics/bloc/TracksListBloc/TracksList_bloc.dart';
import 'package:lyrics/data/repository/TracksListRepository.dart';
import 'package:lyrics/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lyrics",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => TracksListBloc(
              repository: TracksListImpl(),
            ),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
