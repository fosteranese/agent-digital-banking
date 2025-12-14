import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/enquiry.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/ui/components/form/search_box.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class EnquiryFlowPage extends StatefulWidget {
  const EnquiryFlowPage({super.key, required this.form, this.enquiry});

  static const routeName = '/process-flow/enquiry';

  final Enquiry? enquiry;
  final GeneralFlowForm form;

  @override
  State<EnquiryFlowPage> createState() => _EnquiryFlowPageState();
}

class _EnquiryFlowPageState extends State<EnquiryFlowPage> {
  late Enquiry? _enquiry = widget.enquiry;
  late List<Sources> _list = _enquiry?.sources ?? [];
  final _controller = TextEditingController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  final _fToast = FToast();

  bool _enableSearch = false;
  // bool _showUpdating = true;
  String _id = '';

  @override
  void initState() {
    super.initState();
    _load(skipSavedData: false);
    _fToast.init(context);
  }

  void _load({required bool skipSavedData}) {
    _id = const Uuid().v4();
    context.read<RetrieveDataBloc>().add(
      RetrieveEnquiry(
        id: _id,
        action: _enquiry?.endPoint ?? widget.form.formId,
        skipSavedData: skipSavedData,
        enquiry: _enquiry,
        form: widget.form,
      ),
    );
  }

  void _search(String value, List<Sources> sources, shouldSetState) {
    final query = value.trim().toLowerCase();
    _list = sources.where((element) {
      final result = element.source
          ?.where(
            (s) =>
                (s.key?.toLowerCase().contains(query) ?? false) ||
                (s.value?.toLowerCase().contains(query) ?? false),
          )
          .toList();
      return result?.isNotEmpty ?? false;
    }).toList();
    if (shouldSetState) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
      listener: (context, state) {
        if (state is RetrieveDataError) {
          MainLayout.stopRefresh(context);
        }
      },
      builder: (context, state) {
        if (state case DataRetrieved(
          :final data,
          :final id,
        ) when data is Response<Enquiry> && id == _id) {
          _enquiry = data.data;
          _search(_controller.text.trim(), _enquiry?.sources ?? [], false);
        }

        return MainLayout(
          backgroundColor: Color(0xffF8F8F8),
          refreshController: _refreshController,
          onRefresh: () async {
            // _showUpdating = false;
            _load(skipSavedData: true);
          },
          title: _enquiry?.title ?? widget.form.formName ?? '',
          showBackBtn: true,
          actions: _buildActions(),
          bottom: _buildSearchBar(),
          slivers: [
            if (_enquiry?.header?.isNotEmpty ?? false) _HeaderSection(header: _enquiry!.header),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              sliver: (state is RetrievingData)
                  ? _ShimmerList() // 👈 Show shimmer while loading
                  : _buildList(),
            ),
          ],
        );
      },
    );
  }

  List<Widget>? _buildActions() {
    if (!(_enquiry?.header?.isNotEmpty ?? false)) {
      return null;
    }

    return [
      IconButton(
        onPressed: () => setState(() => _enableSearch = !_enableSearch),
        icon: SvgPicture.asset(
          _enableSearch ? 'assets/img/close-search.svg' : 'assets/img/search.svg',
          width: 25,
        ),
      ),
    ];
  }

  PreferredSizeWidget? _buildSearchBar() {
    if ((_enquiry?.header?.isEmpty ?? true) || _enableSearch) {
      return SearchBox(
        controller: _controller,
        onSearch: (value) => _search(value, _enquiry?.sources ?? [], true),
      );
    }
    return null;
  }

  SliverList _buildList() {
    final title = _enquiry?.title?.toLowerCase() ?? '';
    final isFxRate = title.contains('fx rate') || title.contains('exchange rate');

    return SliverList.builder(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        final info = _list[index];
        return InkWell(
          onTap: (_enquiry?.hasEnquiry ?? false)
              ? () => context.read<GeneralFlowBloc>().add(
                  GeneralFlowSubEnquiry(
                    routeName: _id,
                    formId: info.formId ?? '',
                    hashValue: info.hashValue ?? '',
                    endpoint: _enquiry?.endPoint ?? '',
                  ),
                )
              : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: const Color(0xffF6F6F6)),
            ),
            child: isFxRate
                ? FxRateItem(
                    heading: info.source?.first.value ?? '',
                    rates: info.source?.skip(1) ?? [],
                  )
                : _ScheduleList(info: info),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    super.dispose();
  }
}

/// ✅ Shimmer placeholder list
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.header});
  final List<String?> header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: const DecorationImage(
            image: AssetImage('assets/img/background.png'),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Text(
              header.elementAtOrNull(0) ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              header.elementAtOrNull(1) ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme.displaySmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              header.elementAtOrNull(2) ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.info});
  final Sources info;

  @override
  Widget build(BuildContext context) {
    final sources = info.source ?? [];
    if (sources.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Icon(Icons.chevron_right_outlined, color: Color(0xff919195), size: 24),
        ),
      ],
    );
  }
}

class FxRateItem extends StatelessWidget {
  const FxRateItem({super.key, required this.heading, required this.rates});

  final String heading;
  final Iterable<Source> rates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(heading, style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: Color(0xffF8F8F8))),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  rates.first.key ?? '',
                  textAlign: TextAlign.start,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                trailing: Text(
                  rates.first.value ?? '',
                  textAlign: TextAlign.start,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Divider(color: Color(0xffF8F8F8), thickness: 2),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  rates.last.key ?? '',
                  textAlign: TextAlign.start,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                trailing: Text(
                  rates.last.value ?? '',
                  textAlign: TextAlign.start,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
