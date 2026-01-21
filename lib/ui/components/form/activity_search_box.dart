import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import 'input.dart';

class ActivitySearchBox extends StatefulWidget {
  const ActivitySearchBox({
    super.key,
    required this.filterBy,
    required this.controller,
    required this.onSearch,
    this.onFilter,
  });

  final ValueNotifier<Activity?> filterBy;
  final TextEditingController controller;
  final void Function(String value) onSearch;
  final void Function()? onFilter;

  @override
  State<ActivitySearchBox> createState() => _ActivitySearchBoxState();
}

class _ActivitySearchBoxState extends State<ActivitySearchBox> {
  late final _search = ValueNotifier(widget.controller.text.trim());

  @override
  initState() {
    super.initState();
    widget.controller.addListener(_onSearchTextChange);
  }

  void _onSearchTextChange() {
    _search.value = widget.controller.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.maxFinite, 50),
      child: Container(
        color: Colors.white,
        padding: const .all(20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: .spaceAround,
                crossAxisAlignment: .center,
                children: [
                  Expanded(
                    child: Text(
                      'Activities',
                      style: const PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onFilter,
                    child: Row(
                      children: [
                        Icon(Icons.filter_list_outlined),
                        const SizedBox(width: 2),
                        Text(
                          'Filter',
                          style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FormInput(
              inputHeight: 40,
              zeroLeftPadding: false,
              borderRadius: 4,
              controller: widget.controller,
              bottomSpace: 0,
              onChange: (value) {
                _search.value = value;
                widget.onSearch(value);
              },
              placeholder: 'Search ${widget.filterBy.value?.activityName ?? ''}',
              suffix: ValueListenableBuilder(
                valueListenable: _search,
                builder: (context, value, child) {
                  if (value.isNotEmpty) {
                    return IconButton(
                      onPressed: () {
                        widget.controller.text = '';
                        widget.onSearch(widget.controller.text);
                      },
                      icon: const Icon(Icons.close),
                    );
                  }

                  if (widget.onFilter != null) {
                    return Padding(
                      padding: const .symmetric(vertical: 10),
                      child: InkWell(
                        onTap: widget.onFilter!,
                        child: SvgPicture.asset('assets/img/search.svg', width: 20),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    widget.controller.removeListener(_onSearchTextChange);
    super.dispose();
  }
}
