import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:agent_digital_banking/blocs/payee/payee_bloc.dart';

import 'package:agent_digital_banking/data/models/payee/payees_response.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/layouts/profile.layout.dart';
import 'package:agent_digital_banking/ui/pages/more/profile.page.dart';
import 'package:agent_digital_banking/utils/service.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class PayeeDetailsPage extends StatefulWidget {
  const PayeeDetailsPage(this.payee, {super.key});
  static const routeName = '/payees/details';
  final Payees payee;

  @override
  State<PayeeDetailsPage> createState() => _PayeeDetailsPageState();
}

class _PayeeDetailsPageState extends State<PayeeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PayeeBloc, PayeeState>(
      listener: (context, state) {
        if (state is PayeeDeleted) {
          context.pop();
        }
      },
      child: ProfileLayout(
        backgroundColor: Colors.white,
        title: 'Beneficiary Details',
        showBackBtn: true,
        showNavBarOnPop: true,
        profileHeight: 200,
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
                Container(color: Colors.white, height: 80, width: double.maxFinite),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: SizedBox(
                          width: 120,
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
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffD9D9D9),
                                  radius: 40,
                                  child: Text(
                                    widget.payee.shortTitle ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: ThemeUtil.primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(widget.payee.title ?? '', style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        sliver: SliverPadding(
          padding: const EdgeInsets.all(15),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ReceiptItem(label: 'Transaction Type', name: widget.payee.activityName ?? ''),
                      const Divider(color: Color(0xffF1F1F1)),
                      ReceiptItem(label: 'Service', name: widget.payee.formName ?? ''),
                      const Divider(color: Color(0xffF1F1F1)),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children:
                        widget.payee.previewData
                            ?.map((e) {
                              List<Widget> list = [];
                              list.add(ReceiptItem(label: e.key!, name: e.value ?? ''));

                              if (e != widget.payee.previewData!.last) {
                                list.add(const Divider(color: Color(0xffF1F1F1)));
                              }

                              return list;
                            })
                            .expand((element) => element)
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButtonMargin: 0,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ServiceUtil.sendPayeeNow(parentContext: MyApp.navigatorKey.currentContext!, payee: widget.payee, routeName: PayeeDetailsPage.routeName);
          },
          backgroundColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
          child: const Icon(Icons.more_vert, color: Colors.white),
          //params
        ),
      ),
    );
  }
}
