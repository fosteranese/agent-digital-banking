import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorAgentDetailsSearchBox extends StatefulWidget {
  const SupervisorAgentDetailsSearchBox({
    super.key,
    required this.onSearch,
    required this.filterBy,
    required this.onFilter,
  });

  final ValueNotifier<String> filterBy;
  final void Function(String value) onSearch;
  final void Function() onFilter;

  @override
  State<SupervisorAgentDetailsSearchBox> createState() => _SupervisorAgentDetailsSearchBoxState();
}

class _SupervisorAgentDetailsSearchBoxState extends State<SupervisorAgentDetailsSearchBox> {
  final _controller = TextEditingController();
  final _startSearch = ValueNotifier(false);
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const .symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: .spaceAround,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: FormInput(
              focus: _focusNode,
              onFocus: (value) {
                _startSearch.value = true;
              },
              onUnfocus: () {
                _startSearch.value = false;
              },
              controller: _controller,
              onChange: (value) {
                widget.filterBy.value = value.trim();
                widget.onSearch(widget.filterBy.value);
              },
              inputHeight: 33,
              bottomSpace: 0,
              placeholder: 'Search',
              suffix: Padding(
                padding: const .symmetric(vertical: 8.0, horizontal: 0),
                child: SvgPicture.asset('assets/img/search.svg'),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _startSearch,
            builder: (context, value, child) {
              if (value) {
                return SizedBox.shrink();
              }

              return const Spacer();
            },
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.filter_list_outlined),
                const SizedBox(width: 2),
                Text('Filter', style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
