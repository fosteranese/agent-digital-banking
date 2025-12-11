import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'input.dart';

class SearchBox extends StatelessWidget
    implements PreferredSizeWidget {
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
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          top: 0,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: FormInput(
                color: Color(0xffF9F9F9),
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
                prefixIconPadding: const EdgeInsets.only(
                  left: 40,
                ),
                prefix: SvgPicture.asset(
                  'assets/img/search.svg',
                  width: 20,
                ),

                suffix: Row(
                  children: [
                    if (controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          controller.text = '';
                          // _search('', _sourceList.data?.request ?? []);
                          onSearch(controller.text);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    if (onFilter != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: InkWell(
                          onTap: onFilter!,
                          child: SvgPicture.asset(
                            'assets/img/filter.svg',
                            width: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}
