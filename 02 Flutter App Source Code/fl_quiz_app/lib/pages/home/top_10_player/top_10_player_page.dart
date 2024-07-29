import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/models/top_user_model.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:flutter/material.dart';

import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class Top10PlayerPage extends StatelessWidget {
  const Top10PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: FutureBuilder(
        future: ApiServices.fetchTopUsers(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TopUserData>? topUserData = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: topUserData!.length,
              itemBuilder: (context, index) {
                // dynamic item = top20PLayerList[index];
                int lastIndex = topUserData.length - 1;
                return PrimaryContainer(
                  padding: const EdgeInsets.all(10),
                  margin: index == lastIndex
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(bottom: 20),
                  color: colorC3,
                  child: Row(
                    children: [
                      Text((index + 1).toString().padLeft(2, '0'),
                          style: textColorBold18),
                      widthSpace15,
                      CircleAvatar(
                        radius: 22.5,
                        backgroundColor: randomColor(index),
                        backgroundImage: NetworkImage(
                            '${ApiConstants.url}${topUserData[index].profilePic}'),
                      ),
                      widthSpace10,
                      Text(topUserData[index].name, style: blackSemiBold16),
                      const Spacer(),
                      Text(topUserData[index].totalPoints.toString(),
                          style: whiteBold18),
                      widthSpace5,
                      Image.asset(pointsImage, height: 20)
                    ],
                  ),
                );
              },
            );
          } else {
            return Shimmer(
              linearGradient: shimmerGradient,
              child: ShimmerLoading(
                isLoading: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return PrimaryContainer(
                      height: 60,
                      margin: index == 9
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(bottom: 20),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  randomColor(int index) {
    switch (index % 7) {
      case 0:
        return const Color(0xffc8ecfc);
      case 1:
        return const Color(0xfffecad6);
      case 2:
        return const Color(0xfff4ce9b);
      case 3:
        return const Color(0xfffec8d4);
      case 4:
        return const Color(0xffffe8a6);
      case 5:
        return const Color(0xffdad1fb);
      case 6:
        return const Color(0xffd9d9d9);
    }
  }

  PreferredSize appBarMethod() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Top 10 Contributors'),
    );
  }
}
