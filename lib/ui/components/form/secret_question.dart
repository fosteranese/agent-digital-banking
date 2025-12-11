import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/app/app_bloc.dart';
import '../../../data/models/initialization_response.dart';
import 'select.dart';

class SelectSecretQuestion extends StatefulWidget {
  const SelectSecretQuestion({
    super.key,
    this.questionController,
    this.onSelectedOption,
  });

  final TextEditingController? questionController;
  final void Function(FormSelectOption)? onSelectedOption;

  @override
  State<SelectSecretQuestion> createState() => _SelectSecretQuestionState();
}

class _SelectSecretQuestionState extends State<SelectSecretQuestion> {
  InitializationResponse? _app;

  @override
  void initState() {
    _app = context.read<AppBloc>().data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormSelect(
      controller: widget.questionController,
      label: 'Security Question',
      title: 'Choose a Question',
      placeholder: 'Choose a question',
      options: _app!.secretQuestions!
          .map((e) => FormSelectOption(
                icon: const Icon(Icons.help_outline),
                value: e.questionId!,
                label: Text(e.title!),
                showOnSelected: Text(
                  e.title!,
                  overflow: TextOverflow.ellipsis,
                ),
                text: e.title!,
              ))
          .toList(),
      onSelectedOption: widget.onSelectedOption,
    );
  }
}