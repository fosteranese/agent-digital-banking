import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection/institution.dart';
import 'package:my_sage_agent/data/models/collection/payment.dart';
import 'package:my_sage_agent/data/models/collection/payment_categories.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/actions/action_tile.dart';
import 'package:my_sage_agent/ui/components/actions/payment_action_tile.dart';
import 'package:my_sage_agent/ui/components/form/search_box.dart';
import 'package:my_sage_agent/ui/components/item.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key, required this.amDoing, required this.action, this.payment});
  static const routeName = '/process-flow/actions';
  final AmDoing amDoing;
  final ActivityDatum action;
  final Payment? payment;

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  final _controller = TextEditingController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  var _id = Uuid().v4();

  final _stage = ValueNotifier(Stages.initial);
  String _message = '';
  Response<GeneralFlowCategory>? _result;
  Response<List<Payment>>? _payment;
  Response<PaymentCategories>? _paymentCategory;
  final _expandedItem = ValueNotifier('');
  bool _showSearchBox = false;

  @override
  void initState() {
    _onLoad(skipSavedData: false);
    super.initState();
  }

  void _onLoad({required bool skipSavedData}) {
    _id = Uuid().v4();
    var action = '';

    if (widget.payment != null) {
      context.read<RetrieveDataBloc>().add(RetrievePaymentCategories(categoryId: widget.payment?.catId ?? '', skipSavedData: skipSavedData, id: _id, action: widget.payment?.catId));
      return;
    }

    switch (widget.action.activity?.activityType) {
      case ActivityTypesConst.fblOnline:
      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
      case ActivityTypesConst.fblCollect:
      case ActivityTypesConst.fblCollectCategory:
        action = widget.action.activity?.endpoint ?? widget.action.activity?.activityId ?? '';
        String activityType = widget.action.activity!.activityType!;
        if (widget.action.activity?.activityType == ActivityTypesConst.quickFlowAlt) {
          activityType = ActivityTypesConst.quickFlow;
        }
        context.read<RetrieveDataBloc>().add(RetrieveCategories(activityId: widget.action.activity?.activityId ?? '', endpoint: widget.action.activity?.endpoint ?? '', id: _id, action: action, skipSavedData: skipSavedData, activityType: activityType));
        break;
    }
  }

  bool get _shouldLoad {
    return (_payment?.data?.isEmpty ?? true) && (_paymentCategory?.data?.institution?.isEmpty ?? true) && (_result?.data?.forms?.isEmpty ?? true);
  }

  bool get _isEmpty {
    return (_paymentList?.isEmpty ?? true) && (_paymentCategoryList?.isEmpty ?? true) && (_resultList?.isEmpty ?? true);
  }

  List<GeneralFlowForm>? get _resultList {
    if (_result?.data?.forms == null) {
      return null;
    }

    final search = _controller.text.trim().toLowerCase();
    return _result!.data!.forms!.where((item) {
      return item.formName?.toLowerCase().contains(search) ?? false;
    }).toList();
  }

  List<Payment>? get _paymentList {
    if (_payment?.data == null) {
      return null;
    }

    final search = _controller.text.trim().toLowerCase();
    return _payment!.data!.where((item) {
      return item.catName?.toLowerCase().contains(search) ?? false;
    }).toList();
  }

  List<Institution>? get _paymentCategoryList {
    if (_paymentCategory?.data?.institution == null) {
      return null;
    }

    final search = _controller.text.trim().toLowerCase();
    return _paymentCategory!.data!.institution!.where((item) {
      return item.insName?.toLowerCase().contains(search) ?? false;
    }).toList();
  }

  // Response<PaymentCategories>? _paymentCategory;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RetrieveDataBloc, RetrieveDataState>(
      listenWhen: (previous, current) {
        return current.id == _id;
      },
      listener: (context, state) {
        if (state is RetrievingData && _shouldLoad) {
          _stage.value = Stages.loading;
          MessageUtil.displayLoading(context);
          return;
        } else if (state is! RetrievingData && _stage.value == Stages.loading && _shouldLoad) {
          context.pop();
        }

        if (state is DataRetrieved) {
          if (state.data is Response<List<Payment>>?) {
            _payment = state.data;
            // return;
          } else if (state.data is Response<PaymentCategories>?) {
            _paymentCategory = state.data;
            // return;
          } else if (state.data is Response<GeneralFlowCategory>?) {
            _result = state.data;
            // return;
          } else {
            _result = null;
          }

          // switch (widget.action.activity!.activityType) {
          //   case ActivityTypesConst.fblCollect:
          //     _payment = state.data;
          //     break;

          //   case ActivityTypesConst.fblCollectCategory:
          //     _paymentCategory = state.data;
          //     break;

          //   default:
          //     if (state.data?.data?.forms != null) {
          //       _result = state.data;
          //     } else {
          //       _result = null;
          //     }
          // }

          _stage.value = Stages.done;
          MainLayout.stopRefresh(context);
          return;
        }

        if (state is RetrieveDataError) {
          _message = state.error.message;
          _stage.value = Stages.error;
          MainLayout.stopRefresh(context);
          return;
        }
      },

      child: MainLayout(
        backgroundColor: _payment == null ? null : Color(0xffF8F8F8),
        refreshController: _refreshController,
        onRefresh: () async {
          _onLoad(skipSavedData: true);
        },
        showBackBtn: true,
        showNavBarOnPop: true,
        title: widget.action.activity?.activityName ?? '',
        bottom: _showSearchBox
            ? SearchBox(
                controller: _controller,
                onSearch: (_) {
                  setState(() {});
                },
              )
            : null,
        actions: [
          IconButton(
            style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
            onPressed: () => setState(() {
              _controller.text = '';
              _showSearchBox = !_showSearchBox;
            }),
            icon: SvgPicture.asset('assets/img/search.svg', width: 20, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
          ),
          const SizedBox(width: 10),
        ],
        sliver: SliverPadding(
          padding: const EdgeInsets.all(15),
          sliver: ValueListenableBuilder(
            valueListenable: _stage,
            builder: (context, stage, child) {
              if (stage == Stages.loading && _shouldLoad) {
                return SliverToBoxAdapter();
              }

              if (stage == Stages.error) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SvgPicture.asset(
                          //   'assets/img/error.svg',
                          //   width: 150,
                          // ),
                          Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff919195)),
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (_isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/img/empty.svg', width: 64),
                          const SizedBox(height: 10),
                          Text(
                            'Nothing found',
                            textAlign: TextAlign.center,
                            style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff4F4F4F)),
                          ),
                          Text(
                            'no "${_controller.text}" was found',
                            textAlign: TextAlign.center,
                            style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff919195)),
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (_result != null) {
                final list = _resultList ?? [];
                return SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final formData = list[index];
                    return Item(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.push(ProcessFormPage.routeName, extra: {'form': formData, 'amDoing': widget.amDoing, 'activity': widget.action});
                      },
                      title: formData.formName ?? '',
                      fullIcon: CachedNetworkImage(
                        imageUrl: '${_result?.imageBaseUrl}${_result?.imageDirectory}/${formData.icon}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(backgroundColor: Colors.white, backgroundImage: imageProvider),
                        width: 25,
                        height: 25,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: const Color(0xffF4F4F4),
                          child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: const Color(0xffF4F4F4),
                          child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(color: Color(0xffF1F1F1)),
                );
              }

              if (_payment != null) {
                final list = _paymentList ?? [];
                return ValueListenableBuilder(
                  valueListenable: _expandedItem,
                  builder: (context, value, child) {
                    return SliverList.separated(
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final payment = list[index];
                        return PaymentActionTile(
                          id: _id,
                          payment: payment,
                          action: widget.action,
                          isExpanded: value == payment.catId,
                          onExpand: (status) {
                            if (!status) {
                              return;
                            }

                            _expandedItem.value = payment.catId ?? '';
                          },
                        );
                      },
                      separatorBuilder: (_, _) {
                        return SizedBox(height: 10);
                      },
                    );
                  },
                );
              }

              if (_paymentCategory != null) {
                final list = _paymentCategoryList ?? [];
                return SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final formData = list[index];
                    return Item(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.push(ProcessFormPage.routeName, extra: {'form': formData, 'amDoing': widget.amDoing, 'activity': widget.action});
                      },
                      title: formData.insName ?? '',
                      fullIcon: CachedNetworkImage(
                        imageUrl: '${_paymentCategory?.imageBaseUrl}${_paymentCategory?.imageDirectory}/${formData.icon}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(backgroundColor: Colors.white, backgroundImage: imageProvider),
                        width: 25,
                        height: 25,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: const Color(0xffF4F4F4),
                          child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: const Color(0xffF4F4F4),
                          child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 25),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(color: Color(0xffF1F1F1)),
                );
              }

              return SliverToBoxAdapter();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
