// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class Orwidget extends StatelessWidget {
  const Orwidget({
    super.key,
    required this.color,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _line(),
        _orText(),
        _line(),
      ],
    );
  }

  _orText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "ou",
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _line() {
    return Box(
        style: Style(
      $box.width(150),
      $box.height(1),
      $box.color(color),
    ));
  }
}
