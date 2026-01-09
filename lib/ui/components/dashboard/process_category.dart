import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/ui/components/icon.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';
import 'package:my_sage_agent/utils/response.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class ProcessFlowCategory extends StatelessWidget {
  const ProcessFlowCategory({
    super.key,
    required this.onClose,
    required this.category,
    required this.response,
    required this.amDoing,
  });

  final void Function() onClose;
  final ValueNotifier<GeneralFlowCategory?> category;
  final Response response;
  final AmDoing amDoing;

  String _buildImagePath(GeneralFlowCategory category, GeneralFlowForm form) {
    final baseImageUrl = ResponseUtil.buildImageUrl(response);
    return '$baseImageUrl/${form.icon ?? category.category?.icon}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        onClose();
      },
      child: ValueListenableBuilder(
        valueListenable: category,
        builder: (context, value, child) {
          if (value == null) {
            return SizedBox.shrink();
          }

          return Container(
            margin: .only(left: 10, right: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: .centerLeft,
                  children: [
                    Text(
                      ProcessFlowUtil.activityDatum.activity?.activityName ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: ThemeUtil.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        iconSize: 18,

                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

                ...value.forms!.map((form) {
                  return ListTile(
                    onTap: () {
                      context.pop();
                      ProcessFlowUtil.loadFormData(
                        context,
                        skipSavedData: false,
                        amDoing: amDoing,
                        id: Uuid().v4(),
                        activity: ProcessFlowUtil.activityDatum,
                        form: form,
                      );
                      return;
                    },
                    contentPadding: .zero,
                    leading: MyIcon(icon: _buildImagePath(value, form)),
                    title: Text(
                      form.formName ?? '',
                      style: PrimaryTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ThemeUtil.black,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: ThemeUtil.flat),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
