import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHConstants.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';
import 'package:hairsalon_prokit/main.dart';
import 'package:hairsalon_prokit/utils/BHWidgets.dart';

import 'BHLoginScreen.dart';

class BHWalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  BHWalkThroughScreenState createState() => BHWalkThroughScreenState();
}

class BHWalkThroughScreenState extends State<BHWalkThroughScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;
  static const _kDuration = const Duration(seconds: 1);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    changeStatusColor(Colors.transparent);
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(appStore.isDarkModeOn ? scaffoldDarkColor : white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (i) {
              currentPage = i;
              setState(() {});
            },
            children: [
              Column(
                children: <Widget>[
                  commonCacheImageWidget(
                      BHWalkThroughImg1, context.height() * 0.7,
                      width: context.width(), fit: BoxFit.cover),
                  16.height,
                  Text(
                    BHWalkThroughTitle1,
                    textAlign: TextAlign.center,
                    style: boldTextStyle(
                        color: appStore.isDarkModeOn
                            ? white
                            : BHAppTextColorPrimary,
                        size: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      BHWalkThroughSubTitle1,
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(color: BHAppTextColorSecondary),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  commonCacheImageWidget(
                      BHWalkThroughImg2, context.height() * 0.7,
                      width: context.width(), fit: BoxFit.cover),
                  16.height,
                  Text(
                    BHWalkThroughTitle2,
                    textAlign: TextAlign.center,
                    style: boldTextStyle(
                        color: appStore.isDarkModeOn
                            ? white
                            : BHAppTextColorPrimary,
                        size: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      BHWalkThroughSubTitle2,
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(color: BHAppTextColorSecondary),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  commonCacheImageWidget(
                      BHWalkThroughImg3, context.height() * 0.7,
                      width: context.width(), fit: BoxFit.cover),
                  16.height,
                  Text(
                    BHWalkThroughTitle3,
                    textAlign: TextAlign.center,
                    style: boldTextStyle(
                        color: appStore.isDarkModeOn
                            ? white
                            : BHAppTextColorPrimary,
                        size: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      BHWalkThroughSubTitle3,
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(color: BHAppTextColorSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 90,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: DotsIndicator(
                dotsCount: 3,
                position: currentPage,
                decorator: DotsDecorator(
                  color: BHGreyColor.withOpacity(0.5),
                  activeColor: BHColorPrimary,
                  size: Size.square(9.0),
                  activeSize: Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Skip',
                      style: TextStyle(color: BHAppTextColorSecondary)),
                  onPressed: () {
                    BHLoginScreen().launch(context);
                  },
                ),
                TextButton(
                  child: Text(BHBtnNext,
                      style: TextStyle(color: BHAppTextColorSecondary)),
                  onPressed: () {
                    _pageController.nextPage(
                        duration: _kDuration, curve: _kCurve);
                  },
                )
              ],
            ).visible(
              currentPage != 2,
              defaultWidget: Container(
                margin: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 270,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BHColorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        BHLoginScreen().launch(context);
                      },
                      child: Text(BHBtnGetStarted,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: whiteColor)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
