import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../bloc/first_screen_bloc.dart';
import '../bloc/first_screen_event.dart';
import '../bloc/second_screen_bloc.dart';
import '../database/url.dart';
import 'bloc/second_screen_event.dart';
import 'screens/second_screen.dart';
import 'screens/first_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UrlAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Screen2.routeName: (context) => BlocProvider(
              create: (context) => SecondScreenBloc()..add(SetDataEvent()),
              child: const Screen2(),
            ),
      },
      home: BlocProvider(
        create: (context) => FirstScreenBloc()..add(LoadDataEvent()),
        child: const FirstScreen(title: 'Assignment'),
      ),
    );
  }
}
