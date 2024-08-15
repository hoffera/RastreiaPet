import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/widgets/core_button.dart';

class PrimaryButton extends StatefulWidget {
  final void Function() onPressed;
  final bool funds;
  final bool? logoff;
  final String text;
  final Color color;
  final Color textColor;

  const PrimaryButton({
    super.key,
    required this.color,
    this.logoff = false,
    required this.text,
    required this.funds,
    required this.textColor,
    required this.onPressed,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => widget.onPressed,
        borderRadius: BorderRadius.circular(20),
        child: _buildContainer(),
      ),
    );
  }

  Widget _buildContainer() {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onPressed, // Correção feita aqui
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
          child: CoreButton(
            logoff: widget.logoff!,
            funds: widget.funds,
            cta: true,
            text: widget.text,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
