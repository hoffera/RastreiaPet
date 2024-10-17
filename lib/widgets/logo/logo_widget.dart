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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _logo();
  }

  _logoImage() {
    return SizedBox(
      width: 450, // Defina a largura desejada
      height: 450, // Defina a altura desejada
      child: Image.asset('lib/assets/images/rastreiaPetLogo.png'),
    );
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
            child: _logoImage(),

            // _controller.value.isInitialized
            //     ? AspectRatio(
            //         aspectRatio: _controller.value.aspectRatio,
            //         child: VideoPlayer(_controller),
            //       )
            //     : _logoImage(), // Substitua pelo caminho da sua imagem
          ),
        ),
      ),
    );
  }
}
