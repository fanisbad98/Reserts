// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:fl_quiz_app/models/security_questions_model.dart'; 
// import 'package:fl_quiz_app/utils/constant.dart';

// class SecurityQuestionDialog extends StatefulWidget {
//   final List<SecurityQuestionData> securityQuestions;

//   const SecurityQuestionDialog({Key? key, required this.securityQuestions})
//       : super(key: key);

//   @override
//   SecurityQuestionDialogState createState() => SecurityQuestionDialogState();
// }

// class SecurityQuestionDialogState extends State<SecurityQuestionDialog> {
//   String? userAnswer;
//   late SecurityQuestionData _currentQuestion;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.securityQuestions.isNotEmpty) {
//       final random = Random();
//       final randomIndex = random.nextInt(widget.securityQuestions.length);
//       _currentQuestion = widget.securityQuestions[randomIndex];
//     } else {
//       _currentQuestion = SecurityQuestionData(
//         question: 'No security questions available',
//         optionA: '',
//         optionB: '',
//         optionC: '',
//         optionD: '',
//         correctAnswer: '',
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 0,
//       backgroundColor: white,
//       child : Material(
//         color: white,
//         borderRadius: BorderRadius.circular(15),
//         child: contentBox(context),
//       ),
//     );
//   }

//   Widget contentBox(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(maxWidth: 400), 
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         color: colorEE,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Security Question',
//             style: colorE2Bold20,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             _currentQuestion.question,
//             style: color0SemiBold18,
//           ),
//           const SizedBox(height: 10),
//           buildOptions(),
//           const SizedBox(height: 10),
//           Align(
//             alignment: Alignment.centerRight,
//             child: SizedBox(
//               width: 400, // Adjust width as needed
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (userAnswer == _currentQuestion.correctAnswer) {
//                     Navigator.pop(context, true);
//                   } else {
//                     Navigator.pop(context, false);
//                   }
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                     return Colors.black;
//                   }),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0), // Adjust border radius
//                     ),
//                   ),
//                   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                     const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//                 child: const Text(
//                   'Continue',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildOptions() {
//     return Column(
//       children: [
//         for (String option in [
//           _currentQuestion.optionA,
//           _currentQuestion.optionB,
//           _currentQuestion.optionC,
//           _currentQuestion.optionD,
//         ])
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8), 
//                 color: transparent,
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     userAnswer = option;
//                   });
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                     if (userAnswer == option) {
//                       return colorC3;
//                     }
//                     return Colors.white; 
//                   }),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0), // Adjust border radius
//                     ),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                   child: Text(
//                     option,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: userAnswer == option ? Colors.white : Colors.black, // Adjust text color
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
