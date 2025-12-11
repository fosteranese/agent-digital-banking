import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:agent_digital_banking/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:agent_digital_banking/data/models/collection/payment.dart';
import 'package:agent_digital_banking/data/models/collection/payment_categories.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/ui/components/actions/action_tile.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/history/history_shimmer.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class PaymentActionTile extends StatefulWidget {
  const PaymentActionTile({super.key, required this.id, required this.isExpanded, required this.onExpand, required this.payment, required this.action});
  final String id;
  final bool isExpanded;
  final void Function(bool status) onExpand;
  final Payment payment;
  final ActivityDatum action;

  @override
  State<PaymentActionTile> createState() => _PaymentActionTileState();
}

class _PaymentActionTileState extends State<PaymentActionTile> {
  final _controller = ExpansibleController();
  final _stage = ValueNotifier(Stages.initial);
  final _id = Uuid().v4();
  late final String _action = widget.payment.catId!;
  String _message = '';
  Response<PaymentCategories>? _result;

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
  void didUpdateWidget(covariant PaymentActionTile oldWidget) {
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
              _result = state.data;
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
        key: ValueKey('expansion-tile-${widget.payment.catId}'),
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
          imageUrl: '${user.imageBaseUrl}${user.imageDirectory}/${widget.payment.icon}',
          width: 24,
          placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
          errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
        ),
        title: Text(
          widget.payment.catName ?? '',
          style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
        ),
        subtitle: Text(widget.payment.description ?? '', style: PrimaryTextStyle(fontSize: 14, color: Color(0xff919195))),
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
                return DoneState(result: _result, action: widget.action);
              }

              switch (stage) {
                case Stages.initial:
                  return SizedBox();

                case Stages.loading:
                  return LoadingState();

                case Stages.done:
                  return DoneState(result: _result, action: widget.action);

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

    if (!isExpanded || _stage.value == Stages.done) {
      return;
    }

    context.read<RetrieveDataBloc>().add(RetrievePaymentCategories(id: _id, action: _action, skipSavedData: false, categoryId: widget.payment.catId ?? ''));
  }
}

class DoneState extends StatelessWidget {
  const DoneState({super.key, required this.result, required this.action});

  final Response<PaymentCategories>? result;
  final ActivityDatum action;

  String getImage(String icon) {
    return '${result!.imageBaseUrl}${result!.imageDirectory}/$icon';
  }

  @override
  Widget build(BuildContext context) {
    Widget? tile;

    if (result != null) {
      tile = Column(
        children: result!.data!.institution!.map((item) {
          return listItem(
            onPressed: () {
              final text = item;
              logger.i(text);

              context.push(ProcessFormPage.routeName, extra: {'form': item, 'amDoing': AmDoing.transaction, 'activity': action});
            },
            title: item.insName!,
            image: getImage(item.icon!),
          );
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
