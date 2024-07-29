import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/constant.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _pageIndex = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      {
        'image': onBoardImage1,
        'title': 'Welcome to $appName',
        'subtitle':
            'Lorem ipsum dolor sit amet consectetur.Qudignissim lacus nascetur malesuada cras pharetra sit id nunc. At ac nulla morbi scelerisque et. Adipiscing  sit.',
      },
      {
        'image': onBoardImage2,
        'title': 'Play quiz and collect point',
        'subtitle':
            'Lorem ipsum dolor sit amet consectetur.Qudignissim lacus nascetur malesuada cras pharetra sit id nunc. At ac nulla morbi scelerisque et. Adipiscing  sit.',
      },
      {
        'image': onBoardImage3,
        'title': 'Earn money',
        'subtitle':
            'Lorem ipsum dolor sit amet consectetur.Qudignissim lacus nascetur malesuada cras pharetra sit id nunc. At ac nulla morbi scelerisque et. Adipiscing  sit.',
      },
    ];
    return Scaffold(
        body: Container(
      height: 100.h,
      width: 100.w,
      decoration: const BoxDecoration(
          color: primaryColor,
          image: DecorationImage(
              image: AssetImage(onBoardBubbleBG), fit: BoxFit.cover)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) => setState(() => _pageIndex = value),
                  itemCount: pages.length,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic item = pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Spacer(),
                          Image.asset(
                            item['image'],
                            height: index == 0
                                ? 317
                                : index == 1
                                    ? 270
                                    : 248,
                          ),
                          const Spacer(),
                          Text(item['title'], style: whiteBold22),
                          heightSpace15,
                          Text(
                            'Lorem ipsum dolor sit amet consectetur.Qudignissim lacus nascetur malesuada cras pharetra sit id nunc. At ac nulla morbi scelerisque et. Adipiscing  sit.',
                            style: whiteSemiBold14,
                            textAlign: TextAlign.center,
                          ),
                          heightSpace20,
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pageIndex == pages.length - 1
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(pages.length - 1,
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.fastLinearToSlowEaseIn);
                            },
                            child: Text('SKIP', style: colorDAExtraBold14)),
                    GestureDetector(
                      onTap: () {
                        if (_pageIndex == pages.length - 1) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacementNamed(context, '/LoginPage');
                        } else {
                          _pageController.animateToPage(_pageIndex + 1,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: Text(
                          _pageIndex == pages.length - 1 ? 'LOGIN' : 'NEXT',
                          style: whiteExtraBold14),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 50,
            child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ScrollingDotsEffect(
                    spacing: 10,
                    activeDotScale: 2,
                    activeDotColor: white,
                    dotColor: colorE2,
                    dotHeight: 6,
                    dotWidth: 6),
                onDotClicked: (index) {}),
          )
        ],
      ),
    ));
  }
}
