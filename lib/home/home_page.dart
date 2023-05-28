import 'package:flutter/material.dart';
import 'package:untitled/utils/design_one.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      decoration : DesignOne.gradientBackground(reverse: true),
      child: Center(child: Text("Welcome Home", style: DesignOne.boldMont,)),
    ));
  }
}
