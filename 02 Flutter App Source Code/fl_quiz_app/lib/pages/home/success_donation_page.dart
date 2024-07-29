import 'package:fl_quiz_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DonationSuccessPage extends StatelessWidget {
  final String? selectedCategory;
  final double? amountDonated;
  final int? pointsToAdd;

  const DonationSuccessPage({
    Key? key,
    required this.selectedCategory,
    required this.amountDonated,
    required this.pointsToAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [colorE2, colorC3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: colorC3,
                          child: Icon(
                            Icons.check_circle,
                            color: color0,
                            size: 115,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your donation was successful ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 90),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Research :', selectedCategory, Icons.book),
                                const SizedBox(height: 5), 
                                _buildDetailRow('Amount :', '$amountDonated€', Icons.credit_card),
                                const SizedBox(height: 5), 
                                _buildDetailRow('Points Added :', '$pointsToAdd', Icons.add),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          width: 100,
                          height: 2,
                          color: Colors.transparent,
                        ),
                        const SizedBox(height: 20),
                        Text('Thank you for helping the research : \n$selectedCategory',
                        textAlign: TextAlign.center,
                        style: whiteSemiBold16)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/CategoriesPage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 5,
                        ),
                        child: Text('Researches', style: whiteBold20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        '/BottomNavigation',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          color : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Back to Home', style: whiteBold16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value, dynamic icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color5E),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title $value',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
