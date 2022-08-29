import 'package:assignment_/bloc/second_screen_bloc.dart';
import 'package:assignment_/bloc/second_screen_event.dart';
import 'package:assignment_/bloc/second_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Initial Loading Test', () {
    testBloc<SecondScreenBloc, SecondScreenState>(
      build: () => SecondScreenBloc(),
      act: (bloc) => bloc.add(SetDataEvent()),
      expect: () => [const Loading(), isA<Loaded>()],
    );
  });
}
