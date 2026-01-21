import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  static const routeName = '/test';

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 181 + MediaQuery.of(context).padding.top,
              width: double.maxFinite,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/img/letter-head.png', fit: BoxFit.cover),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Image.asset('assets/img/logo.png', width: 116),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'SSNIT Emporium Building,',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Liberation Road, Airport City,',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Accra, Ghana',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Telephone: 0302 666 331',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Email Address:',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'info@myumbbank.com',
                              textAlign: TextAlign.right,
                              style: PrimaryTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'TRANSACTION DETAILS',
                    style: PrimaryTextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  Spacer(),
                  Expanded(
                    child: Text(
                      'Date: 31-Jul-2025',
                      style: PrimaryTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff4F4F4F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Color(0xffbdbdbd), thickness: 1),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sender Details',
                style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Reference ID',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Transaction Type',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Total Sent',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Color(0xffbdbdbd), thickness: 1),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Beneficiary Details',
                style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Reference ID',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Reference ID',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Reference ID',
                      style: PrimaryTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff9ea0a3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '0123456789',
                      style: PrimaryTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: Colors.black, thickness: 2),
            const SizedBox(height: 10),
            RichText(
              softWrap: true,
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(text: 'For any assistance, please contact us at Telephone: '),
                  TextSpan(
                    text: '0302 666 331',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold, color: Color(0xff3d3a3a)),
                  ),
                  TextSpan(text: '. Toll-Free Lines: '),
                  TextSpan(
                    text: '0800-100880',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold, color: Color(0xff3d3a3a)),
                  ),
                  TextSpan(text: ' (available to Telecel users only); \n'),
                  TextSpan(text: 'Other Lines: '),
                  TextSpan(
                    text: '0302633988',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold, color: Color(0xff3d3a3a)),
                  ),
                  TextSpan(text: '. Email Address:'),
                  TextSpan(
                    text: ' info@myumbbank.com',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold, color: Color(0xff3d3a3a)),
                  ),
                  TextSpan(text: ' or visit our website at '),
                  TextSpan(
                    text: 'www.umb.com.gh.',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold, color: Color(0xff3d3a3a)),
                  ),
                ],
                style: PrimaryTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff929396),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
