import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:video_player/video_player.dart';

class LogoWidget extends StatefulWidget {
  const LogoWidget({super.key});

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return _logo();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'lib/assets/images/logovideo3.mp4', // Substitua pelo caminho do seu vídeo
    )
      ..setLooping(true) // Define o vídeo para rodar em loop
      ..initialize().then((_) {
        // Assegura que o vídeo esteja inicializado antes de chamar setState
        setState(() {
          _controller.play();
          _controller.setPlaybackSpeed(0.5);
        });
      });
  }

  _logo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: 200,
        child: Container(
          width: double.infinity,
          color: AppColors.background,
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(), // Mostra um indicador de carregamento enquanto o vídeo é carregado
          ),
        ),
      ),
    );
  }
}
