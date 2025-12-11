import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agent_digital_banking/utils/theme.util.dart';
import 'package:agent_digital_banking/constants/field.const.dart';
import 'package:agent_digital_banking/data/models/request_response.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key, required this.request, required this.imageBaseUrl, required this.imageDirectory, required this.fblLogo});
  static const routeName = '/history/receipt';
  final RequestResponse request;
  final String imageBaseUrl;
  final String imageDirectory;
  final String fblLogo;

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      // spaceAllowed:
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: Container(color: Color(0xffF8F8F8))),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),
            SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        if (widget.request.amount?.isNotEmpty ?? false)
                          Column(
                            children: [
                              Text(
                                'Total Amount',
                                style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.request.amount ?? '',
                                style: PrimaryTextStyle(color: Color(0xff010101), fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        _divider,
                        ReceiptItem(label: 'Service', name: widget.request.formName ?? ''),
                        _divider,
                        ...widget.request.previewData
                                ?.map((e) {
                                  List<Widget> list = [];
                                  list.add(ReceiptItem(label: e.key ?? '', name: e.value ?? '', dataType: e.dataType ?? FieldDataTypesConst.string));

                                  if (e != widget.request.previewData!.last) {
                                    list.add(_divider);
                                  }

                                  return list;
                                })
                                .expand((element) => element)
                                .toList() ??
                            [],
                        _divider,
                        ReceiptItem(label: 'Transaction Type', name: widget.request.activityName ?? ''),
                        _divider,
                        ReceiptItem(label: 'Status', name: widget.request.statusLabel ?? ''),
                        _divider,
                        ReceiptItem(label: 'Message', name: widget.request.comment ?? ''),
                        _divider,
                        ReceiptItem(label: 'Reference', name: widget.request.reference ?? ''),
                      ],
                    ),
                  ),

                  if (widget.request.status != 0)
                    Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xffCEFFCE),
                        child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 34),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: const CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xffFFE0DF),
                        child: Icon(Icons.error_outline_outlined, color: Color(0xffF10404), size: 34),
                      ),
                    ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: IconButton(
                  style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _divider {
    return Divider(color: Color(0xffF8F8F8), height: 25);
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.label, required this.name, this.dataType = FieldDataTypesConst.string});

  final String label;
  final String name;
  final int dataType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: dataType == FieldDataTypesConst.link
          ? () {
              final url = Uri.parse(name);
              launchUrl(url);
            }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff4F4F4F)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              softWrap: true,
              style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xff010203)),
            ),
          ),
        ],
      ),
    );
  }
}
