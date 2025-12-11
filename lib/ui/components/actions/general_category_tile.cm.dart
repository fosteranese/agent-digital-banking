import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/enquiry_flow.page.dart';
import 'package:uuid/uuid.dart';

import 'package:agent_digital_banking/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/ui/components/actions/action_tile.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class GeneralCategoryTile extends StatefulWidget {
  const GeneralCategoryTile({super.key, required this.form, required this.activity, this.amDoing = AmDoing.transaction});

  final GeneralFlowForm form;
  final AmDoing amDoing;
  final ActivityDatum activity;

  @override
  State<GeneralCategoryTile> createState() => _GeneralCategoryTileState();
}

class _GeneralCategoryTileState extends State<GeneralCategoryTile> {
  final _stage = ValueNotifier(Stages.initial);
  final _id = Uuid().v4();
  // String _message = '';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RetrieveDataBloc, RetrieveDataState>(
      listenWhen: (previous, current) {
        return current.id == _id;
      },
      listener: (context, state) {
        if (state is RetrievingData || (state is DataRetrieved && state.stillLoading)) {
          _stage.value = Stages.loading;
          return;
        }

        if (state is DataRetrieved) {
          _stage.value = Stages.done;
          return;
        }

        if (state is RetrieveDataError) {
          // _message = state.error.message;
          _stage.value = Stages.error;
          return;
        }
      },
      child: ListTile(
        onTap: () {
          if (widget.form.activityType == ActivityTypesConst.enquiry) {
            context.push(EnquiryFlowPage.routeName, extra: {'form': widget.form, 'amDoing': widget.amDoing, 'activity': widget.activity});
            return;
          }

          context.push(ProcessFormPage.routeName, extra: {'form': widget.form, 'amDoing': widget.amDoing, 'activity': widget.activity});
        },
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: CachedNetworkImage(
          imageUrl: getImage(widget.form.icon!),
          width: 24,
          height: 24,
          placeholder: (context, url) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
          errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 24),
        ),
        title: ValueListenableBuilder(
          valueListenable: _stage,
          builder: (context, value, child) {
            final title = value == Stages.loading ? 'Loading ...' : widget.form.formName!;
            return Text(title, style: PrimaryTextStyle(fontSize: 16));
          },
        ),
        trailing: ValueListenableBuilder(
          valueListenable: _stage,
          builder: (context, stage, child) {
            if (stage == Stages.loading) {
              return SizedBox.square(dimension: 20, child: CircularProgressIndicator());
            }
            return Icon(Icons.navigate_next, color: Color(0xffD9DADB));
          },
        ),
      ),
    );
  }

  String getImage(String icon) {
    final user = AppUtil.currentUser;
    return '${user.imageBaseUrl}${user.imageDirectory}/$icon';
  }
}
