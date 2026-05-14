import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'location_input.cm.dart';
import 'location_section.cm.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.percentage,
    required this.onTapPickUp,
    required this.onClose,
    required this.pickUpFocusNode,
    required this.onTapSelectPickUpLocationFromMap,
    required this.onSearch,
    required this.onNoSearchKey,
    required this.onClearPickUpLocationFromMap,
  });

  final double percentage;
  final void Function() onTapPickUp;
  final void Function() onClose;
  final FocusNode pickUpFocusNode;
  final void Function() onTapSelectPickUpLocationFromMap;
  final void Function(String search) onSearch;
  final void Function() onNoSearchKey;
  final void Function() onClearPickUpLocationFromMap;

  @override
  Widget build(BuildContext context) {
    final size = (130 + kToolbarHeight);
    return ClipRect(
      child: Container(
        height: size * percentage,
        color: Colors.white,
        child: OverflowBox(
          maxHeight: size,
          minWidth: 0,
          child: Opacity(
            opacity: percentage,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10 + kToolbarHeight,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0, -3),
                    color: Colors.black.withAlpha(50),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Search Location',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: IconButton.styleFrom(
                              // backgroundColor: Colors.black.withOpacity(0.1),
                              ),
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                    LocationInput(
                      label: 'Search',
                      onPressed: onTapPickUp,
                      focusNode: pickUpFocusNode,
                      onSelectLocationFromMap: onTapSelectPickUpLocationFromMap,
                      onClearLocationFromMap: onClearPickUpLocationFromMap,
                      onSearch: onSearch,
                      onNoSearchKey: onNoSearchKey,
                      locationType: DeliveryLocation.pickUp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
