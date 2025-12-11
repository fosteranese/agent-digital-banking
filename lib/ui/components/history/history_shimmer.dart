import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryShimmerList extends StatelessWidget {
  const HistoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (_, _) => const ShimmerItem(),
      separatorBuilder: (_, _) => const Divider(
        color: Color(0xffF1F1F1),
        indent: 60,
      ),
    );
  }
}

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff919195),
      highlightColor: const Color(0x99919195),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _shimmerBox(height: 50, width: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      _shimmerBox(height: 15, width: 100),
                      const Spacer(),
                      _shimmerBox(height: 15, width: 50),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _shimmerBox(height: 15, width: 80),
                      const Spacer(),
                      _shimmerBox(height: 15, width: 70),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class SimpleListShimmerItem extends StatelessWidget {
  const SimpleListShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xaa919195),
      highlightColor: const Color(0xffF6F6F6),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            _shimmerBox(height: 20, width: 20),
            const SizedBox(width: 10),
            Expanded(
              child: _shimmerBox(
                height: 15,
                width: double.maxFinite,
              ),
            ),
            const SizedBox(width: 20),
            _shimmerBox(height: 15, width: 15),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xff919195),
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}

class FormShimmerItem extends StatelessWidget {
  const FormShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xaa919195),
      highlightColor: const Color(0xffF6F6F6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(height: 20, width: double.maxFinite),
          const SizedBox(height: 5),
          _shimmerBox(height: 50, width: double.maxFinite),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xff919195),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
