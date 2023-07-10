import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onClicked,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(20),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 24),
    ),
  );
}