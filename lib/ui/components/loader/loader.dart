import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

import '../../../blocs/loader/loader_bloc.dart';
import '../../../constants/status.const.dart';
import '../form/button.dart';
import '../form/outline_button.dart';
import 'brand_loader.dart';

class MyLoader extends StatefulWidget {
  const MyLoader({super.key, required this.bloc});

  final LoaderBloc bloc;

  @override
  State<MyLoader> createState() => _MyLoaderState();
}

class _MyLoaderState extends State<MyLoader> {
  // late Color _color = Colors.transparent;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoaderBloc, LoaderState>(
      bloc: widget.bloc,
      listener: (context, state) => _listener(state),
      builder: (context, state) {
        if (state is LoadingLoader) {
          return _container(state);
        }

        return BlocConsumer<LoaderBloc, LoaderState>(
          bloc: widget.bloc,
          listener: (context, state) => _listener(state),
          builder: (context, state) {
            return Scaffold(body: _container(state));
          },
        );
      },
    );
  }

  Widget _container(LoaderState state) => Stack(
    children: [
      Container(color: Colors.white),
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xffFAEFD5),
          gradient: LinearGradient(stops: [0, 1], colors: [Color(0xffFAEFD5), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
      Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(40),
        child: SafeArea(
          bottom: false,
          child: Builder(
            builder: (context) {
              if (state is LoadingLoader) {
                return const BrandLoader();
              } else if (state is SuccessfulLoader) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 42.5,
                      backgroundColor: Color(0xffCEFFCE),
                      child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      state.message,
                      style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                );
              } else if (state is SuccessfulWithOptionsLoader) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 42.5,
                      backgroundColor: Color(0xffCEFFCE),
                      child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      state.title,
                      style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    if (state.message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          textAlign: TextAlign.center,
                          state.message!,
                          style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                    const Spacer(),
                    FormButton(
                      text: 'Done',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (state is SuccessfulGeneralFlowOptionsLoader) {
                var title = state.title;
                if (state.result.status == StatusConstants.pending) {
                  title = 'Pending';
                } else if (state.result.status == StatusConstants.processing) {
                  title = 'Processing';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 42.5,
                      backgroundColor: Color(0xffCEFFCE),
                      child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: state.result.status == StatusConstants.success ? Theme.of(context).primaryColor : Colors.amber),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      state.result.message,
                      style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    const Spacer(flex: 3),
                    if (state.result.data?.showReceipt == 1)
                      FormOutlineButton(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        icon: const Icon(Icons.receipt_long_outlined, size: 23),
                        text: 'View Receipt',
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(seconds: 0));
                          state.onClose();
                          await Future.delayed(const Duration(seconds: 0));
                          if (state.onShowReceipt != null) {
                            state.onShowReceipt!();
                          }
                        },
                      ),
                    if (state.result.data?.saveBenficiary == 1) const SizedBox(height: 10),
                    if (state.result.data?.saveBenficiary == 1)
                      FormOutlineButton(
                        onPressed: () {
                          if (state.onSaveBeneficiary != null) {
                            state.onSaveBeneficiary!();
                          }
                        },
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        icon: const Icon(Icons.archive_outlined, size: 23),
                        text: 'Save Beneficiary',
                        textColor: Theme.of(context).primaryColor,
                      ),
                    if (state.result.data?.allowSchedule == 1) const SizedBox(height: 10),
                    if (state.result.data?.allowSchedule == 1)
                      FormOutlineButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(seconds: 0));
                          state.onClose();
                          await Future.delayed(const Duration(seconds: 0));
                          if (state.onScheduleTransaction != null) {
                            state.onScheduleTransaction!();
                          }
                        },
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        icon: const Icon(Icons.insert_invitation_outlined, size: 23),
                        text: 'Schedule Transaction',
                        textColor: Theme.of(context).primaryColor,
                      ),
                    if (state.result.data?.showReceipt == 1) const SizedBox(height: 10),
                    if (state.result.data?.showReceipt == 1)
                      FormButton(
                        text: 'Done',
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(seconds: 0));
                          state.onClose();
                        },
                      ),
                    if (state.result.data?.showReceipt != 1)
                      FormButton(
                        text: 'Done',
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(seconds: 0));
                          state.onClose();
                        },
                      ),
                  ],
                );
              } else if (state is SuccessfulPayeeAddedOptionsLoader) {
                var title = state.title;
                if (state.result.status == StatusConstants.pending) {
                  title = 'Pending';
                } else if (state.result.status == StatusConstants.processing) {
                  title = 'Processing';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 42.5,
                      backgroundColor: Color(0xffCEFFCE),
                      child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: state.result.status == StatusConstants.success ? Theme.of(context).primaryColor : Colors.amber),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        textAlign: TextAlign.center,
                        state.result.message,
                        style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    FormButton(
                      text: 'View Details',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                        await Future.delayed(const Duration(seconds: 0));
                        if (state.onShowDetails != null) {
                          state.onShowDetails!();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    FormButton(
                      text: 'Done',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                      },
                    ),
                  ],
                );
              } else if (state is SuccessfulBulkPaymentLoader) {
                var title = state.title;
                if (state.result.status == StatusConstants.pending) {
                  title = 'Pending';
                } else if (state.result.status == StatusConstants.processing) {
                  title = 'Processing';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 42.5,
                      backgroundColor: Color(0xffCEFFCE),
                      child: Icon(Icons.task_alt_outlined, color: Color(0xff067335), size: 45),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: state.result.status == StatusConstants.success ? Theme.of(context).primaryColor : Colors.amber),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        textAlign: TextAlign.center,
                        state.result.message,
                        style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    FormButton(
                      text: 'View History',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                        await Future.delayed(const Duration(seconds: 0));
                        if (state.onGotoHistory != null) {
                          state.onGotoHistory!();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    FormButton(
                      text: 'Done',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                      },
                    ),
                  ],
                );
              } else if (state is FailedLoader) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(
                    //   'assets/img/error.svg',
                    //   width: 100,
                    // ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      state.message,
                      style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                );
              } else if (state is FailedWithOptionsLoader) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // SvgPicture.asset(
                    //   'assets/img/error.svg',
                    //   width: 100,
                    // ),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      state.title,
                      style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    if (state.message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          textAlign: TextAlign.center,
                          state.message!,
                          style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                    const Spacer(),
                    FormButton(
                      text: 'Retry',
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(const Duration(seconds: 0));
                        state.onClose();
                      },
                    ),
                  ],
                );
              } else if (state is InfoLoader) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      state.message,
                      style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    ],
  );

  void _listener(LoaderState state) {
    if (state is InitialLoader) {
      return;
    }

    if (state is StopLoading) {
      return;
    }
  }
}
