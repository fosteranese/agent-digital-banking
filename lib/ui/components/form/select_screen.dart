import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

import '../popover.dart';
import 'input.dart';
import 'select.dart';

class FormSelectOptionScreen extends StatefulWidget {
  const FormSelectOptionScreen({super.key, required this.title, this.options = const [], required this.onSelectedOption, this.selectedOption, this.fixed, this.onSearch, this.listBuilder, this.search = '', this.fullScreen = true});

  final String title;
  final List<FormSelectOption> options;
  final void Function(FormSelectOption)? onSelectedOption;
  final FormSelectOption? selectedOption;
  final Widget? fixed;
  final void Function(String key)? onSearch;
  final Widget Function(BuildContext context, String key)? listBuilder;
  final String search;
  final bool fullScreen;

  @override
  State<FormSelectOptionScreen> createState() => _FormSelectOptionScreenState();
}

class _FormSelectOptionScreenState extends State<FormSelectOptionScreen> {
  late FormSelectOption? _selectedOption = widget.selectedOption;

  final _search = ValueNotifier<String>('');
  final _options = ValueNotifier<List<FormSelectOption>>([]);
  final _controller = TextEditingController();

  void _filterOptions(String search) {
    _options.value = widget.options.where((element) {
      return element.text!.toLowerCase().contains(search.toLowerCase()) || element.value.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    _search.value = widget.search;
    _controller.text = _search.value;
    _filterOptions(_search.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.fullScreen) {
      return LayoutBuilder(
        builder: (context, constraint) {
          return PopOver(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              height: constraint.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(height: 5),
                  FittedBox(
                    child: Text(
                      widget.title,
                      style: PrimaryTextStyle(color: Color(0xff202020), fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _getList,
                ],
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                ),
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                titleSpacing: 0,
                pinned: true,
                snap: false,
                floating: false,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FittedBox(
                    child: Text(
                      widget.title,
                      style: PrimaryTextStyle(color: const Color(0xff202020), fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                centerTitle: false,
                actionsPadding: EdgeInsets.only(right: 10),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, size: 25, color: Colors.black),
                  ),
                ],
                bottom: _searchBox,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(child: _getList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _getList {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topLeft,
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          if (widget.fixed != null) widget.fixed!,
          widget.listBuilder != null
              ? widget.listBuilder!(context, _search.value)
              : ValueListenableBuilder<List<FormSelectOption>>(
                  valueListenable: _options,
                  builder: (BuildContext context, List<FormSelectOption> options, Widget? child) {
                    return (options.isNotEmpty)
                        ? Column(
                            children: options
                                .map((option) {
                                  final list = <Widget>[];

                                  list.add(
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xffF1F1F1), width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        dense: false,
                                        leading: option.icon,
                                        title:
                                            option.label ??
                                            Text(
                                              option.text!,
                                              style: PrimaryTextStyle(color: const Color(0xff202020), fontSize: 14, fontWeight: FontWeight.w400),
                                            ),
                                        selected: _selectedOption != null && _selectedOption!.value == option.value,
                                        onTap: () {
                                          _selectedOption = option;

                                          if (widget.onSelectedOption != null) {
                                            widget.onSelectedOption!(option);
                                          }

                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        // trailing:
                                        //     option
                                        //         .trailing ??
                                        //     RadioGroup(
                                        //       groupValue: widget
                                        //           .selectedOption
                                        //           ?.value,
                                        //       onChanged:
                                        //           (_) {},
                                        //       child: Radio(
                                        //         value: option
                                        //             .value,
                                        //       ),
                                        //     ),
                                      ),
                                    ),
                                  );

                                  // list.add(
                                  //   Divider(
                                  //     color: Color(
                                  //       0xffF8F8F8,
                                  //     ),
                                  //     thickness: 1,
                                  //     height: 10,
                                  //   ),
                                  // );

                                  return list;
                                })
                                .expand((element) => element)
                                .toList(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50),
                                  SvgPicture.asset('assets/img/empty.svg', width: 64),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Nothing found',
                                    style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  if (widget.fullScreen) const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          );
                  },
                ),
        ],
      ),
    );
  }

  PreferredSize get _searchBox {
    return PreferredSize(
      preferredSize: const Size(double.maxFinite, 57),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
          // top: 10,
        ),
        child: FormInput(
          controller: _controller,
          zeroLeftPadding: true,
          inputHeight: 40,
          bottomSpace: 0,
          color: Colors.transparent,
          onChange: (value) {
            _search.value = value;

            if (widget.onSearch != null) {
              widget.onSearch!(value);
              return;
            }

            _filterOptions(value);
          },
          suffix: ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              if (value.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    _search.value = '';
                    _controller.text = _search.value;
                    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                    _filterOptions(_search.value);
                  },
                  icon: const Icon(Icons.backspace, size: 25),
                );
              }

              return Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset('assets/img/search.svg', width: 25));
            },
            valueListenable: _search,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
