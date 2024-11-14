import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/token_services.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  AuthService authServices = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const LogoWidget(),
                _titleText(),
                _subtitleText(),
                const SizedBox(height: 10.0),
                _inputs(),
                const SizedBox(height: 30.0),
                _registerButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _titleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Cadastrar",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _subtitleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Crie uma conta na RastreiaPet",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  _inputText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _inputs() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _nameInput(),
          const SizedBox(height: 10.0),
          _emailInput(),
          const SizedBox(height: 10.0),
          _passwordInput(),
          const SizedBox(height: 10.0),
          _repasswordInput(),
        ],
      ),
    );
  }

  _nameInput() {
    return Column(
      children: [
        _inputText("Nome completo"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          name: true,
          text: 'Nome completo',
          controller: _nameController,
        ),
      ],
    );
  }

  _emailInput() {
    return Column(
      children: [
        _inputText("E-mail"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          email: true,
          password: false,
          text: 'E-mail',
          controller: _emailController,
        ),
      ],
    );
  }

  _passwordInput() {
    return Column(
      children: [
        _inputText("Senha"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: true,
          text: '*********',
          controller: _passwordController,
        ),
      ],
    );
  }

  _repasswordInput() {
    return Column(
      children: [
        _inputText("Repita sua senha"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: true,
          text: '*********',
          controller: _repasswordController,
        ),
      ],
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Cadastrar",
        onPressed: () {
          _registerButtonPressed(context);
        },
      ),
    );
  }

  _registerButtonPressed(context) {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    print(email);
    print(password);

    if (_formKey.currentState!.validate() && _passwordCorrect()) {
      authServices
          .registerUser(name: name, email: email, password: password)
          .then((error) {
        if (error == null) {
          final user = FirebaseAuth.instance.currentUser;
          _saveUserToken(user);
          Navigator.pushNamed(context, '/NavPage');
          showSnackBar(
              context: context,
              mensagem: "Usuário cadastrado com sucesso!",
              isErro:
                  false); // Defina isErro como false para uma mensagem de sucesso.
        } else {
          showSnackBar(
              context: context,
              mensagem: "Verifique seus dados",
              isErro: true); // Exibe o erro detalhado.
          print("Erro ao criar a conta: $error");
        }
      });
    } else {}
  }

  _passwordCorrect() {
    if (_passwordController.text == _repasswordController.text) {
      print("senha igual");
      return true;
    }
    print("erro senha");
    return false;
  }

  Future<void> _saveUserToken(User? user) async {
    if (user != null) {
      final userId = user.uid; // Obtém o ID do usuário
      final tokenServices = TokenServices();
      await tokenServices.saveToken(userId); // Armazena o token no Firestore
    }
  }
}
