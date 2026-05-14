import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/ui/components/location_section.cm.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.label,
    required this.onPressed,
    required this.focusNode,
    required this.onSelectLocationFromMap,
    required this.onSearch,
    required this.onNoSearchKey,
    required this.onClearLocationFromMap,
    required this.locationType,
  });

  final String label;
  final void Function() onPressed;
  final FocusNode focusNode;
  final void Function() onSelectLocationFromMap;
  final void Function(String search) onSearch;
  final void Function() onNoSearchKey;

  final void Function() onClearLocationFromMap;
  final DeliveryLocation locationType;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String search = '';
  final _controller = TextEditingController();

  late final Timer _timer;
  String _id = '';
  final _stateId = ValueNotifier('');

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _processTemplate(() {
        widget.onSearch(_controller.text.trim());
      });
    });

    super.initState();
  }

  void _processTemplate(void Function() execute) {
    final changedText = _controller.text.trim();
    if (changedText.isNotEmpty && changedText.length > 1 && search != changedText) {
      search = changedText;
      execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onTapOutside: (event) {
        widget.focusNode.unfocus();
      },
      onChanged: (value) {
        final changedText = value.trim();
        if (changedText.isEmpty) {
          _id = Uuid().v4();
          _stateId.value = Uuid().v4();
          widget.onNoSearchKey();
          return;
        }

        if (changedText.isNotEmpty && changedText.length > 1 && search != changedText) {
          _id = Uuid().v4();
          _stateId.value = Uuid().v4();
        }
      },
      focusNode: widget.focusNode,
      textAlign: TextAlign.left,
      style: GoogleFonts.carlito(fontWeight: FontWeight.bold, fontSize: 16),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 11, right: 11, top: 10, bottom: 10),
        hintText: widget.label,
        hintStyle: GoogleFonts.carlito(
          color: ThemeUtil.flora,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffD9D9D9)),
        ),
        suffixIcon: ValueListenableBuilder(
          valueListenable: _stateId,
          builder: (context, value, child) {
            return BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
              listenWhen: (previous, current) => current.action == placeAutocompleteAction,
              listener: (context, state) {
                if (state.action != placeAutocompleteAction) return;
                _id = state.id;

                if (state is DataRetrieved || state is RetrieveDataError) {
                  _stateId.value = state.id;
                }
              },
              buildWhen: (previous, current) {
                return current.action == placeAutocompleteAction;
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.text.trim().length > 1 && _id != value)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_controller.text.trim().length > 1)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                // fixedSize: Size(30, 40),
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () {
                                _controller.text = '';
                                _stateId.value = Uuid().v4();
                                widget.onClearLocationFromMap();
                              },
                              child: Icon(Icons.close, color: Colors.black),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // fixedSize: Size(30, 40),
                            padding: EdgeInsets.all(0),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: widget.onSelectLocationFromMap,
                          child: SvgPicture.asset(
                            'assets/img/pick-location.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
