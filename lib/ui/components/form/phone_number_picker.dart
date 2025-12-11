import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import '../../../main.dart';
import '../../../utils/app.util.dart';
import '../../../utils/theme.util.dart';
import '../popover.dart';
import 'input.dart';

class FormPhonePicker extends StatelessWidget {
  const FormPhonePicker({super.key, this.label = '', this.bottomSpace = 20, this.prefix, this.controller, this.placeholder, this.validation, this.showIconOnSuccessfulValidation = false, this.showIconOnFailedValidation = false, this.keyboardType, this.onSuccess, this.info, this.onSelectedOption, this.useLongList = false, this.useTextAsSelectedDisplayItem = false, this.onTap, this.showMenu = false, this.color = Colors.transparent, this.contentPadding, this.placeholderStyle, this.textAlign, this.textStyle, this.decoration, this.maxLength, this.prefixIconPadding, this.inputHeight, this.readOnly = false, this.tooltip, this.onSelected});

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
  final Widget? info;
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
  final bool readOnly;
  final String? tooltip;
  final void Function(String phoneNumber)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FormInput(readOnly: readOnly, label: label, controller: controller, tooltip: tooltip, keyboardType: TextInputType.phone, placeholder: placeholder ?? AppUtil.gh.exampleNumberMobileNational, contentPadding: const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0), onChange: (value) {}, suffix: _suffix(context)),
        ),
      ],
    );
  }

  Widget? _suffix(BuildContext context) {
    if (readOnly) {
      return null;
    }

    return IconButton(
      icon: Icon(Icons.contacts, color: ThemeUtil.secondaryColor),
      onPressed: () async {
        final flutterContactPicker = FlutterNativeContactPicker();
        var contact = await flutterContactPicker.selectContact();

        if ((contact?.phoneNumbers?.length ?? 0) > 1) {
          showModalBottomSheet<int>(
            backgroundColor: Colors.transparent,
            context: MyApp.navigatorKey.currentContext!,
            isScrollControlled: true,
            builder: (context) {
              return PopOver(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact!.fullName ?? 'Select Phone number',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ...contact.phoneNumbers!.map((phoneNumber) {
                        return ListTile(
                          onTap: () async {
                            await _onSelectedPhoneNumber(phoneNumber);
                            Navigator.pop(context);
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.phone_outlined),
                          title: Text(phoneNumber, style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                          trailing: Icon(Icons.navigate_next_outlined),
                        );
                      }),
                      // const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );

          return;
        }

        await _onSelectedPhoneNumber(contact?.phoneNumbers?.first ?? '');
      },
    );
  }

  Future<void> _onSelectedPhoneNumber(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]+'), '');

      try {
        var parsed = await parse(phoneNumber, region: AppUtil.gh.countryCode);
        phoneNumber = parsed['national'].toString();
      } catch (_) {}

      if (controller != null) {
        controller!.value = TextEditingValue(text: phoneNumber);
      }

      if (onSelected != null) onSelected!(phoneNumber);
    }
  }
}
