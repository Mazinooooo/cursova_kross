import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  final String value;

  const DisplayArea({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      color: Colors.grey[200],
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
