// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './second_screen_event.dart';
import '../bloc/second_screen_state.dart';
import '../models/post_response.dart';

class SecondScreenBloc extends Bloc<SecondScreenEvent, SecondScreenState> {
  _handleLoadDataEvent(
      SecondScreenEvent event, Emitter<SecondScreenState> emit) async {
    var dio = Dio();
    final response = await dio.get('http://jsonplaceholder.typicode.com/posts');
    final data = response.data
        .map<PostResponse>((element) => PostResponse.fromJson(element))
        .toList();
    emit(Loaded(data: data));
  }

  SecondScreenBloc() : super(const Loading()) {
    on<SetDataEvent>(_handleLoadDataEvent);
  }
}
