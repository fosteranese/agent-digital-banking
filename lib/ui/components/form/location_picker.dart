import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../blocs/map/map_bloc.dart';
import '../../../data/models/google_map/auto_complete_response.dart';
import '../../../main.dart';
import '../../../utils/app.util.dart';
import 'base_input.dart';
import 'select.dart';
import 'select_screen.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    this.label = '',
    this.bottomSpace = 20,
    this.prefix,
    this.suffix,
    this.showSuffix = true,
    this.controller,
    this.placeholder,
    this.validation,
    this.showIconOnSuccessfulValidation = false,
    this.showIconOnFailedValidation = false,
    this.onSuccess,
    this.info,
    required this.title,
    this.selectedOption,
    this.onSelectedOption,
    this.onSelectedCurrentLocation,
    this.useLongList = false,
    this.useTextAsSelectedDisplayItem = false,
    this.onTap,
    this.showMenu = false,
    this.color = Colors.transparent,
    this.contentPadding,
    this.placeholderStyle,
    this.textAlign,
    this.textStyle,
    this.decoration,
    this.maxLength,
    this.prefixIconPadding,
    this.inputHeight,
    this.readOnly = false,
    this.tooltip,
  });

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final Widget? suffix;
  final bool showSuffix;
  final TextEditingController? controller;
  final String? placeholder;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final void Function(String)? onSuccess;
  final Widget? info;
  final String title;
  final FormSelectOption? selectedOption;
  final void Function(FormSelectOption option)? onSelectedOption;
  final void Function()? onSelectedCurrentLocation;
  final bool useLongList;
  final bool useTextAsSelectedDisplayItem;
  final bool Function()? onTap;
  final bool showMenu;
  final Color color;
  final EdgeInsets? contentPadding;
  final TextStyle? placeholderStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int? maxLength;
  final EdgeInsets? prefixIconPadding;
  final double? inputHeight;
  final bool readOnly;
  final String? tooltip;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  FormSelectOption? _selectedOption;
  final _bloc = MapBloc();
  late Timer _timer;

  late final String _id;
  String _search = '';
  bool _searched = false;

  @override
  void initState() {
    const uuid = Uuid();
    _id = uuid.v4();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_searched) {
        return;
      }
      _bloc.add(
        GoogleMapAutoComplete(
          input: _search,
          latitude: AppUtil.location?.latitude ?? 0,
          longitude: AppUtil.location?.longitude ?? 0,
          id: _id,
          showSilentLoading: false,
        ),
      );
      _searched = true;
    });

    Future.delayed(const Duration(seconds: 0), () {
      if (widget.selectedOption != null) {
        _onSelected(widget.selectedOption!);
      }
    });

    if (widget.showMenu) {
      Future.delayed(const Duration(seconds: 0), () {
        _openMenu();
      });
    }

    super.initState();

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        if (widget.controller!.text.isEmpty) {
          _selectedOption = null;
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BaseFormInput(
        hideOnTapOutside: true,
        focus: FocusNode(),
        multiLine: false,
        focusedColor: Colors.transparent,
        onTap: widget.readOnly
            ? null
            : () {
                if (widget.onTap != null && !widget.onTap!()) {
                  return;
                }

                _selectedOption = null;

                if (widget.controller != null) {
                  widget.controller?.text = '';
                }

                _openMenu();
              },
        inputHeight: widget.inputHeight,
        bottomSpace: widget.bottomSpace,
        controller: widget.controller,
        key: widget.key,
        readOnly: true,
        label: widget.label,
        onSuccess: widget.onSuccess,
        placeholder: widget.placeholder,
        placeholderStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        prefix: _prefix,
        showIconOnFailedValidation: widget.showIconOnFailedValidation,
        showIconOnSuccessfulValidation: widget.showIconOnFailedValidation,
        zeroLeftPadding: true,
        suffix: widget.showSuffix
            ? (widget.suffix ??
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(Icons.place_outlined)],
                  ))
            : null,
        suffixIconConstraints: widget.showSuffix ? const BoxConstraints(maxWidth: 80) : null,
        validation: widget.validation,
        info: widget.info,
        color: widget.color,
        contentPadding: widget.contentPadding,
        textAlign: widget.textAlign,
        textStyle: widget.textStyle,
        decoration: widget.decoration,
        maxLength: widget.maxLength,
        prefixIconPadding: widget.prefixIconPadding,
        tooltip: widget.tooltip,
      ),
    );
  }

  void _onSelected(FormSelectOption selected) {
    widget.controller?.text = selected.text ?? '';
    if (widget.onSelectedOption != null) {
      _selectedOption = selected;
      widget.onSelectedOption!(_selectedOption!);
    }
    setState(() {});
  }

  Widget? get _prefix {
    if (_selectedOption == null) {
      return widget.prefix;
    }

    if (widget.useTextAsSelectedDisplayItem ||
        (_selectedOption!.text != null && _selectedOption!.text!.isNotEmpty)) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 40),
        child:
            _selectedOption?.showOnSelected ??
            Container(
              padding: const EdgeInsets.only(left: 0),
              width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedOption!.text!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ),
      );
    }

    if (_selectedOption!.label != null) {
      return _selectedOption!.label!;
    }

    return widget.prefix;
  }

  void _openMenu() {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext ?? context,
      isScrollControlled: true,
      barrierColor: Colors.white.withAlpha(153),
      useSafeArea: false,
      builder: (context) {
        return MediaQuery(
          data: MediaQueryData.fromView(View.of(context)),
          child: FormSelectOptionScreen(
            title: widget.title,
            search: _search,
            onSearch: (key) {
              _search = key;
              _searched = false;
            },
            onSelectedOption: _onSelected,
            listBuilder: (context, key) {
              return BlocConsumer<MapBloc, MapState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is AddressFromLatLngGotten) {
                    if (state.result.data?.result == null) {
                      return;
                    }
                  }
                },
                builder: (context, state) {
                  List<Predictions> predications = [];
                  if (state is GoogleMapAutoCompleted) {
                    predications = state.result.data?.predictions ?? [];
                  }
                  if (state is GoogleMapAutoCompletedSilently) {
                    predications = state.result.data?.predictions ?? [];
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        if (predications.isNotEmpty) const Divider(thickness: 0.4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: predications.map((e) {
                              return ListTile(
                                onTap: () {
                                  final label =
                                      '${e.structuredFormatting?.mainText ?? ''}, ${e.structuredFormatting?.secondaryText ?? ''}';
                                  _selectedOption = FormSelectOption(
                                    value: e.placeId ?? '',
                                    data: e,
                                    // icon: const Icon(Icons.place_rounded),
                                    text: label,
                                    selected: true,
                                  );

                                  _onSelected(_selectedOption!);
                                  Navigator.pop(MyApp.navigatorKey.currentContext ?? context);
                                },
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                leading: const Icon(Icons.place_rounded),
                                title: Text(
                                  '${e.structuredFormatting?.mainText}, ${e.structuredFormatting?.secondaryText}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff242424),
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            fixed: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.gps_fixed_outlined, color: Theme.of(context).primaryColor),
              title: Text(
                'Use My Current Location',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                if (widget.onSelectedCurrentLocation == null) {
                  Navigator.pop(MyApp.navigatorKey.currentContext ?? context);
                  return;
                }

                widget.onSelectedCurrentLocation!();
                Navigator.pop(MyApp.navigatorKey.currentContext ?? context);
              },
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _bloc.close();
    super.dispose();
  }
}
