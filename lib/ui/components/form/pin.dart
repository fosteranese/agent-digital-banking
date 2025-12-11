import 'package:flutter/material.dart';

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(const CharacterInput());
      if (i < 5) {
        list.add(const SizedBox(width: 5));
      }
    }

    return Column(
      children: [
        FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: list,
          ),
        ),
        const SizedBox(height: 50),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Didn’t receive a code?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              decorationStyle: TextDecorationStyle.solid,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class CharacterInput extends StatelessWidget {
  const CharacterInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: FormField(
        builder: (field) {
          return TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xff919195),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xff919195),
                  width: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}