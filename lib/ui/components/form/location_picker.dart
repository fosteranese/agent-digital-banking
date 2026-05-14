import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/place_autocomplete.modal.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/location_section.cm.dart';
import 'package:uuid/uuid.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.label,
    required this.controller,
    this.prefix,
    this.suffix,
    this.style,
    this.placeholder,
    this.placeholderStyle,
    this.focusNode,
    this.noPrefixOutside = false,
    required this.onSelected,
  });

  final String label;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? style;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final FocusNode? focusNode;
  final bool noPrefixOutside;
  final void Function(PlaceAutocomplete location) onSelected;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final _id = Uuid().v4();
  PlaceAutocomplete? _details;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RetrieveDataBloc, RetrieveDataState>(
      listener: (context, state) {
        if (state.id == _id && state.action == "RetrievePlaceDetails" && state is DataRetrieved) {
          _details = _details?.copyWith(location: state.data as LatLng);

          widget.onSelected(_details!);
          return;
        }
      },
      child: FormInput(
        onTap: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) {
              return LocationSection(
                onSelected: (details) {
                  _details = details;
                  widget.controller.text = details.main;

                  if (details.location != null) {
                    widget.onSelected(details);
                    return;
                  }

                  context.read<RetrieveDataBloc>().add(
                    RetrievePlaceDetails(
                      id: _id,
                      placeId: details.placeId,
                      action: "RetrievePlaceDetails",
                    ),
                  );
                },
              );
            },
          );
        },
        label: widget.label,
        controller: widget.controller,
        suffix: Icon(Icons.my_location_outlined),
        readOnly: true,
      ),
    );
  }
}
