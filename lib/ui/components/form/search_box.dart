import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import 'input.dart';

class SearchBox extends StatelessWidget implements PreferredSizeWidget {
  const SearchBox({
    super.key,
    this.filterBy,
    required this.controller,
    required this.onSearch,
    this.onFilter,
  });

  final String? filterBy;
  final TextEditingController controller;
  final void Function(String value) onSearch;
  final void Function()? onFilter;

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
                      'Collections',
                      style: const PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
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
              controller: controller,
              bottomSpace: 0,

              onChange: (value) {
                // _search(value, _sourceList.data?.request ?? []);
                onSearch(value);
              },
              placeholder: 'Search ${filterBy ?? ''}',
              suffix: Builder(
                builder: (context) {
                  if (controller.text.isNotEmpty) {
                    return IconButton(
                      onPressed: () {
                        controller.text = '';
                        // _search('', _sourceList.data?.request ?? []);
                        onSearch(controller.text);
                      },
                      icon: const Icon(Icons.close),
                    );
                  }
                  if (onFilter != null) {
                    return Padding(
                      padding: const .symmetric(vertical: 10),
                      child: InkWell(
                        onTap: onFilter!,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
