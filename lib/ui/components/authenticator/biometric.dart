import 'package:flutter/material.dart';

class BiometricIcon extends StatefulWidget {
  const BiometricIcon({super.key});

  @override
  State<BiometricIcon> createState() => _BiometricIconState();
}

class _BiometricIconState extends State<BiometricIcon> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xffE2FCFF),
      child: Icon(Icons.fingerprint_outlined, color: Theme.of(context).primaryColor),
    );
  }
}
