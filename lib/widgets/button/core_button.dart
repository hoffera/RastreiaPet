import "package:flutter/material.dart" hide Icon;
import "package:mix/mix.dart";

class CoreButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool funds;
  final bool logoff;
  final bool underline;
  final bool strikethrough;
  final bool checked;
  final bool cta;

  static Key keyIconBox = const Key("icon-box");
  static Key keyEndIcon = const Key("end-icon");
  static Key keyContent = const Key("content-elements");

  const CoreButton({
    super.key,
    required this.text,
    required this.color,
    this.logoff = false,
    this.checked = false,
    this.underline = false,
    this.strikethrough = false,
    this.cta = false,
    required this.funds,
  });

  @override
  Widget build(BuildContext context) {
    final styles = Style(
      $box.color(Colors.transparent),
    );

    return Box(
      style: styles,
      child: Row(
        key: keyContent,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            checked ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final HBox content = HBox(
      children: [
        _buildLabel(),
      ],
    );

    return Box(
      child: content,
    );
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: TextStyle(
        fontSize: logoff ? 20 : (funds ? 24 : 20),
        color: color,
        fontWeight: logoff
            ? FontWeight.w700
            : (funds ? FontWeight.bold : FontWeight.w700),
      ),
    );
  }
}
