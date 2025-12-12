import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/data/models/enquiry.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/ui/components/slider.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/service.util.dart';

class FXRateHorizontalList extends StatefulWidget {
  const FXRateHorizontalList({super.key});

  @override
  State<FXRateHorizontalList> createState() => _FXRateHorizontalListState();
}

class _FXRateHorizontalListState extends State<FXRateHorizontalList> {
  List<Sources> _list = [];

  @override
  void initState() {
    context.read<GeneralFlowBloc>().add(
      GeneralFlowEnquiry(
        routeName: "DynamicEnquiry/FXRates",
        form: GeneralFlowForm(formId: '111d37ed-95b3-426b-9c2f-13d585fd4dd6', categoryId: '0fdc593e-89f2-4950-a491-75c66749bbcc', accessType: 'CUSTOMER', formName: 'Current FX Rates', description: '', caption: 'Daily FX Rates', tooltip: 'Daily FX Rates', icon: 'fxrate.png', iconType: 'png', requireVerification: 0, verifyEndpoint: 'DynamicEnquiry/FXRates', processEndpoint: 'FBLOnline/Initiate', rank: 2, status: 1, statusLabel: 'Success', dateCreated: DateTime.parse('2023-08-12 09:55:26.480'), createdBy: 'abowoso', dateModified: DateTime.parse('2023-07-13 11:24:03.887'), modifiedBy: '', internalEndpoint: 'DynamicEnquiry/FXRates', activityType: 'ENQUIRY', showInHistory: 0, showInFavourite: 0, showReceipt: 0, allowBeneficiary: 0, allowSchedule: 0),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralFlowBloc, GeneralFlowState>(
      listener: (context, state) {
        if (state is GeneralFlowEnquired) {
          _list = state.result.data?.sources ?? [];
          return;
        }

        if (state is GeneralFlowEnquiredSilently) {
          _list = state.result.data?.sources ?? [];
          return;
        }

        ServiceUtil.generalFlowListener(context: context, state: state, routeName: 'fx-rate-horizontal-scroll', amDoing: AmDoing.transaction);
      },
      builder: (context, state) {
        if (state is EnquiringGeneralFlow) {
          return Center(child: CircularProgressIndicator());
        }

        int index = 0;
        return Container(
          padding: const EdgeInsets.only(
            // left: 9,
            // right: 9,
            bottom: 20,
            top: 10,
          ),
          color: Colors.white,
          child: MySlider(
            height: 70,
            width: double.maxFinite,
            children: [
              ..._list
                  .map((item) {
                    if ((item.source?.length ?? 0) < 3) {
                      item.source?.add(Source());
                      item.source?.add(Source());
                      item.source?.add(Source());
                    }
                    ++index;
                    var items = <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0x0D7A5912),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Color(0xffF6F6F6), width: 1),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              // radius: 17,
                              backgroundColor: index % 2 == 1 ? Color(0xff7A5912) : Color(0xffB7861A),
                              child: Text(
                                '${item.source?.first.value}',
                                style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 20),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'Buy - '),
                                  TextSpan(
                                    text: item.source?[1].value,
                                    style: PrimaryTextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],

                                style: PrimaryTextStyle(color: const Color(0xff010101), fontSize: 14),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.sync_alt_outlined, size: 20, color: ThemeUtil.secondaryColor),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'Sell - '),
                                  TextSpan(
                                    text: item.source?[2].value,
                                    style: PrimaryTextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],

                                style: PrimaryTextStyle(color: const Color(0xff010101), fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];

                    if (item != _list.last) {
                      items.add(const SizedBox(width: 20));
                    }

                    return items;
                  })
                  .expand((item) => item),
            ],
          ),
        );
      },
    );
  }
}
