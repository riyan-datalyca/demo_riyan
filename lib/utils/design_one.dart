import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class DesignOne {
  static BoxDecoration gradientBackground({bool reverse = false}) {
    List<Color> cols = [const Color(0xfffbed96), const Color(0xffabecd6)];

    return BoxDecoration(
      gradient: LinearGradient(
        begin: const FractionalOffset(0.0, 0.4),
        end: const FractionalOffset(0.9, 0.7),
        stops: const [0.1, 0.9],
        colors: reverse ? cols.reversed.toList() : cols,
      ),
    );
  }

  static BoxDecoration inputFieldDecoration() {
    return BoxDecoration(
      boxShadow: const [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0.0, 16.0)),
      ],
      borderRadius: BorderRadius.circular(12.0),
      gradient: const LinearGradient(
        begin: FractionalOffset(0.0, 0.4),
        end: FractionalOffset(0.9, 0.7),
        stops: [0.2, 0.9],
        colors: [
          Color(0xffFFC3A0),
          Color(0xffFFAFBD),
        ],
      ),
    );
  }

  Widget circularLogo() {
    return const Center(
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text('Logo'),
        ),
      ),
    );
  }

  static InputDecoration inputDecoration =
      const InputDecoration(border: InputBorder.none);

  static TextStyle boldMont = const TextStyle(
      color: Color(0xff353535),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
      fontFamily: 'Montserrat');

  static PinDecoration customPinDecoration(BuildContext context) {
    return CirclePinDecoration(
      strokeColorBuilder: PinListenColorBuilder(
        const Color(0xffFFC3A0),
        const Color(0xffFFAFBD),
      ),
    );
  }
}
