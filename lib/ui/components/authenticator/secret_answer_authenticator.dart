import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../form/button.dart';
import '../form/outline_button.dart';
import '../form/password_input.dart';

class SecretAnswerAuthenticator extends StatefulWidget {
  const SecretAnswerAuthenticator({super.key, required this.onSuccess, required this.end});
  final void Function(String secretAnswer) onSuccess;
  final void Function() end;

  @override
  State<SecretAnswerAuthenticator> createState() => _SecretAnswerAuthenticatorState();
}

class _SecretAnswerAuthenticatorState extends State<SecretAnswerAuthenticator> {
  final _controller = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                // margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 5)],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter Your Secret Answer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 50),
                      FormPasswordInput(label: 'Secret Answer', controller: _controller, focus: _searchFocus, placeholder: 'Enter your secret answer', bottomSpace: 0),
                      const SizedBox(height: 30),
                      FormButton(
                        text: 'Submit',
                        onPressed: () {
                          widget.onSuccess(_controller.text);
                          widget.end();
                        },
                      ),
                      const SizedBox(height: 10),
                      FormOutlineButton(padding: const EdgeInsets.all(15), text: 'Cancel', onPressed: widget.end),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
