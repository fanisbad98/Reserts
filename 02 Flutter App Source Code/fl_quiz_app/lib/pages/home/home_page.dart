import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/models/feature_model.dart';
import 'package:fl_quiz_app/models/top_user_model.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

import '../../utils/constant.dart';
import '../../utils/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodyMethod(context),
    );
  }

  Widget bodyMethod(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 56),
      children: [
        poster(),
        heightSpace15,
        ...categoriesView(context),
        ...top20PlayerView(context),
      ],
    );
  }

  Widget poster() {
    return Padding(
      padding: const EdgeInsets.all(15).copyWith(top: 5, bottom: 0),
      child: SizedBox(
        height: 190,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: '${ApiConstants.url}${global.bannerImage}',
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  linearGradient: shimmerGradient,
                  child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        height: 190,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(12)),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 77,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: SizerUtil.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(homeBubbleBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConstants.url}${global.profilePic}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Shimmer(
                      child: ShimmerLoading(
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace15,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, ${global.userName!.split(' ')[0].toString()}',
                      style: whiteBold20),
                  Text('Answer questions and help science!', style: colorC3SemiBold14),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> categoriesView(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Researches', style: colorC3SemiBold16),
            PushNavigate(
                navigate: 'CategoriesPage',
                child: Text('View all', style: whiteBold14)),
          ],
        ),
      ),
      FutureBuilder(
        future: ApiServices.fetchCategories(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<FeatureCategoriesData> featureCategoriesData = snapshot.data;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20).copyWith(top: 10),
              itemCount: featureCategoriesData.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .9,
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                dynamic item = featureCategoriesData[index];
                return PrimaryContainer(
                  onTap: () {
                    global.tempQuizId = featureCategoriesData[index].id;
                    Navigator.pushNamed(
                      context,
                      '/PlayQuizPage',
                      arguments: [
                        featureCategoriesData[index].id,
                        featureCategoriesData[index].name
                      ]
                    );
                  },
                  // => Navigator.pushNamed(context, '/PlayQuizPage',
                  //     arguments: [
                  //       featureCategoriesData[index].id,
                  //       featureCategoriesData[index].name
                  //     ]),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      color: colorC3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: profileBgColor,
                          backgroundImage: NetworkImage(
                            '${ApiConstants.url}${item.image}',
                          )),
                      Text(
                        item.name,
                        style: textColorBold16,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
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
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20).copyWith(top: 10),
                  itemCount: 6,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .9,
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return const PrimaryContainer();
                  },
                ),
              ),
            );
          }
        },
      )
    ];
  }

  List<Widget> top20PlayerView(BuildContext context) {
    randomColor(int index) {
      switch (index % 7) {
        case 0:
          return const Color(0xff83ccdf);
        case 1:
          return const Color(0xff83ccdf);
        case 2:
          return const Color(0xff83ccdf);
        case 3:
          return const Color(0xff83ccdf);
        case 4:
          return const Color(0xff83ccdf);
        case 5:
          return const Color(0xff83ccdf);
        case 6:
          return const Color(0xff83ccdf);
      }
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top 10 Contributors', style: colorC3SemiBold16),
            PushNavigate(
                navigate: 'Top10PlayerPage',
                child: Text('View all', style: whiteBold14)),
          ],
        ),
      ),
      SizedBox(
        height: 140,
        child: FutureBuilder(
          future: ApiServices.fetchTopUsers(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<TopUserData> topUserData = snapshot.data;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                padding: const EdgeInsets.all(20).copyWith(top: 15),
                scrollDirection: Axis.horizontal,
                itemCount: topUserData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(right: 7.5)
                        : index == 19
                            ? const EdgeInsets.only(left: 7.5)
                            : const EdgeInsets.symmetric(horizontal: 7.5),
                    child: SizedBox(
                      width: 55,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: randomColor(index),
                                backgroundImage: NetworkImage(
                                    '${ApiConstants.url}${topUserData[index].profilePic}'),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(pointsImage,height: 14),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${topUserData[index].totalPoints}',
                                      style: colorC3SemiBold14,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                SizedBox(
                                  width: 70,
                                  child: Text(topUserData[index].name, style: whiteBold14,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  )
                                )
                            ],
                          ),
                        ],
                      ),
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
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.all(20).copyWith(top: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.only(right: 7.5)
                            : index == 19
                                ? const EdgeInsets.only(left: 7.5)
                                : const EdgeInsets.symmetric(horizontal: 7.5),
                        child: SizedBox(
                          width: 55,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: randomColor(index),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              heightSpace3,
                              Container(
                                decoration: const BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                alignment: Alignment.center,
                                width: 55,
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      )
    ];
  }
}
