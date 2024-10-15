import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de blocos a serem exibidos no carrossel
    final List<Widget> items = [
      _initial(color: AppColors.primary),
      _addPet(color: AppColors.primary),
      _map(color: AppColors.primary),
      _pin(color: AppColors.primary),
      _alert(color: AppColors.primary),
      _update(color: AppColors.primary),
      _user(color: AppColors.primary),
      _config(color: AppColors.primary),
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ClipRect(
            // Adicionado para evitar overflow
            child: CarouselSlider(
              options: CarouselOptions(
                height: 500, // altura do carrossel
                enlargeCenterPage: true, // centraliza a página em destaque
                autoPlay: false, // habilita a reprodução automática
                viewportFraction:
                    0.8, // controla a fração da largura do viewport (para exibir parte do próximo item)
              ),
              items: items,
            ),
          ),
        ),
      ),
    );
  }

  // Método para criar um bloco
  Widget _initial({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          SizedBox(child: LogoWidget()),
          const SizedBox(height: 30),
          _buildStyledText("Bem vindo ao RastreiaPet", 20, FontWeight.bold),
          _buildStyledText("A seguir as instruções para o uso do app", 17,
              FontWeight.normal),
          const SizedBox(height: 30),
          SizedBox(
              height: 50,
              child: Lottie.asset('lib/assets/images/arrowLottie.json')),
        ],
      ),
    );
  }

  Widget _addPet({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          SizedBox(
              height: 200,
              child: Image.asset("lib/assets/images/registerllogo.jpg")),
          const SizedBox(height: 30),
          _buildStyledText(
              'Comece registrando seu pet na tela de "Cadastrar novo pet".',
              20,
              FontWeight.bold),
          _buildStyledText(
              "Insira o nome do seu pet e o código da coleira e confirme para cadastrar com sucesso.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _map({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          SizedBox(
              height: 200,
              child: Lottie.asset('lib/assets/images/maplogo.json')),
          const SizedBox(height: 10),
          _buildStyledText(
              "Com o pet cadastrado, você terá acesso à tela do mapa.",
              20,
              FontWeight.bold),
          _buildStyledText(
              "Conseguindo visualizar a localização em tempo real. Você também pode compartilhar a posição atual do seu pet com outras pessoas.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _pin({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          SizedBox(
              height: 200, child: Image.asset("lib/assets/images/newpin.png")),
          _buildStyledText(
              "Clique no pin no mapa para obter informações detalhadas do seu pet.",
              20,
              FontWeight.bold),
          _buildStyledText(
              "Você poderá ver a latitude, longitude, o horário em que ele chegou à localização e também verificar o nível de bateria.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _alert({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Lottie.asset(
              'lib/assets/images/alertImage.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          _buildStyledText("Tela de criar um alerta", 20, FontWeight.bold),
          _buildStyledText(
              "Você pode definir um círculo de segurança clicando no mapa e inserindo um raio. Se o seu pet sair dessa área, você receberá uma notificação.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _update({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          Icon(
            Icons.add_alert,
            size: 150,
            color: AppColors.primary,
          ),
          _buildStyledText("Na tela de alterar a atualização da coleira.", 20,
              FontWeight.bold),
          _buildStyledText(
              "Você pode modificar a frequência com que recebe os dados. Assim, é possível optar por uma atualização mais rápida ou mais lenta, ajudando a economizar bateria.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _user({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          Icon(
            Icons.person,
            size: 150,
            color: AppColors.primary,
          ),
          const SizedBox(height: 30),
          _buildStyledText("Na página do usuário", 20, FontWeight.bold),
          _buildStyledText(
              "Você pode visualizar suas informações e editar tanto o seu nome quanto o nome do seu pet.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _config({required Color color}) {
    return _buildCarouselItem(
      color: color,
      child: Column(
        children: [
          Icon(
            Icons.settings,
            size: 150,
            color: AppColors.primary,
          ),
          const SizedBox(height: 30),
          _buildStyledText("Página de configurações", 20, FontWeight.bold),
          _buildStyledText(
              "Você pode remover seu pet, deletar seus alertas ou deslogar da sua conta.",
              17,
              FontWeight.normal),
        ],
      ),
    );
  }

  Widget _buildCarouselItem({required Color color, required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Box(
            style: Style(
              $box.borderRadius.all(20),
              $box.width(double.infinity),
              $box.height(double.infinity),
              $box.color(AppColors.background),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  StyledText _buildStyledText(
      String text, double fontSize, FontWeight fontWeight) {
    return StyledText(
      text,
      style: Style(
        $text.style.color.black(),
        $text.style.fontSize(fontSize),
        $text.style.fontWeight(fontWeight),
        $text.textAlign.center(),
      ),
    );
  }
}
