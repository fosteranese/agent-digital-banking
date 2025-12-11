import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../blocs/map/map_bloc.dart';
import '../../../data/models/google_map/auto_complete_response.dart';
import 'location_picker.dart';

class LocatorSearchBox extends StatelessWidget implements PreferredSizeWidget {
  const LocatorSearchBox({
    super.key,
    required this.controller,
    this.onFilter,
    required this.selectedPredication,
    required this.getCurrentLocation,
    required this.mapBloc,
    required this.listener,
  });

  final TextEditingController controller;
  final void Function()? onFilter;
  final void Function(Predictions option) selectedPredication;
  final void Function() getCurrentLocation;
  final MapBloc mapBloc;
  final void Function(BuildContext context, MapState state) listener;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.maxFinite, 80),
      child: BlocListener<MapBloc, MapState>(
        bloc: mapBloc,
        listener: listener,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
              bottom: 5,
            ),
            // height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xffD9DADB),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                Expanded(
                  child: LocationPicker(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      hintText: 'Search',
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: controller,
                    onSelectedOption: (option) async {
                      selectedPredication(option.data);
                    },
                    onSelectedCurrentLocation: () async {
                      getCurrentLocation();
                    },
                    title: 'Search Location',
                    prefixIconPadding: EdgeInsets.zero,
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                      bottom: 0,
                      top: 0,
                    ),
                    inputHeight: 30,
                    bottomSpace: 0,
                    showSuffix: false,
                    // textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SvgPicture.asset(
                  'assets/img/search.svg',
                  width: 25,
                ),
                const SizedBox(width: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}