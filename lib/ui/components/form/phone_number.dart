import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import '../../../blocs/app/app_bloc.dart';
import '../../../data/models/initialization_response.dart';
import '../../../logger.dart';
import '../../../main.dart';
import '../../../utils/app.util.dart';
import 'input.dart';
import 'select.dart';
import 'select_screen.dart';

class FormPhoneInput extends StatefulWidget {
  const FormPhoneInput({super.key, this.label = '', this.bottomSpace = 20, this.prefix, this.controller, this.placeholder, this.validation, this.showIconOnSuccessfulValidation = false, this.showIconOnFailedValidation = false, this.keyboardType, this.onSuccess, this.onSelectedOption, this.useLongList = false, this.useTextAsSelectedDisplayItem = false, this.onTap, this.showMenu = false, this.color = Colors.transparent, this.contentPadding, this.placeholderStyle, this.textAlign, this.textStyle, this.decoration, this.maxLength, this.prefixIconPadding, this.inputHeight, this.tooltip});

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? placeholder;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final TextInputType? keyboardType;
  final void Function(String)? onSuccess;
  final void Function(CountryWithPhoneCode option, String phoneNumber)? onSelectedOption;
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
  final EdgeInsetsGeometry? prefixIconPadding;
  final double? inputHeight;
  final String? tooltip;

  @override
  State<FormPhoneInput> createState() => _FormPhoneInputState();
}

class _FormPhoneInputState extends State<FormPhoneInput> {
  late CountryWithPhoneCode _selectedOption;
  late InitializationResponse _data;

  @override
  void initState() {
    _selectedOption = AppUtil.currentCountry;
    _data = context.read<AppBloc>().data!;
    if (widget.showMenu) {
      Future.delayed(const Duration(seconds: 0), () {
        _openMenu();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: TextButton(
          onPressed: () {
            if (widget.onTap != null && !widget.onTap!()) {
              return;
            }

            _openMenu();
          },
          style: TextButton.styleFrom(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(7),
            // ),
            padding: EdgeInsets.only(left: 0, right: 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              CachedNetworkImage(
                imageUrl: '${_data.imageBaseUrl}Flags/${_selectedOption.countryCode}.png',
                imageBuilder: (context, imageProvider) => CircleAvatar(radius: 12, backgroundImage: imageProvider),
                errorWidget: (context, url, error) => const CircleAvatar(radius: 12),
                placeholder: (context, url) => const CircleAvatar(radius: 12),
              ),
              const SizedBox(width: 10),
              Text('+${_selectedOption.phoneCode}', style: PrimaryTextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
      inputFormatters: [
        LibPhonenumberTextFormatter(
          shouldKeepCursorAtEndOfInput: false,
          country: _selectedOption,
          inputContainsCountryCode: true,
          phoneNumberFormat: PhoneNumberFormat.national,
          phoneNumberType: PhoneNumberType.mobile,
          onFormatFinished: (val) async {
            try {
              final phone = await parse(val, region: _selectedOption.countryCode);
              final phoneNumber = phone['e164'].toString();
              logger.i('phone number: $phoneNumber');
              if (widget.onSelectedOption != null) {
                widget.onSelectedOption!(_selectedOption, phoneNumber.replaceAll('+', ''));
              }
            } catch (e) {
              if (_selectedOption.countryCode.toUpperCase() == 'GH') {
                var phoneNumber = int.parse(val.replaceAll(' ', '').replaceAll('+', '')).toString();
                if (phoneNumber.length == 9) {
                  widget.onSelectedOption!(_selectedOption, '233$phoneNumber');
                }
                if (phoneNumber.length == 12) {
                  widget.onSelectedOption!(_selectedOption, phoneNumber);
                }
              }
            }
          },
        ),
      ],
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      label: widget.label,
      placeholder: 'Eg. ${_selectedOption.exampleNumberMobileNational}',
      tooltip: widget.tooltip,
      prefixIconPadding: EdgeInsets.only(left: 100),
    );
  }

  void _onSelected(FormSelectOption selected) {
    setState(() {
      if (widget.controller != null) {
        widget.controller!.text = '';
      }

      _selectedOption = _selectedOption = AppUtil.countries.firstWhere((option) => option.countryCode == (selected.data as CountryWithPhoneCode).countryCode);

      if (widget.onSelectedOption != null) {
        widget.onSelectedOption!(_selectedOption, '');
      }
    });
  }

  void _openMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext ?? context,
      isScrollControlled: true,
      builder: (context) {
        return MediaQuery(
          data: MediaQueryData.fromView(View.of(context)),
          child: FormSelectOptionScreen(
            title: 'Select Country',
            options: AppUtil.countries
                .map(
                  (e) => FormSelectOption(
                    text: e.countryName ?? '',
                    trailing: Text('+${e.phoneCode}'),
                    value: e.phoneCode,
                    icon: CachedNetworkImage(
                      imageUrl: '${_data.imageBaseUrl}Flags/${e.countryCode}.png',
                      imageBuilder: (context, imageProvider) => CircleAvatar(radius: 12, backgroundImage: imageProvider),
                      errorWidget: (context, url, error) => const CircleAvatar(radius: 12),
                      placeholder: (context, url) => const CircleAvatar(radius: 12),
                    ),
                    label: Text(e.countryName ?? ''),
                    selected: _selectedOption.phoneCode == e.phoneCode,
                    data: e,
                  ),
                )
                .toList(),
            onSelectedOption: _onSelected,
          ),
        );
      },
    );
  }
}
