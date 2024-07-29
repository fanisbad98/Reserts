import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/shimmer.dart';
import '../../../providers/internet_provider.dart';
import '../../../services/api_services.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();

    return Consumer<InternetProvider>(
      builder: (BuildContext context, InternetProvider ip, Widget? child) =>
          ip.status == 'Offline'
              ? const NoConnectionPage()
              : Scaffold(
                  appBar: appBar(),
                  body: FutureBuilder(
                      future: ApiServices.getTermsOfUse(context),
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
                          return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Html(data: snapshot.data ?? ''));
                        }
                      }),
                ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Terms of use'),
    );
  }
}
