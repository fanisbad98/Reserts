import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/models/withdraw_history_model.dart';
import 'package:fl_quiz_app/providers/ads_provider.dart';
import 'package:fl_quiz_app/providers/wallet_provider.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:provider/provider.dart';
import '../../helper/draw_dashed_horizontal_line.dart';
import '../../utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/widgets.dart';
import 'withdraw_sheet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    if (global.isAdShow) {
      global.isRewardedVideoAdsShow
          ? Provider.of<AdsProvider>(context, listen: false).createRewardedAd()
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(20.0).copyWith(bottom: 66),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  withdrawTag(context),
                  heightSpace20,
                  global.isAdShow
                      ? global.isRewardedVideoAdsShow
                          ? Consumer<AdsProvider>(
                              builder: (context, ads, child) => ads
                                          .rewardedAd !=
                                      null
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Provider.of<AdsProvider>(
                                                    context,
                                                    listen: false)
                                                .pointsForRewardedAd(context);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Earn Coins',
                                                style: primaryBold15,
                                              ),
                                              widthSpace5,
                                              Image.asset(pointsImage,
                                                  height: 20)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  Text('Withdraw history', style: colorC3SemiBold18),
                  FutureBuilder(
                    future: ApiServices.fetchWithdrawalHistory(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return Expanded(
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  withdrawIcon,
                                  height: 5.5.h,
                                  color: colorE2,
                                ),
                                heightSpace10,
                                  Text('No Withdrawal History Found',
                                    style: whiteSemiBold14),
                              ],
                            )),
                          );
                        } else {
                          return Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  List<WithdrawHistoryData>
                                      withdrawHistoryData = (snapshot.data);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                withdrawHistoryData[index]
                                                    .reqStatus!,
                                                style: TextStyle(
                                                    color: isolateColor(
                                                        withdrawHistoryData[
                                                                index]
                                                            .reqStatus),
                                                    fontFamily: 'SB',
                                                    fontSize: 11.2.sp)),
                                            Text(
                                                DateFormat('d MMM y').format(
                                                    withdrawHistoryData[index]
                                                        .createdAt!),
                                                style: color94SemiBold14),
                                          ],
                                        ),
                                        Text(
                                            '${global.currencySymbol}${withdrawHistoryData[index].amount}',
                                            style: textColorBold16)
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: Color(0xff83ccdf),
                                    thickness: 2,
                                  );
                                },
                                itemCount: snapshot.data.length),
                          );
                        }
                      } else {
                        return Expanded(
                          child: Shimmer(
                            child: ShimmerLoading(
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        height: 60,
                                        width: 100.w,
                                        color: black,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: Color(0xff83ccdf),
                                      thickness: 2,
                                    );
                                  },
                                  itemCount: 10),
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector withdrawTag(BuildContext context) {
    return GestureDetector(
      onTap: () => showWithdrawSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff83ccdf),
          borderRadius: borderRadius10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18).copyWith(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        Text('Point', style: textColorBold18),
                        heightSpace3,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer<WalletProvider>(
                              builder: (context, WalletProvider walletProvider,
                                      child) =>
                                  Text(walletProvider.myPoint.toString(),
                                      style: whiteBold18),
                            ),
                            widthSpace5,
                            Image.asset(pointsImage, height: 20)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Image.asset(equalTo, height: 36),
                  SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        Text('Amount', style: textColorBold18),
                        heightSpace3,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(global.currencySymbol,
                                style: pointsColorBold18),
                            Text(calculateAmount(), style: whiteBold18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: 90.w,
                child: CustomPaint(painter: DrawDashedHorizontalLine())),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 19, 10),
              child: Row(
                children: [
                  Text('1000', style: blackSemiBold14),
                  widthSpace5,
                  Image.asset(pointsImage, height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('=', style: blackBold18),
                  ),
                  Text('${global.currencySymbol}${global.conversionRate}',
                      style: blackSemiBold14),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11.5, vertical: 3),
                    decoration: BoxDecoration(
                        color: const Color(0xffDBD1FB),
                        borderRadius: borderRadius5,
                        boxShadow: [primaryButtonShadow6],
                        border: Border.all(color: primaryColor)),
                    child: Text('Withdraw', style: textColorSemiBold14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: PrimaryAppBar(
          title: 'Wallet',
          withBackArrow: false,
        ));
  }

  showWithdrawSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      context: context,
      builder: (context) => const WithdrawSheet(),
    );
  }

  isolateColor(item) {
    switch (item) {
      case 'Approved':
        return const Color(0xff3b8917);
      case 'Pending':
        return const Color(0xffe89734);
      case 'Rejected':
        return const Color(0xffC81212);
    }
  }

  String calculateAmount() {
    var tempValue = global.totalPoints! / (1000 / global.conversionRate);
    if (tempValue.toString().length == 3) {
      // return tempValue.toString().padRight(4, '0');
      return tempValue.toString();
    } else {
      // return tempValue.toString().substring(0, 4);
      return tempValue.toString();
    }
  }
}
