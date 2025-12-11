import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ScheduleListLoading extends StatelessWidget {
  const ScheduleListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 10,
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: const Color(0xff919195),
        highlightColor: const Color(0x99919195),
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xff919195),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
