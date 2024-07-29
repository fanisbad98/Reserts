import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_quiz_app/models/campuses_model.dart';
import 'package:fl_quiz_app/models/categories_model.dart';
import 'package:fl_quiz_app/models/feature_model.dart';
import 'package:fl_quiz_app/models/my_profile_model.dart';
import 'package:fl_quiz_app/models/payment_gateway_model.dart';
import 'package:fl_quiz_app/models/security_questions_model.dart';
import 'package:fl_quiz_app/models/top_user_model.dart';
import 'package:fl_quiz_app/providers/auth_handler.dart';
import 'package:fl_quiz_app/providers/profile_provider.dart';
import 'package:fl_quiz_app/providers/wallet_provider.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../models/withdraw_history_model.dart';
import '../utils/constant.dart';

final Dio _dio = Dio();

class ApiServices {
  static Future fetchMyProfile(context) async {
    MyProfileResponse? myProfileResponse;
    try {
      Response response = await _dio.get(
        ApiConstants.myProfile,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        // log(response.data['data'].toString());
        myProfileResponse = MyProfileResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    log(myProfileResponse!.data.referralCode.toString());
    return myProfileResponse;
  }

static Future<List<Campuses>> fetchAllCampuses(BuildContext context) async {
  try {
    Response response = await _dio.get(
      ApiConstants.allCampuses,
      options: Options(
        headers: {'Authorization': 'Bearer ${global.token}'},
      ),
    );

    if (response.statusCode == 200 && response.data != null && response.data['data'] != null) {
      List<dynamic> campusesData = response.data['data'];
      if (campusesData.isNotEmpty) {
        return List<Campuses>.from(campusesData.map((x) => Campuses.fromJson(x as Map<String, dynamic>)));

      }
      return []; // Return an empty list if data is empty
    }
    return []; // Return an empty list if response code is not 200 or data is null
  } catch (error) {
    print('Error fetching campuses: $error');
    return []; // Return an empty list on error
  }
}




static Future<void> saveUserAnswer(String categoryId, String questionId, String selectedAnswer, String userId, context) async {
  try {
    Response response = await _dio.post(
      ApiConstants.saveUserAnswer,
      data: {
        'questionId': questionId,
        'selectedAnswer': selectedAnswer,
        'userId': userId,
        'categoryId': categoryId,
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${global.token}'},
      ),
    );

    print('Response status code: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      log('User answer saved successfully');
    } else {
      log('Failed to save user answer: ${response.data}');
    }
  } on DioError catch (e) {
    print('Error: ${e.message}');
    if (e.response!.data['err_msg'] == 'Token expired.') {
      AuthHandler.logOut(context);
    } else {
      log(e.message.toString());
    }
  }
}


static Future<void> joinCampus(String campusId, String userId,  context) async {
  try {
    print('Joining campus with ID: $campusId');
    print('User ID: $userId');

    Response response = await _dio.post(
      '${ApiConstants.baseURL}campuses/$campusId/join',
      data: {'userId': userId, 'campusId': campusId},
      options: Options(
        headers: {'Authorization': 'Bearer ${global.token}'},
      ),
    );

    if (response.statusCode == 200) {
      log('User joined the campus successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Joined the campus successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (response.statusCode == 409 ) {
      throw 'UserAlreadyAssociated';
    } else {
      throw 'Failed to join campus: ${response.data['message']}';
    }
  } on DioError catch (e) {
    if (e.response?.data['err_msg'] == 'Token expired.') {
      AuthHandler.logOut(context);
      throw 'TokenExpired';
    } else {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.response?.data['message'] ?? e.message}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    if (e == 'UserAlreadyAssociated') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are already associated with a campus.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join campus: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}


static Future<List<String>> fetchMembersNames(String campusId, context) async {
  try {
    print(campusId);
    Response response = await _dio.get(
      '${ApiConstants.allCampuses}/$campusId',
      options: Options(
        headers: {'Authorization': 'Bearer ${global.token}'},
      ),
    );

    if (response.statusCode == 200) {
      log('Successfully fetched member names for the campus');
      List<String> memberNames = List<String>.from(response.data['memberNames']);
      print('Members names: $memberNames');
      return memberNames;
    } else {
      log('Failed to fetch member names for the campus. Response: ${response.data}');
      throw Exception('Failed to fetch member names for the campus');
    }
  } on DioError catch (e) {
    if (e.response?.data['err_msg'] == 'Token expired.') {
      AuthHandler.logOut(context);
    } else {
      log(e.toString());
    }
    throw Exception('Error fetching member names for the campus: $e');
  } catch (error) {
    log('Error fetching member names for the campus: $error');
    throw Exception('Error fetching member names for the campus: $error');
  }
}

  static Future<List<SecurityQuestionData>> fetchSecurityQuestions({
    required context,
  }) async {
    List<SecurityQuestionData> questionResponse = [];
    try {
      Response response = await _dio.get(
        ApiConstants.securityQuestions,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        questionResponse =
            SecurityQuestionResponse.fromJson(response.data).data;
            print('Response Data: $questionResponse');
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return questionResponse;
  }



  static Future<List<AllCategoriesData>> fetchAllCategories(context) async {
    AllCategoriesResponse? categoriesResponce;
    try {
      Response response = await _dio.get(
        ApiConstants.allCategories,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        categoriesResponce = AllCategoriesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return categoriesResponce!.data;
  }

//   static Future<Map<String, dynamic>> getQuizProgress(String? userId, String categoryId, context) async {
//   try {
//     Response response = await _dio.get(
//       '${ApiConstants.baseURL}progress/getQuizProgress',
//       queryParameters: {
//         'userId': userId,
//         'quizId': categoryId,
//       },
//       options: Options(
//         headers: {'Authorization': 'Bearer ${global.token}'},
//       ),
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = response.data;
//       log('Quiz progress fetched successfully: $data');
//       return data; 
//     } else {
//       throw 'Failed to fetch quiz progress: ${response.data['message']}';
//     }
//   } on DioError catch (e) {
//     if (e.response?.data['err_msg'] == 'Token expired.') {
//       AuthHandler.logOut(context);
//       throw 'TokenExpired';
//     } else {
//       log('Error fetching quiz progress: ${e.message}');
      
//     }
//     throw e;
//   } catch (error) {
//     log('Error: $error');
//     throw error;
//   }
// }

//   static Future<void> saveQuizProgress(String? quizId, String? userId, int currentQuestionIndex, List<String> answeredQuestions, bool isCompleted, context) async {
//     try{
//       Response response = await _dio.post(
//         '${ApiConstants.baseURL}progress/saveQuizProgress',
//         data: {'quizId': quizId,
//         'userId': userId,
//         'currentQuestionIndex' : currentQuestionIndex,
//         'answeredQuestion' : answeredQuestions,
//         'isCompleted' : isCompleted},

//         options: Options(
//           headers: {'Authorization':'Bearer ${global.token}'},
//         ),
//       );

//       if (response.statusCode == 200) {
//         log('Quiz progress saved successfully');
//       } else {
//         throw 'Failed to save quiz progress: ${response.data['message']}';
//       }
//     } on DioError catch (e) {
//       if (e.response?.data['err_msg'] == 'Token expired.') {
//         AuthHandler.logOut(context);
//         throw 'TokenExpired';
//       } else {
//         log('Error saving Quiz progress: ${e.message}');
//       }
//     }
//   }

  static Future<void> leaveCampus(String campusId, String userId, context) async{
      try {
      Response response = await _dio.delete(
        '${ApiConstants.baseURL}campuses/$campusId/leaveCampus',
        data: {'campusId': campusId,
      'userId': userId},
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );

      if (response.statusCode == 200) {
        print('User left the campus successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have left the campus successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw 'Failed to leave campus: ${response.data['message']}';
      }
    } on DioError catch (e) {
      if (e.response?.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
        throw 'TokenExpired';
      } else {
        print('Error leaving campus: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error leaving campus: ${e.message}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  static Future<List<FeatureCategoriesData>> fetchCategories(context) async {
    FeatureCategoriesResponse? featureCategoriesResponce;
    try {
      Response response = await _dio.get(
        ApiConstants.featureCategories,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        featureCategoriesResponce =
            FeatureCategoriesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return featureCategoriesResponce!.data;
  }

  static Future<List<TopUserData>> fetchTopUsers(context) async {
    TopUserResponse? topUserResponse;
    try {
      Response response = await _dio.get(
        ApiConstants.topUsers,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        topUserResponse = TopUserResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return topUserResponse!.data;
  }

  static Future fetchWithdrawalHistory(context) async {
    WithdrawHistoryResponse? withdrawalHistoryResponse;
    try {
      Response response = await _dio.get(
        ApiConstants.withdrawals,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        withdrawalHistoryResponse =
            WithdrawHistoryResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return withdrawalHistoryResponse!.data;
  }

  static Future<dynamic> fetchQuestionList(
      {required String quizId,
      String? userId,
      required context}) async {
    QuestionResponse? questionResponce;
    try {
      Response response = await _dio.get(
        ApiConstants.questions,
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
        queryParameters: {
          'id': quizId,
          'userId': userId,
        },
      );
      if (response.statusCode == 200) {       
        questionResponce = QuestionResponse.fromJson(response.data);      
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return questionResponce?.data;
  }

  static Future minusHintPoint(context) async {
    try {
      Response addPointsResponse = await Dio().post(
        ApiConstants.addPoints,
        data: {"point": -(global.hintPoints)},
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );

      if (addPointsResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            "totalPoints", addPointsResponse.data['data']['totalPoints']);

        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future minusPointsAtQuit({
    required int wrongAnswer,
    required context,
  }) async {
    try {
      Response addPointsResponse = await Dio().post(
        ApiConstants.addPoints,
        data: {"point": -(global.minusGradPoints * wrongAnswer)},
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );

      if (addPointsResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            "totalPoints", addPointsResponse.data['data']['totalPoints']);
        // global.totalPoints = addPointsResponse.data['data']['totalPoints'];
        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future<void> updatedUserPoints(String userId, int updatedPoints, context) async {
  var walletProvider = Provider.of<WalletProvider>(context, listen: false);
  try {
    Response response = await _dio.put(
      '${ApiConstants.baseURL}users/$userId',
      data: {'userId': userId,
      'updatedPoints': updatedPoints},
      options: Options(
        headers: {'Authorization': 'Bearer ${global.token}'},
      ),
    );
    //print('Dio request sent to: ${ApiConstants.baseURL}users/$userId');
    //print('Dio request payload: { userId: $userId, updatedPoints: $updatedPoints }');
    //print('Dio response: ${response.data}');
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("totalPoints", response.data['data']['totalPoints']);
      global.totalPoints = response.data['data']['totalPoints'];
      walletProvider.updateMyPoints(updatedPoints);
      log('User points updated successfully');
    } else {
      log('Failed to update user points: ${response.data}');
    }
  } on DioError catch (e) {
    if (e.response?.data['err_msg'] == 'Token expired.') {
      AuthHandler.logOut(context);
    } else {
      log(e.toString());
    }
  }
}
  static Future addPointsPerQuestion({required int points, required context}) async{
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try{
      Response addPointsResponse = await Dio().post(
        ApiConstants.addPoints,
        data: {
          "point": ((global.pointsPerQuestion)
          )
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        )
      );
      if (addPointsResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            "totalPoints", addPointsResponse.data['data']['totalPoints']);
        walletProvider
            .updateMyPoints(addPointsResponse.data['data']['totalPoints']);
        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future addPointsByResult(
      {required int answersGiven,
      required context}) async {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      Response addPointsResponse = await Dio().post(
        ApiConstants.addPoints,
        // data: {"point": (global.pointsPerQuestion * correctAnswer)},//!old method
        data: {
          "point": ((global.pointsPerQuestion * answersGiven) 
         )
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );

      if (addPointsResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            "totalPoints", addPointsResponse.data['data']['totalPoints']);
        // global.totalPoints = addPointsResponse.data['data']['tot alPoints'];
        walletProvider
            .updateMyPoints(addPointsResponse.data['data']['totalPoints']);
        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future addPointsByVideoAd(context) async {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      Response response = await _dio.post(
        ApiConstants.addPoints,
        data: {"point": global.rewardedVideoPoint},
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("totalPoints", response.data['data']['totalPoints']);
        walletProvider.updateMyPoints(response.data['data']['totalPoints']);
        global.totalPoints = response.data['data']['totalPoints'];
        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future fetchPaymentGateways(context) async {
    PaymentGatewayResponse? paymentGatewayResponse;
    try {
      var response = await _dio.get(ApiConstants.paymentGateways,
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));
      if (response.statusCode == 200) {
        paymentGatewayResponse = PaymentGatewayResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return paymentGatewayResponse!.data;
  }

  static Future createWithdrawRequest(
      {required double amount,
      required int points,
      required String paymentMethod,
      required String paymentVia,
      required dynamic context}) async {
    try {
      Response response = await _dio.post(ApiConstants.withdraw,
          data: {
            "amount": amount,
            "points": points,
            "paymentMethod": paymentMethod,
            "paymentVia": paymentVia
          },
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("totalPoints", response.data['data']['totalPoints']);
        global.totalPoints = prefs.getInt("totalPoints");
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future updateProfile(
      {required String name,
      required File? file,
      required dynamic context}) async {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (file != null) {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'name': name,
        "profilePic": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      try {
        Response response = await Dio().post(
          ApiConstants.updateProfile,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer ${global.token}",
              "Content-Type": "multipart/form-data",
            },
          ),
        );
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          profileProvider.updateNameOrProfile(
              name, response.data['data']['profilePic']);
          prefs.setString('userName', response.data['data']['name']);
          global.userName = prefs.getString('userName');
          prefs.setString('profilePic', response.data['data']['profilePic']);
          global.profilePic = prefs.getString('profilePic');
        }
      } on DioError catch (e) {
        if (e.response!.data['err_msg'] == 'Token expired.') {
          AuthHandler.logOut(context);
        } else {
          log(e.toString());
        }
      }
    } else {
      FormData formData = FormData.fromMap({
        'name': name,
      });
      try {
        Response response = await Dio().post(
          ApiConstants.updateProfile,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer ${global.token}",
            },
          ),
        );
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userName', response.data['data']['name']);
          global.userName = prefs.getString('userName');
        }
      } on DioError catch (e) {
        if (e.response!.data['err_msg'] == 'Token expired.') {
          AuthHandler.logOut(context);
        } else {
          log(e.message.toString());
        }
      }
    }
  }

  static Future createHelpReq(
      {required String name,
      required String email,
      required String msg,
      required dynamic context}) async {
    try {
      Response response = await _dio.post(ApiConstants.contactUs,
          data: {"name": name, "email": email, "message": msg},
          options:
              Options(headers: {'Authorization': 'Bearer ${global.token}'}));
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: primaryColor,
            content: Text(
              response.data['msg'],
              style: whiteSemiBold14,
            )));
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
  }

  static Future getRulesOfQuiz(context) async {
    String? resposeData;
    try {
      Response response = await _dio.get(ApiConstants.ruleOfQuiz,
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));
      if (response.statusCode == 200) {
        resposeData = response.data['data']['ruleOfQuiz'];
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return resposeData;
  }

  static Future<void> updateCategoryPoints(String categoryId, int donatedPoints, context) async {
  try {
    Response response = await _dio.put(
      '${ApiConstants.baseURL}categories/$categoryId',
      data: {
        'donatedPoints' : donatedPoints,
        'categoryId': categoryId,
      },
      options: Options(
        headers: {'Authorization' : 'Bearer ${global.token}'},
      )
    );
    if(response.statusCode == 200) {
      log('Category updated successfully');
    } else {
      log('Failed to update category data: ${response.data}');
    }
  } catch (e) {
    log('Error updating category: $e');
  }
}

static Future<void> updateCampusPoints(String campusId, int updatedPoints, context ) async {
    try {
      Response response = await _dio.put(
        '${ApiConstants.baseURL}campuses/$campusId',
        data: {'campusId': campusId,
        'updatedPoints': updatedPoints},
        options: Options(
          headers: {'Authorization': 'Bearer ${global.token}'},
        ),
      );
      if (response.statusCode == 200) {
        log('Campus points updated successfully');
      } else {
        log('Failed to update campus points: ${response.data}');
      }
    } on DioError catch (e) {
      log('DioError: ${e.response!.statusCode} - ${e.response!.data}');
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    } catch (e) {
      log('Unexpected error: $e');
    }
  }


  static Future getPrivacyPolicy(context) async {
    String? resposeData;
    try {
      Response response = await _dio.get(ApiConstants.privacyPolicy,
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));

      if (response.statusCode == 200) {
        resposeData = response.data['data']['privacyPolicy'];
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return resposeData;
  }

  static Future getTermsOfUse(context) async {
    String? resposeData;
    try {
      Response response = await _dio.get(ApiConstants.termsOfUse,
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));

      if (response.statusCode == 200) {
        resposeData = response.data['data']['termsOfUse'];
      }
    } on DioError catch (e) {
      if (e.response!.data['err_msg'] == 'Token expired.') {
        AuthHandler.logOut(context);
      } else {
        log(e.message.toString());
      }
    }
    return resposeData;
  }

  static Future logOut() async {
    try {
      Response response = await _dio.put(ApiConstants.logOut,
          options: Options(
            headers: {'Authorization': 'Bearer ${global.token}'},
          ));
      if (response.statusCode == 200) {
        log("Logout Successfully");
      }
    } on DioError catch (e) {
      log(e.message.toString());
    }
  }



}
