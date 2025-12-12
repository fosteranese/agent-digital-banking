import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/popover.dart';
import 'package:my_sage_agent/ui/layouts/profile.layout.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routeName = '/more/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final details = (AppUtil.currentUser.user!.previewData ?? []).where((element) {
      return element.key != null && element.value != null && element.value!.isNotEmpty && element.key!.isNotEmpty;
    }).toList();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangingProfilePicture) {
          MessageUtil.displayLoading(context);
          return;
        }

        if (state is ProfilePictureChanged) {
          context.pop();
          MessageUtil.displaySuccessDialog(context, message: 'Profile Picture changed successfully');
        }

        if (state is ProfilePictureError) {
          context.pop();
          MessageUtil.displayErrorDialog(context, message: state.result.message);
        }
      },
      builder: (context, state) {
        return ProfileLayout(
          backgroundColor: Colors.white,
          showBackBtn: true,
          showNavBarOnPop: true,
          title: '',
          profileHeight: 170,
          useSliverAppBar: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/img/bg.png'), fit: BoxFit.cover),
            ),
            child: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(color: Colors.white, height: 90, width: double.maxFinite),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _onEditPicture,
                          child: SizedBox(
                            width: 130,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: Offset(0, 2))],
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      if (AppUtil.currentUser.profilePicture?.isNotEmpty ?? false) {
                                        return CircleAvatar(radius: 40, backgroundColor: Color(0xffD9D9D9), backgroundImage: MemoryImage(base64Decode(AppUtil.currentUser.profilePicture!)));
                                      }

                                      return CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/img/user.png'));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(AppUtil.currentUser.user?.name ?? '', style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: details.length,
              itemBuilder: (_, index) {
                final item = details[index];
                if (item.key?.toLowerCase() != 'verification status') {
                  return ReceiptItem(label: item.key!, name: item.value ?? '');
                }

                return ReceiptItem(
                  label: item.key!,
                  name: item.value ?? '',
                  trailing: item.value?.toUpperCase() != 'YES'
                      ? SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight.withAlpha(89), foregroundColor: Colors.black, elevation: 0),
                            child: const Text('Verify'),
                          ),
                        )
                      : null,
                );
              },
              separatorBuilder: (_, _) {
                return Divider(color: Color(0xffF8F8F8), thickness: 1);
              },
            ),
          ),
        );
      },
    );
  }

  static void _onEditPicture() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Update Profile Picture', style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                const SizedBox(height: 30),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);

                    final picker = ImagePicker();
                    final file = await picker.pickImage(source: ImageSource.camera);

                    if (file == null) {
                      return;
                    }

                    final bytes = await file.readAsBytes();
                    final base64Image = base64Encode(bytes);

                    MyApp.navigatorKey.currentContext!.read<AuthBloc>().add(ChangeProfilePicture(routeName: ProfilePage.routeName, picture: base64Image));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text('Take a picture', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);

                    final result = await FilePicker.platform.pickFiles(dialogTitle: 'Change Profile Picture', type: FileType.image);

                    if (result == null) {
                      return;
                    }

                    final file = File(result.files.single.path ?? '');
                    final bytes = await file.readAsBytes();
                    final base64Image = base64Encode(bytes);

                    MyApp.navigatorKey.currentContext!.read<AuthBloc>().add(ChangeProfilePicture(routeName: ProfilePage.routeName, picture: base64Image));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_outlined),
                  title: Text('Select from Gallery', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);

                    final result = await FilePicker.platform.pickFiles(dialogTitle: 'Change Profile Picture', allowedExtensions: ['jpg', 'jpeg', 'png'], type: FileType.custom);

                    if (result == null) {
                      return;
                    }

                    final file = File(result.files.single.path ?? '');
                    final bytes = await file.readAsBytes();
                    final base64Image = base64Encode(bytes);

                    MyApp.navigatorKey.currentContext!.read<AuthBloc>().add(ChangeProfilePicture(routeName: ProfilePage.routeName, picture: base64Image));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.perm_media_outlined),
                  title: Text('Browse for picture', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.label, required this.name, this.trailing, this.valueTextAlignment = TextAlign.right});

  final String label;
  final String name;
  final Widget? trailing;
  final TextAlign valueTextAlignment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: PrimaryTextStyle(color: const Color(0xff7D7D7D), fontSize: 14, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        name,
        style: PrimaryTextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: trailing,
    );
  }
}
