import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/constant.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:fl_quiz_app/models/campuses_model.dart';

class CampusDonation extends StatefulWidget {
  final VoidCallback onDonationSuccess;

  const CampusDonation({Key? key, required this.onDonationSuccess}) : super(key: key);

  @override
  State<CampusDonation> createState() => _CampusDonationState();
}

class _CampusDonationState extends State<CampusDonation> with WidgetsBindingObserver {
  String? _selectedCampus;
  final _amtController = TextEditingController();
  bool _showCampusError = false;
  bool _notEnoughPointsError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);  // Observe changes in view insets
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Remove observer
    _amtController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: bottomInset > 0 ? bottomInset : 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Campus Donation',
                style: blackBold20,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(pointsImage, height: 20),
                const SizedBox(width: 10),
                Text('${global.totalPoints}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Campuses>>(
              future: _fetchCampuses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final campuses = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCampus,
                        hint: const Text('Select Campus'),
                        items: _buildCampusDropdownItems(campuses),
                        onChanged: (value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedCampus = value;
                              _showCampusError = false;
                            });
                          });
                        },
                      ),
                      if (_showCampusError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please select a campus to donate.',
                            style: blackSemiBold14,
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
            if (_selectedCampus != null) ...[
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter amount to donate',
                    border: InputBorder.none,
                  ),
                  controller: _amtController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    int amount = int.tryParse(value) ?? 0;
                    int totalPoints = global.totalPoints ?? 0;
                    if (amount > totalPoints) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _notEnoughPointsError = true;
                        });
                        _amtController.text = '$totalPoints';
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _notEnoughPointsError = false;
                        });
                      });
                    }
                  },
                ),
              ),
            ],
            if (_selectedCampus != null && _notEnoughPointsError)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Not enough points for donation ',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => donatePoints(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
              child: const Text('Donate', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildCampusDropdownItems(List<Campuses> campuses) {
    return campuses.map((campus) {
      return DropdownMenuItem(
        value: campus.name,
        child: Text(campus.name),
      );
    }).toList();
  }

  void donatePoints(BuildContext context) async {
    int amount = int.tryParse(_amtController.text) ?? 0;
    int totalPoints = global.totalPoints ?? 0;

    if (_selectedCampus == null) {
      setState(() {
        _showCampusError = true;
      });
      return;
    }

    if (amount <= 0 || amount > totalPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid donation amount or insufficient points.')),
      );
      return;
    }

    int updatedUserPoints = totalPoints - amount;
    Campuses? selectedCampus = await _getSelectedCampus();

    if (selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to find selected campus.')),
      );
      return;
    }

    try {
      await ApiServices.updatedUserPoints(global.userId ?? '', updatedUserPoints, context);
      int updatedCampusPoints = selectedCampus.points + amount;
      await ApiServices.updateCampusPoints(selectedCampus.id, updatedCampusPoints, context);
      global.totalPoints = updatedUserPoints;
      widget.onDonationSuccess();
      _amtController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation was successful.')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Failed to donate points: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to donate points. Please try again later.')),
      );
    }
  }

  Future<List<Campuses>> _fetchCampuses() async {
    try {
      return await ApiServices.fetchAllCampuses(context);
    } catch (error) {
      print('Error fetching campuses: $error');
      return [];
    }
  }

  Future<Campuses?> _getSelectedCampus() async {
    try {
      List<Campuses> campuses = await _fetchCampuses();
      Campuses selectedCampus = campuses.firstWhere(
        (campus) => campus.name == _selectedCampus,
        orElse: () {
          throw Exception('Selected campus not found');
        },
      );
      return selectedCampus;
    } catch (error) {
      print('Error fetching campuses: $error');
      rethrow;
    }
  }
}