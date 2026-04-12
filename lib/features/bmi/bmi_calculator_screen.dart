import 'package:flutter/material.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmi;
  String _status = '';
  Color _statusColor = Colors.grey;

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? heightCm = double.tryParse(_heightController.text);

    if (weight == null || heightCm == null || heightCm <= 0) {
      setState(() => _bmi = null);
      return;
    }

    final heightM = heightCm / 100;
    final bmiValue = weight / (heightM * heightM);

    setState(() {
      _bmi = bmiValue;

      if (bmiValue < 18.5) {
        _status = 'Underweight';
        _statusColor = Colors.blue;
      } else if (bmiValue < 25) {
        _status = 'Normal weight';
        _statusColor = Colors.green;
      } else if (bmiValue < 30) {
        _status = 'Overweight';
        _statusColor = Colors.orange;
      } else {
        _status = 'Obese';
        _statusColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculateBMI(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculateBMI(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            if (_bmi != null)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Text(
                        'Your BMI',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _bmi!.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _status,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _getBmiMessage(_bmi!),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Enter your weight and height to see your BMI',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getBmiMessage(double bmi) {
    if (bmi < 18.5) return 'You may need to gain some weight.';
    if (bmi < 25) return 'Great! You are in the healthy range.';
    if (bmi < 30) return 'Consider losing some weight for better health.';
    return 'It is recommended to consult a doctor.';
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}