import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/second_screen_bloc.dart';
import '../bloc/second_screen_state.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);
  static const String routeName = "/screeen2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen2'),
      ),
      body: BlocBuilder<SecondScreenBloc, SecondScreenState>(
        builder: (context, state) {
          if (state is Loaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(state.data[index].id),
                  elevation: 4,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
                    child: ListTile(
                      title: Text(
                        'Title : ${state.data[index].title}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Body : ${state.data[index].body}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 88, 88, 88),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
