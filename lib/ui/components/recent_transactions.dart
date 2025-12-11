import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:agent_digital_banking/blocs/history/history_bloc.dart';
import 'package:agent_digital_banking/constants/status.const.dart';
import 'package:agent_digital_banking/data/models/history/history.response.dart';
import 'package:agent_digital_banking/data/models/request_response.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/pages/receipt.page.dart';
import 'package:agent_digital_banking/utils/navigator.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key, this.showBackBtn = false});
  static const routeName = '/history';
  final bool showBackBtn;

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  Response<HistoryResponse> _sourceList = const Response<HistoryResponse>(code: '', message: '', status: '', data: HistoryResponse());
  List<RequestResponse> _list = [];

  @override
  void initState() {
    context.read<HistoryBloc>().add(const LoadHistory(true));
    _sourceList = context.read<HistoryBloc>().history;
    _list = _sourceList.data?.request ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state is HistoryLoaded) {
          _sourceList = state.result;
          _search('', _sourceList.data?.request ?? [], shouldSetState: false);

          return;
        }

        if (state is HistoryLoadedSilently) {
          _sourceList = state.result;
          _search('', _sourceList.data?.request ?? [], shouldSetState: false);

          return;
        }

        if (state is LoadHistoryError || state is SilentLoadHistoryError) {
          return;
        }
      },
      buildWhen: (previous, current) => current is LoadingHistory || current is HistoryLoaded || current is HistoryLoadedSilently,
      builder: (context, state) {
        if (state is LoadingHistory) {
          return const SizedBox(height: 100, width: 100, child: CircularProgressIndicator());
        }

        if (state is! HistoryLoaded && state is! HistoryLoadedSilently) {
          return const SizedBox();
        }

        if (_list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/img/empty.svg', width: 64),
                const SizedBox(height: 10),
                const Text(
                  'No Transactions found',
                  style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Complete an the transaction(s) to see it appear here',
                  style: PrimaryTextStyle(color: Color(0xff919195), fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 150),
              ],
            ),
          );
        }

        return Column(
          children: _list
              .take(5)
              .map(
                (record) => InkWell(
                  onTap: record.showReceipt == 1
                      ? () {
                          NavigatorUtil.pushName(MyApp.navigatorKey.currentContext!, nav: MyApp.navigatorKey.currentState!, routeName: ReceiptPage.routeName, arguments: {'request': record, 'imageBaseUrl': _sourceList.imageBaseUrl, 'imageDirectory': _sourceList.imageDirectory, 'fblLogo': _sourceList.data?.fblLogo ?? ''}, showNavBar: true);
                        }
                      : null,
                  enableFeedback: true,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  record.formName ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                record.statusLabel ?? '',
                                style: PrimaryTextStyle(color: _status(record), fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(record.amount ?? '', style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Text(
                              record.receiptDate ?? '',
                              style: PrimaryTextStyle(color: const Color(0xff919195), fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Color _status(RequestResponse record) {
    switch (record.statusLabel?.toUpperCase()) {
      case StatusConstants.success:
        return Colors.green;
      case StatusConstants.pending:
        return Colors.amber;
      case StatusConstants.failed:
      case StatusConstants.error:
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  void _search(String value, List<RequestResponse> requests, {shouldSetState = true}) {
    logger.i(value);
    String search = value.trim().toLowerCase();
    _list = requests.where((element) {
      return element.formName?.toLowerCase().contains(search) ?? false;
    }).toList();
    if (shouldSetState) {
      setState(() {});
    }
  }
}
