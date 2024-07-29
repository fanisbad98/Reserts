import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:provider/provider.dart';
import '../../../providers/internet_provider.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportPage> createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  final _nameController = TextEditingController(text: global.userName);
  final _emailController = TextEditingController(text: global.email);
  final _msgController = TextEditingController();

  @override
  void initState() {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (BuildContext context, InternetProvider ip, Widget? child) =>
          ip.status == 'Offline'
              ? const NoConnectionPage()
              : Scaffold(
                  appBar: appBar(),
                  body: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      Image.asset(
                        helpSupportMain,
                        height: 164,
                      ),
                      heightSpace25,
                      PrimaryTextField(
                        spaceBW: heightSpace8,
                        header: 'Name',
                        controller: _nameController,
                        enabled: false,
                        hintText: 'Enter your name',
                      ),
                      heightSpace25,
                      PrimaryTextField(
                        spaceBW: heightSpace8,
                        header: 'Email address',
                        controller: _emailController,
                        enabled: false,
                        hintText: 'Enter your email address',
                      ),
                      heightSpace25,
                      PrimaryTextField(
                        spaceBW: heightSpace8,
                        header: 'Message',
                        controller: _msgController,
                        hintText: 'Write your message here',
                        textInputAction: TextInputAction.done,
                        maxLines: 6,
                      ),
                      heightSpace60,
                      PrimaryButton(
                        text: 'Update',
                        onTap: () {
                          if (_msgController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: primaryColor,
                                content: Text(
                                  "Please enter message",
                                  style: whiteSemiBold14,
                                )));
                          } else {
                            ApiServices.createHelpReq(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                msg: _msgController.text.trim(),
                                context: context);
                          }
                        },
                      )
                    ],
                  )),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: PrimaryAppBar(
          title: 'Help and support',
        ));
  }
}
