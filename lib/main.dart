import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'blocs/bloc_observer.dart';
import 'repository/apiprovider_service.dart';

void main() {
  Bloc.observer = MainBlocObserver();
  final MoviesRepository moviesRepository = MoviesRepository(
    apiClient: TMDBApi(apiProvider: ApiProviderService()),
  );

  runApp(MovieFinder(moviesRepository: moviesRepository));
}

class MovieFinder extends StatelessWidget {
  final MoviesRepository moviesRepository;
  MovieFinder({this.moviesRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Text("Home App"),
    );
  }
}
