import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/first_screen_event.dart';
import '../bloc/first_screen_state.dart';
import './second_screen.dart';
import '../bloc/first_screen_bloc.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late VideoPlayerController controller;

  Future<void> resolveLoadedState(Loaded state) async {
    if (state.data.isVideo && state.isImageLoading) {
      setState(() {
        controller = VideoPlayerController.network(state.data.url)
          ..addListener(() {
            setState(() {});
          })
          ..setLooping(true)
          ..setVolume(0.5);
      });
      await controller.initialize();
      controller.play();
    } else {
      throw 'This is not a video';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<FirstScreenBloc, FirstScreenState>(
        listener: (context, state) {
          if (state is Loaded) {
            resolveLoadedState(state).then((_) {
              context.read<FirstScreenBloc>().add(ImageLoadedEvent());
            }).catchError((error) {
              log(error);
            });
          } else if (state is ImageSavedState) {
            Navigator.of(context).pushNamed(Screen2.routeName).then(
                (_) => context.read<FirstScreenBloc>().add(LoadDataEvent()));
          }
        },
        child: BlocBuilder<FirstScreenBloc, FirstScreenState>(
          builder: (context, state) {
            if (state is Loaded) {
              late Image image;
              if (!state.data.isVideo) {
                image = Image.network(state.data.url);
                image.image.resolve(const ImageConfiguration()).addListener(
                  ImageStreamListener(
                    (info, call) {
                      // print(info);
                      context.read<FirstScreenBloc>().add(ImageLoadedEvent());
                    },
                  ),
                );
              }
              print(state.isImageLoading);
              return Center(
                child: Container(
                  height: size.height * 0.5,
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: size.height * 0.06,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 206, 206, 206),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: state.data.isVideo
                      ? controller.value.isInitialized
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: VideoPlayer(controller),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: state.isImageLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : image,
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
      ),
      floatingActionButton: BlocBuilder<FirstScreenBloc, FirstScreenState>(
        builder: (context, state) {
          return (state is Loaded && !state.isImageLoading)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.read<FirstScreenBloc>().add(SaveToHiveEvent());
                  },
                  label: const Text('Save and Move'),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
