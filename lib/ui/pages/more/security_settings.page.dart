import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/blocs/security_settings/security_settings_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/general_flow/category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/item.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:uuid/uuid.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});
  static const routeName = '/more/security-settings';

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  GeneralFlowCategory? _sourceList;
  late List<GeneralFlowForm> _list = [];
  String _imageBaseUrl = '';
  String _imageDirectory = '';
  final _refreshController = GlobalKey<RefreshIndicatorState>();

  String _id = '';
  final String _action = 'B534D7FC-5365-4CBE-9CB2-D2AE36C2C173';
  Category? _category;
  String _loginId = '';
  String _transactionId = '';

  @override
  void initState() {
    _load(skipSavedData: false);
    super.initState();
  }

  void _load({required bool skipSavedData}) {
    _id = Uuid().v4();
    context.read<RetrieveDataBloc>().add(RetrieveCategories(activityId: 'B534D7FC-5365-4CBE-9CB2-D2AE36C2C173', endpoint: 'FBLOnline/categories/B534D7FC-5365-4CBE-9CB2-D2AE36C2C173', id: _id, action: _action, skipSavedData: skipSavedData, activityType: ActivityTypesConst.fblOnline));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SecuritySettingsBloc, SecuritySettingsState>(
      listener: (context, state) {
        if (state is PinAuthenticationError) {
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      child: BlocBuilder<BiometricBloc, BiometricState>(
        builder: (context, state) {
          final bloc = context.read<BiometricBloc>();
          return MainLayout(
            refreshController: _refreshController,
            onRefresh: () async {
              _load(skipSavedData: true);
            },
            showBackBtn: true,
            title: _sourceList?.category?.catName ?? 'Security',
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
                      listener: (context, state) {
                        if (state is! RetrievingData && state.id == _id) {
                          MainLayout.stopRefresh(context);
                          return;
                        }
                      },
                      builder: (context, state) {
                        if (state is DataRetrieved && state.data is Response<GeneralFlowCategory> && state.id == _id) {
                          final response = state.data;

                          _imageBaseUrl = response.imageBaseUrl ?? '';
                          _imageDirectory = response.imageDirectory ?? '';
                          _list = response.data?.forms ?? [];
                          _category = response.data?.category;
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ..._list
                                .map((form) {
                                  final list = <Widget>[];

                                  list.add(
                                    Item(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context.push(
                                          ProcessFormPage.routeName,
                                          extra: {
                                            'form': form,
                                            'amDoing': AmDoing.transaction,
                                            'activity': ActivityDatum(
                                              activity: Activity(
                                                activityId: _category?.activityId,
                                                // _action,
                                                activityType: form.activityType,
                                              ),
                                              imageDirectory: _imageDirectory,
                                            ),
                                          },
                                        );
                                      },
                                      title: form.formName ?? '',
                                      subtitle: form.description ?? '',
                                      icon: CachedNetworkImage(
                                        imageUrl: '$_imageBaseUrl$_imageDirectory/${form.icon}',
                                        width: 25,
                                        height: 25,
                                        placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                                        errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                                      ),
                                    ),
                                  );

                                  list.add(_divider);

                                  return list;
                                })
                                .expand((element) => element),
                          ],
                        );
                      },
                    ),
                    Item(
                      padding: EdgeInsets.zero,
                      title: 'Login with Biometrics',
                      icon: SvgPicture.asset('assets/img/fingerprint.svg', width: 25, colorFilter: ColorFilter.mode(Color(0xffF4B223), BlendMode.srcIn)),
                      trailing: BlocConsumer<SecuritySettingsBloc, SecuritySettingsState>(
                        listener: (context, state) {
                          if (state is PinAuthenticated && state.id == _loginId) {
                            context.read<BiometricBloc>().add(BiometricLoginStatusChange(state.pin));
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthenticatingPin && state.id == _loginId) {
                            return SizedBox.square(dimension: 20, child: CircularProgressIndicator());
                          }

                          return SizedBox(
                            width: 45,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                trackOutlineWidth: WidgetStateProperty.resolveWith<double>((states) => 0),
                                trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) => Color(0xffD9DADB)),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Color(0xffD9DADB),
                                value: bloc.isLoginEnabled,
                                onChanged: (status) {
                                  AuthenticationUtil.pin(
                                    onSuccess: (pin) {
                                      _loginId = Uuid().v4();
                                      context.read<SecuritySettingsBloc>().add(AuthenticatePin(pin: pin, id: _loginId));
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _divider,
                    Item(
                      padding: EdgeInsets.zero,
                      title: 'Transact with Biometrics',
                      icon: SvgPicture.asset('assets/img/face-id-2.svg', width: 25, colorFilter: ColorFilter.mode(Color(0xffF4B223), BlendMode.srcIn)),
                      trailing: BlocConsumer<SecuritySettingsBloc, SecuritySettingsState>(
                        listener: (context, state) {
                          if (state is PinAuthenticated && state.id == _transactionId) {
                            context.read<BiometricBloc>().add(BiometricTransactionStatusChange(state.pin));
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthenticatingPin && state.id == _transactionId) {
                            return SizedBox.square(dimension: 20, child: CircularProgressIndicator());
                          }

                          return SizedBox(
                            width: 45,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                trackOutlineWidth: WidgetStateProperty.resolveWith<double>((states) => 0),
                                trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) => Color(0xffD9DADB)),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Color(0xffD9DADB),
                                value: bloc.isTransactionEnabled,
                                onChanged: (status) {
                                  AuthenticationUtil.pin(
                                    onSuccess: (pin) {
                                      _transactionId = Uuid().v4();
                                      context.read<SecuritySettingsBloc>().add(AuthenticatePin(pin: pin, id: _transactionId));
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _divider,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget get _divider {
    return Divider(color: Color(0xffF8F8F8));
  }
}
