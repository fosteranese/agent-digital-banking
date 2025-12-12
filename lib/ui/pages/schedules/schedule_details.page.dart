import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:my_sage_agent/blocs/schedule/schedule_bloc.dart';
import 'package:my_sage_agent/data/models/payee/payees_response.dart';
import 'package:my_sage_agent/data/models/schedule/schedules.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/components/popover.dart';
import 'package:my_sage_agent/ui/layouts/profile.layout.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage(this.schedules, {super.key});
  static const routeName = '/schedules/details';
  final Schedules schedules;

  @override
  State<ScheduleDetailsPage> createState() => ScheduleDetailsPageState();
}

class ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  final formatter = DateFormat('dd MMM yyyy');

  List<PreviewData> get _preview {
    if (widget.schedules.payee?.previewData?.isEmpty ?? true) {
      return [];
    }

    final list = jsonDecode(widget.schedules.payee?.previewData ?? '') as List<dynamic>;

    return list.map((e) {
      return PreviewData.fromMap(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final preview = [PreviewData(key: 'Interval', value: widget.schedules.schedule?.executionType ?? ''), PreviewData(key: 'Start Date', value: formatter.format(DateTime.parse(widget.schedules.schedule?.startDate ?? ''))), PreviewData(key: 'Next Execution Date', value: formatter.format(DateTime.parse(widget.schedules.schedule?.nextExecutionDate ?? ''))), if (widget.schedules.schedule?.endDate?.toString().isNotEmpty ?? false) PreviewData(key: 'End Date', value: formatter.format(DateTime.parse(widget.schedules.schedule!.endDate))), PreviewData(key: 'Status', value: widget.schedules.schedule?.statusLabel ?? ''), PreviewData(key: 'Transaction Type', value: widget.schedules.payee?.activityName ?? ''), PreviewData(key: 'Service', value: widget.schedules.payee?.formName ?? ''), ..._preview];
    return ProfileLayout(
      floatingActionButtonMargin: 0,
      isTopPadded: false,
      showNavBarOnPop: true,
      backgroundColor: Colors.white,
      title: 'Schedule Details',
      showBackBtn: true,
      profileHeight: 200,
      useSliverAppBar: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/img/bg.png'), fit: BoxFit.cover),
        ),
        child: FlexibleSpaceBar(
          background: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(color: Colors.white, height: 80, width: double.maxFinite),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: Offset(0, 2))],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xffD9D9D9),
                      child: Text(
                        widget.schedules.payee?.shortTitle ?? '',
                        style: PrimaryTextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.schedules.payee?.title ?? '',
                    style: PrimaryTextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList.separated(
          itemCount: preview.length,
          itemBuilder: (_, index) {
            final item = preview[index];
            return ReceiptItem(label: item.key ?? '', name: item.value ?? '');
          },
          separatorBuilder: (_, _) {
            return Divider(color: Color(0xffF8F8F8), thickness: 1);
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButtonMargin: 20,
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteSchedule(widget.schedules.schedule!, location: ScheduleDetailsPage.routeName),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: const Icon(Icons.delete, color: Colors.white),
        //params
      ),
    );
  }

  static void deleteSchedule(Schedule schedule, {required String location}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Delete Schedule',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'Are you sure you want to delete this schedule ?',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 30),
                FormButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: 'No, Stop',
                ),
                const SizedBox(height: 10),
                FormOutlineButton(
                  backgroundColor: Colors.red,
                  textColor: Colors.red,
                  onPressed: () {
                    context.pop();
                    context.read<ScheduleBloc>().add(DeleteSchedule(scheduleId: schedule.scheduleId ?? '', routeName: location));
                  },
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  text: 'Yes, Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
