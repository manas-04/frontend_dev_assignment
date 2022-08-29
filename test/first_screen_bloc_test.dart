import 'package:assignment_/bloc/first_screen_bloc.dart';
import 'package:assignment_/bloc/first_screen_event.dart';
import 'package:assignment_/bloc/first_screen_state.dart';
import 'package:assignment_/models/url_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  test('Initial Loading Test', () {
    testBloc<FirstScreenBloc, FirstScreenState>(
      build: () => FirstScreenBloc(),
      act: (bloc) => bloc.add(LoadDataEvent()),
      expect: () => [const Loading(), isA<Loaded>(), isA<Loaded>()],
    );
  });

  test('Image Saved Test', () async {
    await testBloc<FirstScreenBloc, FirstScreenState>(
        build: () => FirstScreenBloc(),
        seed: () => const Loaded(
              data: UrlResponse(
                  5344558,
                  "https://random.dog/7cc55332-05b7-4006-be2a-848226b3ef95.JPG",
                  false),
              isImageLoading: false,
            ),
        act: (bloc) => bloc..add(SaveToHiveEvent()),
        wait: const Duration(milliseconds: 3000),
        expect: () => [const ImageSavedState()]);
  });

  tearDown(() async {
    await tearDownTestHive();
  });
}
