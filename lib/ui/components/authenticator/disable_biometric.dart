import 'package:flutter/material.dart';

class DisableBiometricIcon extends StatefulWidget {
  const DisableBiometricIcon({super.key, this.size = 20});

  final double size;

  @override
  State<DisableBiometricIcon> createState() => _DisableBiometricIconState();
}

class _DisableBiometricIconState extends State<DisableBiometricIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.block_outlined, color: Theme.of(context).primaryColor);
  }
}
