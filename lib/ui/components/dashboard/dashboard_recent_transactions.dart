import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/ui/components/history/collection_item.dart';
import 'package:my_sage_agent/ui/pages/collections.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardRecentTransactions extends StatelessWidget {
  const DashboardRecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .only(left: 20, right: 20),
      sliver: BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
        builder: (context, state) {
          final List<CollectionModel> list =
              context.read<RetrieveDataBloc>().data['RetrieveCollectionEvent'] ?? [];

          if (list.isEmpty) {
            return SliverToBoxAdapter();
          }

          return SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .center,
                      children: [
                        Text(
                          'Today\'s Collections',
                          style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push(CollectionsPage.routeName);
                          },
                          child: Text(
                            'See all',
                            style: PrimaryTextStyle(
                              fontSize: 14,
                              fontWeight: .normal,
                              color: ThemeUtil.subtitleGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: ThemeUtil.headerBackground, thickness: 1),
                  ],
                ),
              ),
              SliverList.separated(
                itemCount: list.length > 10 ? 10 : list.length,
                itemBuilder: (_, index) {
                  return CollectionItem(record: list[index]);
                },
                separatorBuilder: (_, _) {
                  return Divider(color: ThemeUtil.headerBackground, thickness: 1, height: 0);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
