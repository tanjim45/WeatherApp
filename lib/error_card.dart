import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String message;

  const ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Center(
        child: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
