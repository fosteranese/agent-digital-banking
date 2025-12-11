import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/app/app_bloc.dart';
import '../../constants/status.const.dart';
import '../../data/models/initialization_response.dart';
import '../../utils/app.util.dart';
import '../../utils/theme.util.dart';
import '../components/form/button.dart';
import '../components/intro_slide.dart';
import 'welcome.page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  static const String routeName = '/intro';

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;
  InitializationResponse? data;

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(
        i == _currentPage
            ? _indicator(true)
            : _indicator(false),
      );
    }
    return list;
  }

  Timer? _timer;
  bool _pause = false;

  @override
  void initState() {
    _slide();
    super.initState();
  }

  void _slide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) {
      try {
        final data = (context.read<AppBloc>().data);
        if (data == null) {
          return;
        }

        if (_pause) {
          return;
        }
        if (data.walkThrough == null ||
            _currentPage == data.walkThrough!.length - 1) {
          // _currentPage = 0;
          // _pageController.jumpToPage(_currentPage);
        } else {
          ++_currentPage;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
          );
        }
      } catch (_) {}
    });
  }

  Widget _indicator(bool isActive) {
    var width = 20.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: isActive
            ? ThemeUtil.secondaryColor
            : Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  void _nextPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  final buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        switch (AppUtil.deviceStatus.status) {
          case StatusConstants.pending:
            return const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
            );

          case StatusConstants.error:
          case StatusConstants.failed:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppUtil.deviceStatus.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
        }

        if (state is! NewDevice &&
            state is! ExistingDevice &&
            state is! UserExistOnDevice) {
          return Center(
            child: Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: LoadingAnimationWidget.inkDrop(
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          );
        }

        final data = context.read<AppBloc>().data!;
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Theme.of(context).primaryColorDark,
              ),
              GestureDetector(
                onLongPressStart: (_) {
                  _pause = true;
                },
                onLongPressEnd: (_) {
                  _pause = false;
                },
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  dragStartBehavior:
                      DragStartBehavior.start,
                  controller: _pageController,
                  onPageChanged: _nextPage,
                  pageSnapping: true,
                  padEnds: false,
                  scrollDirection: Axis.horizontal,
                  children: data.walkThrough!.map((e) {
                    return IntroSlide(
                      title: e.title!,
                      subtitle: e.description!,
                      imageUrl:
                          e.pictureBase64 ??
                          '${data.imageBaseUrl}${data.imageDirectory}/${e.picture}',
                    );
                  }).toList(),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 40,
                  left: 20,
                  right: 20,
                ),
                child: Builder(
                  builder: (context) {
                    if (_currentPage ==
                        data.walkThrough!.length - 1) {
                      return FormButton(
                        key: buttonKey,
                        backgroundColor:
                            ThemeUtil.secondaryColor,
                        foregroundColor:
                            ThemeUtil.primaryColor,
                        icon: Icons.east_outlined,
                        onPressed: () {
                          context.go(WelcomePage.routeName);
                        },
                        text: 'Get Started',
                      );
                    }

                    return Row(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: _buildPageIndicator(
                            data.walkThrough!.length,
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Spacer(),
                        SizedBox(
                          width: 157,
                          child: FormButton(
                            key: buttonKey,
                            backgroundColor:
                                ThemeUtil.secondaryColor,
                            foregroundColor:
                                ThemeUtil.primaryColor,
                            icon: Icons.east_outlined,
                            onPressed: () {
                              _nextPage(_currentPage + 1);
                              _pageController.animateToPage(
                                _currentPage,
                                duration: const Duration(
                                  milliseconds: 500,
                                ),
                                curve: Curves.easeInOut,
                              );
                            },
                            text: 'Next',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
