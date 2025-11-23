import 'package:flutter/material.dart';
import 'package:maternal_health_risk_app/constants/colors.dart';
import 'package:maternal_health_risk_app/widgets/custom_text_field.dart';
import 'package:maternal_health_risk_app/services/api_service.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _bsController = TextEditingController();
  final _bodyTempController = TextEditingController();
  final _heartRateController = TextEditingController();

  bool _isLoading = false;
  String? _predictionResult;
  String? _errorMessage;

  @override
  void dispose() {
    _ageController.dispose();
    _diastolicBPController.dispose();
    _bsController.dispose();
    _bodyTempController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _ageController.clear();
    _diastolicBPController.clear();
    _bsController.clear();
    _bodyTempController.clear();
    _heartRateController.clear();
    setState(() {
      _predictionResult = null;
      _errorMessage = null;
    });
  }

  Future<void> _makePrediction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _predictionResult = null;
    });

    try {
      // Parse input values
      final age = double.parse(_ageController.text);
      final diastolicBP = double.parse(_diastolicBPController.text);
      final bs = double.parse(_bsController.text);
      final bodyTemp = double.parse(_bodyTempController.text);
      final heartRate = double.parse(_heartRateController.text);

      // Make API call
      final result = await ApiService.makePrediction(
        age: age,
        diastolicBP: diastolicBP,
        bs: bs,
        bodyTemp: bodyTemp,
        heartRate: heartRate,
      );

      // Extract prediction value
      final prediction = result['prediction'];

      setState(() {
        _isLoading = false;
        _predictionResult = 'Predicted Systolic BP: $prediction mmHg';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Systolic BP Prediction',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            size: 60,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Systolic BP Predictor',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter patient vitals to predict Systolic Blood Pressure',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Form
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Patient Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Age Field
                            CustomTextField(
                              controller: _ageController,
                              label: 'Age',
                              hint: 'Enter age (0-120 years)',
                              icon: Icons.calendar_today,
                              minValue: 0,
                              maxValue: 120,
                              unit: 'years',
                            ),
                            const SizedBox(height: 16),

                            // Diastolic BP Field
                            CustomTextField(
                              controller: _diastolicBPController,
                              label: 'Diastolic Blood Pressure',
                              hint: 'Enter diastolic BP (40-150 mmHg)',
                              icon: Icons.favorite,
                              minValue: 40,
                              maxValue: 150,
                              unit: 'mmHg',
                            ),
                            const SizedBox(height: 16),

                            // Blood Sugar Field
                            CustomTextField(
                              controller: _bsController,
                              label: 'Blood Sugar',
                              hint: 'Enter blood sugar (0-30)',
                              icon: Icons.water_drop,
                              minValue: 0,
                              maxValue: 30,
                              unit: 'mmol/L',
                            ),
                            const SizedBox(height: 16),

                            // Body Temperature Field
                            CustomTextField(
                              controller: _bodyTempController,
                              label: 'Body Temperature',
                              hint: 'Enter temperature (95-106°F)',
                              icon: Icons.thermostat,
                              minValue: 95,
                              maxValue: 106,
                              unit: '°F',
                              decimalPlaces: 1,
                            ),
                            const SizedBox(height: 16),

                            // Heart Rate Field
                            CustomTextField(
                              controller: _heartRateController,
                              label: 'Heart Rate',
                              hint: 'Enter heart rate (30-200 bpm)',
                              icon: Icons.monitor_heart,
                              minValue: 30,
                              maxValue: 200,
                              unit: 'bpm',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Predict Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _makePrediction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey[400],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.analytics, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Predict',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Clear Button
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear_all, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Result Display Area
                  if (_predictionResult != null || _errorMessage != null)
                    Card(
                      elevation: 4,
                      color: _errorMessage != null
                          ? Colors.red[50]
                          : Colors.green[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: _errorMessage != null
                              ? Colors.red
                              : Colors.green,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              _errorMessage != null
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              size: 48,
                              color: _errorMessage != null
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage != null
                                  ? 'Error'
                                  : 'Prediction Result',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _errorMessage != null
                                    ? Colors.red[900]
                                    : Colors.green[900],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage ?? _predictionResult ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: _errorMessage != null
                                    ? Colors.red[800]
                                    : Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
