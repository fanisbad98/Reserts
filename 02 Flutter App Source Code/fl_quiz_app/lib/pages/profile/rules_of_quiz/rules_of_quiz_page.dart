import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/internet_provider.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/widgets.dart';

class RulesOfQuizPage extends StatelessWidget {
  const RulesOfQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();

    return Consumer<InternetProvider>(
      builder: (context, ip, child) => ip.status == 'Offline'
          ? const NoConnectionPage()
          : Scaffold(
              appBar: appBar(),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  FutureBuilder(
                      future: ApiServices.getRulesOfQuiz(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer(
                            child: ShimmerLoading(
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: black, borderRadius: borderRadius10),
                              ),
                            ),
                          );
                        } else {
                          return Html(
                              shrinkWrap: true, data: snapshot.data ?? '');
                        }
                      }),
                ],
              ),
            ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Rules of quiz'),
    );
  }
}
