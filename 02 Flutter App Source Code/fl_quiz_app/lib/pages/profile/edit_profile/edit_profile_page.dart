import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/profile_provider.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/ui_helper.dart';
import '../../../providers/auth_handler.dart';
import '../../../providers/internet_provider.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  final _nameController = TextEditingController(text: global.userName);
  final _numberController = TextEditingController(text: global.mobileNo);
  final _emailController = TextEditingController(text: global.email);

  @override
  void initState() {
    super.initState();
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, InternetProvider ip, child) => ip.status == 'Offline'
          ? const NoConnectionPage()
          : Scaffold(
              appBar: appBar(),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: SizedBox(
                      height: 135,
                      child: Stack(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => showUpdateSheet(context),
                            child: _imageFile == null
                                ? SizedBox(
                                    height: 127,
                                    width: 127,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${ApiConstants.url}${global.profilePic}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Shimmer(
                                          child: ShimmerLoading(
                                            child: CircleAvatar(
                                              radius: 63.5,
                                              backgroundColor:
                                                  Color(0xffCCC1F0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                : _imageFile != null
                                    ? SizedBox(
                                        height: 127,
                                        width: 127,
                                        child: ClipOval(
                                          child: Image.file(
                                            File(_imageFile!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                    : const CircleAvatar(
                                        radius: 63.5,
                                        backgroundColor: colorC3,
                                      ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => showUpdateSheet(context),
                              child: CircleAvatar(
                                radius: 20.5,
                                backgroundColor: scaffoldColor,
                                child: Image.asset(
                                  cameraIcon,
                                  height: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  heightSpace30,
                  PrimaryTextField(
                    controller: _nameController,
                    spaceBW: heightSpace8,
                    header: 'Name',
                    hintText: 'Enter your name',
                  ),
                  heightSpace22,
                  PrimaryTextField(
                    enabled: false,
                    controller: _numberController,
                    spaceBW: heightSpace8,
                    header: 'Mobile number',
                    hintText: 'Enter your mobile number',
                    keyboardType: TextInputType.number,
                  ),
                  heightSpace22,
                  PrimaryTextField(
                    enabled: false,
                    controller: _emailController,
                    spaceBW: heightSpace8,
                    header: 'Email address',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  heightSpace60,
                  PrimaryButton(
                    text: 'Update',
                    onTap: () async {
                      if (_nameController.text.trim().isNotEmpty) {
                        ApiServices.updateProfile(
                            name: _nameController.text.trim(),
                            file: _imageFile,
                            context: context);
                        setState(() {});
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 5),
                            backgroundColor: primaryColor,
                            content: Text(
                              "Name field can not be empty",
                              style: whiteSemiBold14,
                            )));
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Edit profile'),
    );
  }

  showUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      )),
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change Image', style: blackBold18),
            heightSpace25,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  3,
                  (index) => GestureDetector(
                        onTap: index == 0
                            ? () => imageFromCamera()
                            : index == 1
                                ? () => imageFromGallery()
                                : () => deleteImage(),
                        child: Column(
                          children: [
                            Container(
                              padding: index == 1
                                  ? const EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 15)
                                  : const EdgeInsets.all(11),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: white,
                                boxShadow: [color00Shadow],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                index == 0
                                    ? blueCamera
                                    : index == 1
                                        ? greenGallery
                                        : redBin,
                              ),
                            ),
                            heightSpace10,
                            Text(
                                index == 0
                                    ? 'Camera'
                                    : index == 1
                                        ? 'Gallary'
                                        : 'Remove',
                                style: blackSemiBold16)
                          ],
                        ),
                      )),
            )
          ],
        ),
      ),
    );
  }

  void imageFromCamera() async {
    Navigator.pop(context);
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  imageFromGallery() async {
    Navigator.pop(context);
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String sizeString =
          getFileSizeString(bytes: File(pickedFile.path).lengthSync());
      bool isLessThan10MB = compareFileSize(sizeString, '10 MB');
      if (isLessThan10MB) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        if (!mounted) return;
        UiHelper.showSnackBar(
            context: context,
            message: 'Image size must be less than 10 MB',
            duration: 3);
      }
    }
  }

  String getFileSizeString({required int bytes, int decimals = 2}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  bool compareFileSize(String sizeString, String threshold) {
    // Remove non-digit characters and convert to double
    double fileSize =
        double.parse(sizeString.replaceAll(RegExp(r'[^0-9.]'), ''));

    // Remove non-digit characters and convert to double
    double thresholdSize =
        double.parse(threshold.replaceAll(RegExp(r'[^0-9.]'), ''));

    return fileSize < thresholdSize;
  }

  deleteImage() async {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    Navigator.pop(context);

    if (global.profilePic != global.userPlaceholder) {
      try {
        Response response = await Dio().delete(ApiConstants.deleteProfilePic,
            options: Options(headers: {
              "Authorization": "Bearer ${global.token}",
            }));
        if (response.statusCode == 200) {
          profileProvider.deleteImage();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("profilePic", global.userPlaceholder);
          global.profilePic = prefs.getString("profilePic");
          setState(() {});
        }
      } on DioError catch (e) {
        if (e.response!.data['err_msg'] == 'Token expired.') {
          AuthHandler.logOut(context);
        } else {
          d.log(e.message.toString());
        }
      }
    }
  }
}
