import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String calculation;
  final String timestamp;

  const HistoryItem({
    Key? key,
    required this.calculation,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calculation),
      subtitle: Text(timestamp),
      leading: const Icon(Icons.history),
    );
  }
}
