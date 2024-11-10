import 'package:flutter/material.dart';

class ContainerSet extends StatelessWidget {
  const ContainerSet({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(data),
    );
  }
}
