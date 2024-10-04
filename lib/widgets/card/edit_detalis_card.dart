// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';

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

  final _formKey = GlobalKey<FormState>();
  bool _expanded = false;
  AuthService authServices = AuthService();

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
      child: SingleChildScrollView(
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

  _input() {
    return Form(
        key: _formKey,
        child: SizedBox(
          child: TextInput(
              off: false,
              text: "Nome",
              password: false,
              controller: widget.controller),
        ));
  }

  _newInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Insira o novo nome:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _input(),
          ],
        ),
        const SizedBox(height: 10),
        PrimaryButton(
          funds: false,
          color: AppColors.primary,
          textColor: Colors.white,
          text: "Editar",
          onPressed: () {
            if (widget.user) {
              _editUserPressed(context);
            } else {
              _editPetPressed(context);
              // _editPetPressed(context);
            }
          },
        ),
      ],
    );
  }

  _editUserPressed(context) {
    String name = widget.controller.text;

    if (name != "") {
      authServices.editUser(name: name).then((error) {
        if (error != null) {
          showSnackBar(context: context, mensagem: error, isErro: true);
        } else {
          User? user = FirebaseAuth.instance.currentUser;
          user!.reload(); // Recarrega os dados do usuário
          user = FirebaseAuth.instance.currentUser;
          print("user!.displayName");
          print(user!.displayName);
          showSnackBar(
              context: context,
              mensagem: "Nome atualizado com sucesso!",
              isErro: false);
        }
      });
    } else {
      showSnackBar(
          context: context, mensagem: "Insira um novo Nome!", isErro: true);
    }
  }

  _editPetPressed(context) async {
    PetService petService = PetService();
    String name = widget.controller.text;
    if (widget.pet != null) {
      await petService.updatePetName(
        newName: name,
      );
      showSnackBar(
          context: context, mensagem: "Nome do Pet alterado!", isErro: false);
    }
    setState(() {}); // Atualiza a UI
  }

  _box() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(),
          SizedBox(width: 10),
          _cardText(),
        ],
      ),
    );
  }

  _icon() {
    return Icon(
      widget.icon,
      color: AppColors.primary,
      size: 24.0,
    );
  }

  _dropIcon() {
    return const Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 18.0,
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
          $text.style.fontSize(16),
          $text.style.fontWeight(FontWeight.normal),
          $text.textAlign.start(),
          $text.overflow.ellipsis(),
          // Mantenha o overflow padrão
        ),
      ),
    );
  }
}
