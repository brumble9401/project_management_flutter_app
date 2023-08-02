import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/routes/route_name.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardingContent(
                    image: data[index].image,
                    title: data[index].title,
                  ),
                ),
              ),
              Row(children: [
                ...List.generate(
                  data.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: DotIndicator(isActive: index == _pageIndex),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Builder(builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_pageIndex != 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RouteName.initialRoot, (route) => false);
                        }
                      },
                      // Other button properties
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: _pageIndex != 2
                          ? SvgPicture.asset("assets/icons/arrow-right.svg")
                          : const Text(
                              "start",
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  }),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: isActive ? 25 : 10,
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

class Onboard {
  final String image, title;

  Onboard({
    required this.image,
    required this.title,
  });
}

final List<Onboard> data = [
  Onboard(
    image: "assets/images/onboarding2.png",
    title: "Welcome !!! Do you want to \nclear tasks super fast",
  ),
  Onboard(
    image: "assets/images/onboarding3.png",
    title: "Easily arrange work order\nfor you tonmange",
  ),
  Onboard(
    image: "assets/images/onboarding1.png",
    title: "Get started with us!",
  ),
];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image, title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Center(
          child: Image.asset(
            image,
            height: 250,
          ),
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
      ],
    );
  }
}
