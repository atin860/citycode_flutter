import 'package:flutter/material.dart';
import 'dart:math';

class ContainerList extends StatefulWidget {
  const ContainerList({Key? key}) : super(key: key);

  @override
  State<ContainerList> createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  final random = Random();

  List<Color> colors = [];

  x() {
    colors = List.generate(
      10,
      (index) => Color.fromARGB(
        255,
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
      ),
    );
  }

  @override
  void initState() {
    x();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // scrollDirection: Axis.horizontal,
      body: Wrap(
          children: colors.map((color) {
        return Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }).toList()),
    );
  }
}
