import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sage_agent/data/models/place_autocomplete.modal.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

import '../../blocs/retrieve_data/retrieve_data_bloc.dart';
import '../../utils/app.util.dart';
import 'location_search_header.cm.dart';

var action = 'RetrieveLocationFromLatLng';
var placeAutocompleteAction = 'PlaceAutocompleteAction';

enum PickDeliveryActions { displayLocations, searchLocations, displayRecipient, selectFromMap }

enum PickerStatus { picking, picked }

enum DeliveryLocation { none, pickUp, dropOff }

class LocationSection extends StatefulWidget {
  const LocationSection({super.key, required this.onSelected});
  final void Function(PlaceAutocomplete) onSelected;

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _scrollController = DraggableScrollableController();
  late final _size = MediaQuery.of(context).size;
  bool _cameraMoveStarted = true;

  late double max = ((_size.height - (130 + kToolbarHeight)) + 20) / _size.height; // 0.86;
  late double min = 332.28000000000003 / _size.height; // 0.39;

  late final displayLocations = 332.28000000000003 / _size.height; // 0.39;
  late final displayRecipient = 383.40000000000003 / _size.height; // 0.45;
  final selectFromMapFixSize = 230.04000000000002;
  late final selectFromMap = selectFromMapFixSize / _size.height; // 0.27;
  late double size = displayLocations;
  late double _max = displayLocations;
  late double _min = 0.0; // displayLocations;
  final _pickerStatus = ValueNotifier(PickerStatus.picked);
  PlaceAutocomplete? locationPicked;

  final _pickUpFocusNode = FocusNode();

  final _searchHeaderAnimationValue = ValueNotifier(0.0);
  var _pickUpPlaceAutocomplete = <PlaceAutocomplete>[];
  final _placeAutocomplete = ValueNotifier<List<PlaceAutocomplete>>([]);

  PickDeliveryActions _currentAction = PickDeliveryActions.displayLocations;

  CameraPosition _currentPosition = CameraPosition(
    target: LatLng(AppUtil.location?.latitude ?? 0, AppUtil.location?.longitude ?? 0),
    zoom: 15,
  );

  @override
  void initState() {
    _scrollController.addListener(_onScrollController);
    _pickUpFocusNode.addListener(_onPickUpFocusNode);
    // context.read<RetrieveDataBloc>().add(RetrieveLocationFromLatLng(
    //       id: Uuid().v4(),
    //       action: action,
    //       latitude: AppUtil.location?.latitude ?? 0,
    //       longitude: AppUtil.location?.longitude ?? 0,
    //     ));

    Future.delayed(const Duration(seconds: 0), () {
      _openRouteSelection(_pickUpFocusNode);
    });
    super.initState();
  }

  void _onPickUpFocusNode() {
    if (_pickUpFocusNode.hasFocus) {
      _placeAutocomplete.value = _pickUpPlaceAutocomplete;
    }
  }

  void _onScrollController() {
    if (PickDeliveryActions.searchLocations == _currentAction ||
        PickDeliveryActions.displayLocations == _currentAction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final orSize = (_scrollController.size - displayLocations);
        _searchHeaderAnimationValue.value = orSize / (max - displayLocations);
      });
      return;
    }

    if (PickDeliveryActions.selectFromMap == _currentAction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final orSize = (_scrollController.size - selectFromMap);
        _searchHeaderAnimationValue.value = orSize / (max - selectFromMap);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: false,
            buildingsEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.terrain,
            initialCameraPosition: CameraPosition(
              target: LatLng(AppUtil.location?.latitude ?? 0, AppUtil.location?.longitude ?? 0),
              zoom: 15,
            ),
            padding: EdgeInsets.only(bottom: selectFromMapFixSize),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraIdle: () {
              if (!_cameraMoveStarted) {
                return;
              }
              _cameraMoveStarted = false;

              _pickerStatus.value = PickerStatus.picked;
              context.read<RetrieveDataBloc>().add(
                RetrieveLocationFromLatLng(
                  id: Uuid().v4(),
                  action: action,
                  latitude: _currentPosition.target.latitude,
                  longitude: _currentPosition.target.longitude,
                ),
              );
            },
            onCameraMoveStarted: () {
              _cameraMoveStarted = true;
            },
            onCameraMove: (position) {
              _pickerStatus.value = PickerStatus.picking;
              _currentPosition = position;
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: selectFromMapFixSize + 10, right: 20),
              child: IconButton(
                style: IconButton.styleFrom(backgroundColor: ThemeUtil.secondaryColor),
                onPressed: () {
                  _controller.future.then((controller) {
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(AppUtil.location!.latitude, AppUtil.location!.longitude),
                          zoom: 15,
                        ),
                      ),
                    );
                  });
                },
                icon: Icon(Icons.my_location_outlined, color: Colors.black),
              ),
            ),
          ),
          if (_currentAction == PickDeliveryActions.selectFromMap)
            ValueListenableBuilder(
              valueListenable: _pickerStatus,
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (value == PickerStatus.picked)
                        Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Here',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (value == PickerStatus.picking)
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      Container(
                        width: 4,
                        height: value == PickerStatus.picked ? 30 : 20,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(2.5)),
                        ),
                      ),
                      if (value == PickerStatus.picking)
                        Container(
                          height: 4,
                          width: 4,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(113),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 2,
                                // offset: Offset(0, 2),
                                color: Colors.black.withAlpha(34),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: (value == PickerStatus.picked ? 60 : 75) + selectFromMapFixSize,
                      ),
                    ],
                  ),
                );
              },
            ),
          if (_currentAction == PickDeliveryActions.selectFromMap)
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withAlpha(113)),
                    onPressed: () {
                      _openRouteSelection(_pickUpFocusNode);
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          FadeInUp(
            child: DraggableScrollableSheet(
              controller: _scrollController,
              snap: true,
              minChildSize: _min,
              maxChildSize: _max,
              initialChildSize: _min,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                        color: Colors.black.withAlpha(26),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      const SizedBox(height: 10),
                      if (_currentAction == PickDeliveryActions.searchLocations)
                        BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
                          listenWhen: (previous, current) =>
                              current.action == placeAutocompleteAction,
                          listener: (context, state) {
                            if (state is DataRetrieved) {
                              _pickUpPlaceAutocomplete = state.data as List<PlaceAutocomplete>;
                              _placeAutocomplete.value = state.data as List<PlaceAutocomplete>;
                            }
                          },
                          buildWhen: (previous, current) =>
                              current.action == placeAutocompleteAction,
                          builder: (context, state) {
                            if (state is RetrievingData && _placeAutocomplete.value.isEmpty) {
                              return LoadingList();
                            }

                            return ValueListenableBuilder(
                              valueListenable: _placeAutocomplete,
                              builder: (context, value, child) {
                                if (value.isEmpty) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: max * _size.height - 200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/img/empty.svg'),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Search for a location',
                                          style: GoogleFonts.carlito(
                                            color: ThemeUtil.flora,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: value.map((item) {
                                    return ListTile(
                                      onTap: () {
                                        widget.onSelected(item);
                                        Navigator.pop(context);
                                      },
                                      dense: true,
                                      // minTileHeight: 45.0,
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0,
                                      leading: Icon(Icons.place_outlined),
                                      title: Text(
                                        item.main,
                                        style: GoogleFonts.carlito(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        item.secondary,
                                        style: GoogleFonts.carlito(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          },
                        ),
                      if (_currentAction != PickDeliveryActions.selectFromMap)
                        ValueListenableBuilder(
                          valueListenable: _searchHeaderAnimationValue,
                          builder: (context, value, child) {
                            return _displayLocation;
                          },
                        ),
                      if (_currentAction == PickDeliveryActions.selectFromMap)
                        ValueListenableBuilder(
                          valueListenable: _searchHeaderAnimationValue,
                          builder: (context, value, child) {
                            return _selectedPlace;
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _searchHeaderAnimationValue,
            builder: (context, value, child) {
              var percentage = value > 1 ? 1.0 : value;
              if (percentage < 0) {
                percentage = 0.0;
              }
              return SearchHeader(
                percentage: percentage,
                onTapPickUp: () {},
                onSearch: (String search) {
                  context.read<RetrieveDataBloc>().add(
                    RetrievePlaces(
                      id: Uuid().v4(),
                      action: placeAutocompleteAction,
                      latitude: AppUtil.location!.latitude,
                      longitude: AppUtil.location!.longitude,
                      search: search,
                    ),
                  );
                },
                onNoSearchKey: () {
                  _placeAutocomplete.value = [];
                },
                pickUpFocusNode: _pickUpFocusNode,
                onTapSelectPickUpLocationFromMap: () =>
                    _onTapSelectPickUpLocationFromMap(DeliveryLocation.pickUp),
                onClose: _onDisplayLocations,
                onClearPickUpLocationFromMap: () {
                  _placeAutocomplete.value = [];
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onDisplayLocations() async {
    _currentAction = PickDeliveryActions.displayLocations;

    setState(() {
      _min = displayLocations;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollController.animateTo(
        displayLocations,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _max = displayLocations;
      });
    });
  }

  void _onTapSelectPickUpLocationFromMap(DeliveryLocation deliveryLocation) {
    _pickUpFocusNode.unfocus(disposition: UnfocusDisposition.scope);
    _currentAction = PickDeliveryActions.selectFromMap;

    setState(() {
      _min = selectFromMap;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollController.animateTo(
        selectFromMap,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

      setState(() {
        _max = selectFromMap;
      });
    });
  }

  void _openRouteSelection(FocusNode focusNode) {
    _currentAction = PickDeliveryActions.searchLocations;

    setState(() {
      _max = max;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollController.animateTo(
        max,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _min = max;
      });

      focusNode.requestFocus();
    });
  }

  Widget get _displayLocation {
    var percentage = _currentAction == PickDeliveryActions.selectFromMap
        ? _searchHeaderAnimationValue.value
        : 1 - _searchHeaderAnimationValue.value;

    if (percentage > 1) {
      percentage = 1;
    }
    if (percentage < 0) {
      percentage = 0;
    }

    return ClipRect(
      key: ValueKey('displayLocation'),
      child: Container(
        color: Colors.white,
        height: 276 * percentage,
        child: OverflowBox(
          minHeight: 0,
          maxHeight: 276,
          child: Opacity(
            opacity: percentage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _selectedPlace {
    var percentage =
        _currentAction == PickDeliveryActions.selectFromMap ||
            _currentAction == PickDeliveryActions.searchLocations
        ? 1 - _searchHeaderAnimationValue.value
        : _searchHeaderAnimationValue.value;
    if (percentage > 1) {
      percentage = 1;
    }
    if (percentage < 0) {
      percentage = 0;
    }

    return ClipRect(
      key: ValueKey('selectedPlace'),
      child: Container(
        color: Colors.white,
        height: 164 * percentage,
        child: OverflowBox(
          minHeight: 0,
          maxHeight: 164,
          child: Opacity(
            opacity: percentage,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Selected Location',
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        _openRouteSelection(_pickUpFocusNode);
                      },
                      icon: SvgPicture.asset(
                        'assets/img/search.svg',
                        width: 20,
                        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
                  buildWhen: (previous, current) => current.action == action,
                  builder: (context, state) {
                    if (state is DataRetrieved) {
                      locationPicked = state.data as PlaceAutocomplete;
                    }
                    return Row(
                      children: [
                        Icon(Icons.place_rounded),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            locationPicked?.description ?? '',
                            maxLines: 1,
                            style: GoogleFonts.carlito(fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                        ),
                        if (state is RetrievingData)
                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                FormButton(
                  onPressed: () async {
                    widget.onSelected(locationPicked!);
                    Navigator.pop(context);
                  },
                  text: 'Ok',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollController);
    _pickUpFocusNode.removeListener(_onPickUpFocusNode);

    super.dispose();
  }
}

class LoadingList extends StatelessWidget {
  const LoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ThemeUtil.fade,
      highlightColor: ThemeUtil.fade.withAlpha(100),
      child: Column(
        mainAxisSize: .min,
        children: [
          const SizedBox(height: 10),
          LoadingItem(),
          const SizedBox(height: 20),
          LoadingItem(),
          const SizedBox(height: 20),
          LoadingItem(),
          const SizedBox(height: 20),
          LoadingItem(),
          const SizedBox(height: 20),
          LoadingItem(),
        ],
      ),
    );
  }
}

class LoadingItem extends StatelessWidget {
  const LoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(color: ThemeUtil.fade, borderRadius: .circular(6)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(color: ThemeUtil.fade, borderRadius: .circular(6)),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 10,
                    // width: constraints.maxWidth - 50,
                    decoration: BoxDecoration(color: ThemeUtil.fade, borderRadius: .circular(6)),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
