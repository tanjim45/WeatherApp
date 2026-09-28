import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String emoji;
  final String label;
  final value;

  const InfoTile({
    super.key,
    required this.emoji,
    required this.label,
     this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}
