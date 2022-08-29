import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './first_screen_event.dart';
import '../bloc/first_screen_state.dart';
import '../models/url_response.dart';

class FirstScreenBloc extends Bloc<FirstScreenEvent, FirstScreenState> {
  FirstScreenBloc() : super(const Loading()) {
    on<LoadDataEvent>(_handleLoadDataEvent); // on x event handler
    on<SaveToHiveEvent>(_handleSaveToHiveEvent);
    on<ImageLoadedEvent>(_handleImageLoadedEvent);
  }

  _handleSaveToHiveEvent(
      FirstScreenEvent event, Emitter<FirstScreenState> emit) async {
    if (state is Loaded) {
      (await Hive.openBox('box')).put('imageUrl', (state as Loaded).data.url);
      emit(const ImageSavedState());
    }
  }

  _handleImageLoadedEvent(
      FirstScreenEvent event, Emitter<FirstScreenState> emit) {
    if (state is Loaded) {
      emit(Loaded(data: (state as Loaded).data, isImageLoading: false));
    }
  }

  _handleLoadDataEvent(
      LoadDataEvent event, Emitter<FirstScreenState> emit) async {
    var dio = Dio();
    final response = await dio.get('https://random.dog/woof.json');
    final data = UrlResponse.fromJson(response.data);
    emit(Loaded(data: data, isImageLoading: true));
  }
}
