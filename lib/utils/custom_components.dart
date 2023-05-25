import 'package:flutter/material.dart';

class ElevatedContainerCustom extends StatefulWidget {
  final Widget child;

  const ElevatedContainerCustom({Key? key, required this.child})
      : super(key: key);

  @override
  State<ElevatedContainerCustom> createState() =>
      _ElevatedContainerCustomState();
}

class _ElevatedContainerCustomState extends State<ElevatedContainerCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.grey, blurRadius: 5.0, offset: Offset(2.0, 2.0))
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0)),
      child: widget.child,
    );
  }
}
