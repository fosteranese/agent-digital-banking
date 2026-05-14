import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/data/models/next_of_kin_model.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum NextOfKinOperation { list, add, edit, delete }

class RegisterClientStep3 extends StatefulWidget {
  const RegisterClientStep3({
    super.key,
    required this.kinId,
    required this.kinFullName,
    required this.kinPhoneNumber,
    required this.kinEmailAddress,
    required this.operationNotifier,
    required this.listOfKinsNotifier,
  });

  final TextEditingController kinId;
  final TextEditingController kinFullName;
  final TextEditingController kinPhoneNumber;
  final TextEditingController kinEmailAddress;
  final ValueNotifier<NextOfKinOperation> operationNotifier;
  final ValueNotifier<List<NextOfKinModel>> listOfKinsNotifier;

  @override
  State<RegisterClientStep3> createState() => _RegisterClientStep3State();
}

class _RegisterClientStep3State extends State<RegisterClientStep3> {
  @override
  initState() {
    if (widget.listOfKinsNotifier.value.isEmpty) {
      _addNextOfKin();
    } else {
      widget.operationNotifier.value = NextOfKinOperation.list;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: ValueListenableBuilder(
        valueListenable: widget.operationNotifier,
        builder: (context, value, child) {
          if (value == NextOfKinOperation.list || value == NextOfKinOperation.delete) {
            return ValueListenableBuilder(
              valueListenable: widget.listOfKinsNotifier,
              builder: (context, list, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisSize: .max,
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: .min,
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  'Next of KINs',
                                  style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600),
                                ),
                                Text(
                                  'List of next of KINs added. Click on the add button to add a new next of KIN',
                                  style: PrimaryTextStyle(
                                    fontSize: 14,
                                    fontWeight: .w400,
                                    color: ThemeUtil.flat,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.outlined(
                            onPressed: _addNextOfKin,
                            color: ThemeUtil.flat,
                            style: IconButton.styleFrom(
                              side: BorderSide(color: ThemeUtil.fade, width: 1),

                              tapTargetSize: .shrinkWrap,
                            ),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      ...list.map((item) {
                        return KinTile(
                          name: item.fullName,
                          phoneNumber: item.phoneNumber,
                          onEdit: () {
                            widget.operationNotifier.value = NextOfKinOperation.edit;
                            widget.kinId.text = item.id;
                            widget.kinFullName.text = item.fullName;
                            widget.kinPhoneNumber.text = item.phoneNumber;
                            widget.kinEmailAddress.text = item.emailAddress;
                          },
                          onDelete: () {
                            widget.operationNotifier.value = NextOfKinOperation.delete;
                            widget.kinId.text = item.id;
                            widget.kinFullName.text = item.fullName;
                            widget.kinPhoneNumber.text = item.phoneNumber;
                            widget.kinEmailAddress.text = item.emailAddress;
                            _deleteKin();
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisSize: .max,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: .min,
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          if (widget.operationNotifier.value == NextOfKinOperation.add)
                            Text(
                              'Add Next of KIN',
                              style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600),
                            ),
                          if (widget.operationNotifier.value == NextOfKinOperation.edit)
                            Text(
                              'Edit Next of KIN',
                              style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600),
                            ),
                          Text(
                            'Provide the details of your next of KIN',
                            style: PrimaryTextStyle(
                              fontSize: 14,
                              fontWeight: .w400,
                              color: ThemeUtil.flat,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.outlined(
                      onPressed: () {
                        widget.operationNotifier.value = NextOfKinOperation.list;
                      },
                      color: ThemeUtil.flat,
                      style: IconButton.styleFrom(
                        side: BorderSide(color: ThemeUtil.fade, width: 1),

                        tapTargetSize: .shrinkWrap,
                      ),
                      icon: Icon(Icons.format_list_bulleted_outlined),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                FormInput(
                  label: 'Full Name *',
                  placeholder: 'Enter full name',
                  controller: widget.kinFullName,
                  keyboardType: .name,
                ),
                FormInput(
                  label: 'Phone Number *',
                  placeholder: 'Eg. 0244123654',
                  controller: widget.kinPhoneNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: .phone,
                ),
                FormInput(
                  label: 'Email Address',
                  placeholder: 'Enter email address',
                  controller: widget.kinEmailAddress,
                  keyboardType: .emailAddress,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addNextOfKin() {
    widget.operationNotifier.value = NextOfKinOperation.add;
    widget.kinId.clear();
    widget.kinFullName.clear();
    widget.kinPhoneNumber.clear();
    widget.kinEmailAddress.clear();
  }

  void _deleteKin() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return Container(
          margin: .only(left: 10, right: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              Stack(
                alignment: .center,
                children: [
                  const Text(
                    'Delete Next of KIN',
                    textAlign: .center,
                    style: PrimaryTextStyle(
                      fontWeight: .bold,
                      fontSize: 16,
                      color: ThemeUtil.danger,
                    ),
                  ),
                  Align(
                    alignment: .centerRight,
                    child: IconButton(
                      iconSize: 18,

                      style: IconButton.styleFrom(
                        tapTargetSize: .shrinkWrap,
                        maximumSize: const Size(32, 32),
                        minimumSize: const Size(32, 32),
                        backgroundColor: ThemeUtil.offWhite,
                        fixedSize: const Size(32, 32),
                        padding: .zero,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Are you sure you want to delete ${widget.kinFullName.text} ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: ThemeUtil.subtitleGrey,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FormOutlineButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                        final list = widget.listOfKinsNotifier.value
                            .where((item) => item.id != widget.kinId.text)
                            .toList();
                        widget.listOfKinsNotifier.value = list;

                        if (list.isEmpty) {
                          _addNextOfKin();
                          return;
                        }

                        widget.operationNotifier.value = NextOfKinOperation.list;
                      },
                      text: 'Delete',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FormButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                      },
                      text: 'No, Cancel',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
