import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import '../../constants/status.const.dart';
import '../../data/models/response.modal.dart';
import '../../main.dart';
import '../components/form/button.dart';

class AppErrorPage extends StatefulWidget {
  const AppErrorPage(this.response, {super.key});
  static const String routeName = '/app-error';
  final Response response;

  @override
  AppErrorPageState createState() => AppErrorPageState();
}

class AppErrorPageState extends State<AppErrorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is CheckingDeviceStatus) {
                return SizedBox(height: 100, width: 100, child: CircularProgressIndicator());
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SvgPicture.asset(
                  //   'assets/img/error.svg',
                  //   width: 200,
                  // ),
                  const SizedBox(height: 30),
                  Text(
                    widget.response.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (widget.response.code == StatusCodeConstants.networkUnavailable)
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: FormButton(
                        text: 'Retry',
                        onPressed: () {
                          MyApp.navigatorKey.currentContext!.read<AppBloc>().add(
                            DeviceStatusCheckEvent(),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
