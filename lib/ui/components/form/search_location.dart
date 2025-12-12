import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/map/map_bloc.dart';
import 'package:my_sage_agent/data/models/google_map/auto_complete_response.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/ui/components/form/select_screen.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key, required this.onSelectedCurrentLocation, required this.onSelectedOption});

  final void Function() onSelectedCurrentLocation;
  final void Function(FormSelectOption option) onSelectedOption;

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  String _search = '';
  Predictions? _prediction;

  void _onSelect(BuildContext context, Predictions e) {
    _prediction = e;
    context.read<MapBloc>().add(GetPlace(id: Uuid().v4(), placeId: e.placeId ?? ''));
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQueryData.fromView(View.of(context)),
            child: FormSelectOptionScreen(
              title: 'Search Location',
              search: _search,
              onSearch: (key) {
                _search = key;
                // _searched = false;
                context.read<MapBloc>().add(GoogleMapAutoComplete(showSilentLoading: true, id: Uuid().v4(), input: _search, latitude: AppUtil.location?.latitude ?? 0, longitude: AppUtil.location?.longitude ?? 0));
              },
              onSelectedOption: widget.onSelectedOption,
              listBuilder: (context, key) {
                return BlocConsumer<MapBloc, MapState>(
                  // bloc: _bloc,
                  listener: (context, state) {
                    if (state is AddressFromLatLngGotten) {
                      if (state.result.data?.result == null) {
                        return;
                      }
                    }

                    if (state is GettingPlace) {
                      MessageUtil.displayLoading(context);
                      return;
                    }

                    if (state is PlaceGotten) {
                      mainContext.pop();
                      final label = '${_prediction!.structuredFormatting?.mainText ?? ''}, ${_prediction!.structuredFormatting?.secondaryText ?? ''}';
                      final place = state.result.data!;
                      widget.onSelectedOption(
                        FormSelectOption(
                          value: place.result!.placeId ?? '',

                          data: state.result.data,
                          // icon: const Icon(Icons.place_rounded),
                          text: label,
                          selected: true,
                        ),
                      );
                      mainContext.pop();
                    }

                    if (state is GetPlaceError) {
                      mainContext.pop();
                      MessageUtil.displayErrorDialog(context, message: state.result.message);
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
                                    _onSelect(context, e);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                  leading: const Icon(Icons.place_rounded),
                                  title: Text(
                                    '${e.structuredFormatting?.mainText}, ${e.structuredFormatting?.secondaryText}',
                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xff242424), fontSize: 14),
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
                title: Text('Use My Current Location', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                onTap: () async {
                  widget.onSelectedCurrentLocation();
                  mainContext.pop();
                },
                trailing: const Icon(Icons.chevron_right_outlined),
              ),
            ),
          );
        },
      ),
    );
  }

  BuildContext get mainContext {
    return MyApp.navigatorKey.currentContext ?? context;
  }
}
