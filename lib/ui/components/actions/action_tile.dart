import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection/payment.dart';
import 'package:my_sage_agent/data/models/collection/payment_categories.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/actions/general_category_tile.cm.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/pages/process_flow/actions.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/schedules/schedules.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum Stages { initial, loading, error, done }

class ActionTile extends StatefulWidget {
  const ActionTile({super.key, required this.id, required this.isExpanded, required this.onExpand, required this.action, required this.amDoing});
  final String id;
  final bool isExpanded;
  final void Function(bool status) onExpand;
  final ActivityDatum action;
  final AmDoing amDoing;

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  final _controller = ExpansibleController();
  final _stage = ValueNotifier(Stages.initial);
  final _id = Uuid().v4();
  String _action = '';
  String _message = '';
  Response<GeneralFlowCategory>? _result;
  Response<List<Payment>>? _payment;
  Response<PaymentCategories>? _paymentCategory;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isExpanded) {
        _controller.expand();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ActionTile oldWidget) {
    if (!widget.isExpanded) {
      _controller.collapse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final user = AppUtil.currentUser;

    return MultiBlocListener(
      listeners: [
        BlocListener<RetrieveDataBloc, RetrieveDataState>(
          listenWhen: (previous, current) {
            return current.id == _id;
          },
          listener: (context, state) {
            if (state
                is RetrievingData /*||
                (state is DataRetrieved &&
                    state.stillLoading)*/ ) {
              _stage.value = Stages.loading;
              return;
            }

            if (state is DataRetrieved) {
              switch (widget.action.activity!.activityType) {
                case ActivityTypesConst.fblCollect:
                  _payment = state.data;
                  break;

                case ActivityTypesConst.fblCollectCategory:
                  _paymentCategory = state.data;
                  break;

                default:
                  if (state.data?.data?.forms != null) {
                    _result = state.data;
                  } else {
                    _result = null;
                  }
              }

              _stage.value = Stages.done;
              return;
            }

            if (state is RetrieveDataError) {
              _message = state.error.message;
              _stage.value = Stages.error;
              return;
            }
          },
        ),
      ],
      child: ExpansionTile(
        key: ValueKey('expansion-tile-${widget.action.activity?.activityId}'),
        controller: _controller,
        onExpansionChanged: _onExpanded,
        enabled: true,
        maintainState: false,
        showTrailingIcon: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        dense: true,
        leading: CachedNetworkImage(
          imageUrl: '${user.imageBaseUrl}${user.imageDirectory}/${widget.action.activity?.icon}',
          width: 24,
          height: 24,
          placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
          errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
        ),
        title: Text(
          widget.action.activity?.activityName ?? '',
          style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
        ),
        subtitle: Text(widget.action.activity?.description ?? '', style: PrimaryTextStyle(fontSize: 14, color: Color(0xff919195))),
        trailing: ValueListenableBuilder(
          valueListenable: _stage,
          builder: (context, stage, child) {
            if (stage == Stages.loading) {
              return SizedBox.square(dimension: 20, child: CircularProgressIndicator());
            }
            return Icon(Icons.navigate_next);
          },
        ),

        children: [
          Divider(color: Color(0xffF5F5F5)),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: _stage,
            builder: (context, stage, child) {
              if (_result != null) {
                return DoneState(result: _result, payment: _payment, paymentCategory: _paymentCategory, action: widget.action, amDoing: widget.amDoing);
              }

              switch (stage) {
                case Stages.initial:
                  return SizedBox();

                case Stages.loading:
                  return LoadingState();

                case Stages.done:
                  return DoneState(result: _result, payment: _payment, paymentCategory: _paymentCategory, action: widget.action, amDoing: widget.amDoing);

                case Stages.error:
                  return ErrorState(message: _message);
              }
            },
          ),
          SizedBox(height: 20),
          // SizedBox(
          //   height: 40,
          //   width: 40,
          //   child: CircularProgressIndicator(),
          // ),
          // SizedBox(height: 10),
          // Text('Loading'),
          // SizedBox(height: 20),
        ],
      ),
    );
  }

  void _onExpanded(bool isExpanded) {
    widget.onExpand(isExpanded);

    if (!isExpanded /*|| _stage.value == Stages.done*/ ) {
      return;
    }

    switch (widget.action.activity?.activityType) {
      case ActivityTypesConst.fblOnline:
      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
      case ActivityTypesConst.fblCollect:
      case ActivityTypesConst.fblCollectCategory:
        _action = widget.action.activity?.endpoint ?? widget.action.activity?.activityId ?? '';
        String activityType = widget.action.activity!.activityType!;
        if (widget.action.activity?.activityType == ActivityTypesConst.quickFlowAlt) {
          activityType = ActivityTypesConst.quickFlow;
        }
        context.read<RetrieveDataBloc>().add(RetrieveCategories(activityId: widget.action.activity?.activityId ?? '', endpoint: widget.action.activity?.endpoint ?? '', id: _id, action: _action, skipSavedData: false, activityType: activityType));
        break;

      case ActivityTypesConst.schedule:
        _controller.collapse();
        context.push(SchedulesPage.routeName, extra: widget.action);
        break;
    }
  }
}

class DoneState extends StatelessWidget {
  const DoneState({super.key, required this.result, required this.payment, required this.paymentCategory, required this.action, required this.amDoing});

  final Response<GeneralFlowCategory>? result;
  final Response<List<Payment>>? payment;
  final Response<PaymentCategories>? paymentCategory;
  final ActivityDatum action;
  final AmDoing amDoing;

  String getImage(String icon) {
    final user = AppUtil.currentUser;

    if (result != null) {
      return '${result!.imageBaseUrl}${result!.imageDirectory}/$icon';
    }

    if (payment != null) {
      return '${payment!.imageBaseUrl}${payment!.imageDirectory}/$icon';
    }

    if (paymentCategory != null) {
      return '${paymentCategory!.imageBaseUrl}${paymentCategory!.imageDirectory}/$icon';
    }

    return '${user.imageBaseUrl}${user.imageDirectory}/$icon';
  }

  @override
  Widget build(BuildContext context) {
    Widget? tile;

    if (payment != null) {
      tile = Column(
        children: payment!.data!.map((item) {
          return listItem(
            onPressed: () {
              context.push(ActionsPage.routeName, extra: {'activity': action, 'amDoing': amDoing, 'payment': item});
            },
            title: item.catName!,
            image: getImage(item.icon!),
          );
        }).toList(),
      );
    }

    if (paymentCategory != null) {
      tile = Column(
        children: paymentCategory!.data!.institution!.map((item) {
          return listItem(
            onPressed: () {
              context.push(ProcessFormPage.routeName, extra: {'form': item, 'amDoing': amDoing, 'activity': action});
            },
            title: item.insName!,
            image: getImage(item.icon!),
          );
        }).toList(),
      );
    }

    if (result?.data?.forms != null) {
      tile = Column(
        children: result!.data!.forms!.map((item) {
          return GeneralCategoryTile(form: item, activity: action, amDoing: amDoing);
        }).toList(),
      );
    }

    if (tile != null) {
      return Padding(padding: const EdgeInsets.only(left: 20, right: 15), child: tile);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/img/empty.svg', colorFilter: ColorFilter.mode(Color(0xff919195), BlendMode.srcIn), width: 64),
          SizedBox(height: 10),
          Text(
            'Services unavailable',
            textAlign: TextAlign.center,
            style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            'Sorry! services currently unavailable.',
            textAlign: TextAlign.center,
            style: PrimaryTextStyle(color: Color(0xff919195), fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  ListTile listItem({required String title, required String image, required void Function() onPressed}) {
    return ListTile(
      onTap: onPressed,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CachedNetworkImage(
        imageUrl: image,
        width: 24,
        height: 24,
        placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
        errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
      ),
      title: Text(title, style: PrimaryTextStyle(fontSize: 16)),
      trailing: Icon(Icons.navigate_next, color: Color(0xffD9DADB)),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (int i = 0; i < 2; i++) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: SimpleListShimmerItem())],
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: PrimaryTextStyle(color: Colors.red),
          ),
          const SizedBox(height: 10),
          FormButton(height: 40, text: 'Retry', onPressed: () {}),
        ],
      ),
    );
  }
}
