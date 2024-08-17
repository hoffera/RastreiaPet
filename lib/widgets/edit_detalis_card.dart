// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';
import 'package:rastreia_pet_app/widgets/text_input.dart';

class EditDetalisCard extends StatefulWidget {
  final String cardText;
  final String infoText;
  final IconData icon;
  final Pet? pet;
  final bool user;
  final void Function()? onPressed;
  final TextEditingController controller;

  const EditDetalisCard({
    super.key,
    required this.cardText,
    required this.infoText,
    required this.icon,
    this.pet,
    required this.user,
    this.onPressed,
    required this.controller,
  });

  @override
  State<EditDetalisCard> createState() => _EditDetalisCardState();
}

class _EditDetalisCardState extends State<EditDetalisCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _card();
  }

  bool _expanded = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 125),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  _card() {
    return GestureDetector(
      onTap: () {
        if (widget.pet != null || widget.user == true) {
          setState(() {
            _expanded = !_expanded;
            _expanded ? _controller.forward() : _controller.reverse();
          });

          if (widget.onPressed != null) {
            widget.onPressed!.call();
          }
        }
      },
      child: Box(
        style: Style(
          $box.borderRadius(20),
          $box.color(AppColors.background),
          $box.padding.all(15),
        ),
        child: VBox(
          children: [
            _inicial(),
            _buildExtendedCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExtendedCard() {
    return SizeTransition(
      sizeFactor: _animation,
      child: VBox(
        children: [
          const SizedBox(
            height: 30,
          ),
          Box(
            child: _newInfo(),
          )
        ],
      ),
    );
  }

  _inicial() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _box(),
        _infoText(),
        _dropIcon(),
      ],
    );
  }

  _newInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Novo nome:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 150,
              child: TextInput(
                  off: false,
                  text: "Novo nome",
                  password: false,
                  controller: widget.controller),
            )
          ],
        ),
        const SizedBox(height: 10),
        PrimaryButton(
          funds: false,
          color: AppColors.primary,
          textColor: Colors.white,
          text: "Editar",
          onPressed: () {
            print("editado");
          },
        ),
      ],
    );
  }

  _box() {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(),
          _cardText(),
        ],
      ),
    );
  }

  _icon() {
    return Icon(
      widget.icon,
      color: AppColors.primary,
      size: 30.0,
    );
  }

  _dropIcon() {
    return const Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 20.0,
    );
  }

  _cardText() {
    return Text(
      widget.cardText,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _infoText() {
    return SizedBox(
        child: StyledText(
      widget.infoText,
      style: Style(
        $text.style.color.black(),
        $text.style.fontSize(20),
        $text.style.fontWeight(FontWeight.normal),
        $text.textAlign.center(),
      ),
    ));
  }
}
