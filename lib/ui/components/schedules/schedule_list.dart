import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:my_sage_agent/data/models/schedule/schedules.dart';
import 'package:my_sage_agent/ui/components/schedules/schedule_item.dart';
import 'package:my_sage_agent/ui/pages/schedules/schedule_details.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key, required this.schedules, required this.formatter, required this.onTap, required this.location});

  final List<Schedules> schedules;
  final DateFormat formatter;
  final Function(Schedules) onTap;
  final String location;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      sliver: SliverList.separated(
        itemCount: schedules.length,
        separatorBuilder: (_, _) => const Divider(color: Color(0xffF6F6F6)),
        itemBuilder: (_, index) {
          final schedule = schedules[index];

          return ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            shape: RoundedRectangleBorder(),
            collapsedShape: RoundedRectangleBorder(),
            dense: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.all(5),
            onExpansionChanged: (value) {
              if (!value) {
                return;
              }
            },
            leading: CircleAvatar(radius: 20, backgroundColor: Color(0xffF8F8F8), child: SvgPicture.asset('assets/img/acute.svg')),
            title: Text(schedule.payee?.title ?? '', style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(
              schedule.payee?.value ?? '',
              style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xff4F4F4F)),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(color: const Color(0xffF8F8F8), borderRadius: BorderRadius.circular(30)),
              child: Text(schedule.schedule?.executionType ?? '', style: PrimaryTextStyle(fontSize: 13, color: Color(0xff4F4F4F))),
            ),
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: Color(0xffD9DADB)),
                ),
                child: Column(
                  children: [
                    ScheduleItem(keyName: 'Status', value: schedule.schedule?.statusLabel ?? ''),
                    Divider(color: Color(0xffD9DADB)),
                    ScheduleItem(keyName: 'Service', value: schedule.payee?.formName ?? ''),
                    Divider(color: Color(0xffD9DADB)),
                    ScheduleItem(keyName: 'Next task date', value: formatter.format(DateTime.parse(schedule.schedule?.nextExecutionDate ?? ''))),
                    Divider(color: Color(0xffD9DADB)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            ScheduleDetailsPageState.deleteSchedule(schedule.schedule!, location: location);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.delete_outline, color: Color(0xff919195)),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () => onTap(schedule),
                          // borderRadius:
                          //     BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'View Details',
                              style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
