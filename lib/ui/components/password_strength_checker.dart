import 'package:flutter/material.dart';

import '../../utils/theme.util.dart';

class PasswordStrengthChecker extends StatefulWidget {
  const PasswordStrengthChecker({super.key, required this.controller, required this.validFunc});

  final TextEditingController controller;
  final void Function(bool status) validFunc;

  @override
  State<PasswordStrengthChecker> createState() => _PasswordStrengthCheckerState();
}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});

      widget.validFunc(
        _lowercaseLetter && _uppercaseLetter && _number && _specialCharacter && _passwordLength,
      );
    });
    super.initState();
  }

  bool _lowercaseLetter = false;
  bool _uppercaseLetter = false;
  bool _number = false;
  bool _specialCharacter = false;
  bool _passwordLength = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          PasswordRule(
            rule: 'At least one (1) lowercase letter',
            ruleFunc: (password) {
              _lowercaseLetter = password.contains(RegExp(r'[a-z]'));
              return _lowercaseLetter;
            },
            password: widget.controller.text,
          ),
          PasswordRule(
            rule: 'At least one (1) uppercase letter',
            ruleFunc: (password) {
              _uppercaseLetter = password.contains(RegExp(r'[A-Z]'));
              return _uppercaseLetter;
            },
            password: widget.controller.text,
          ),
          PasswordRule(
            rule: 'At least one (1) number',
            ruleFunc: (password) {
              _number = password.contains(RegExp(r'[0-9]'));
              return _number;
            },
            password: widget.controller.text,
          ),
          PasswordRule(
            rule: 'At least one (1) special character. Example: [!@#\$%^&*(),.?":{}|<>/]',
            ruleFunc: (password) {
              _specialCharacter = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<> //]'));
              return _specialCharacter;
            },
            password: widget.controller.text,
          ),
          PasswordRule(
            rule: 'At least eight (8) characters long',
            ruleFunc: (password) {
              _passwordLength = password.length >= 8;
              return _passwordLength;
            },
            password: widget.controller.text,
          ),
        ],
      ),
    );
  }
}

class PasswordRule extends StatelessWidget {
  const PasswordRule({
    super.key,
    required this.rule,
    required this.ruleFunc,
    required this.password,
  });

  final String rule;
  final bool Function(String password) ruleFunc;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _isValid,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            rule,
            softWrap: true,
            style: TextStyle(fontFamily: ThemeUtil.fontHelveticaNeue, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget get _isValid {
    if (password.isEmpty) {
      return const Icon(Icons.info_outline, color: Colors.blue);
    }

    return ruleFunc(password)
        ? const Icon(Icons.check_circle_outline, color: Colors.green)
        : const Icon(Icons.highlight_off_outlined, color: Colors.red);
  }
}
