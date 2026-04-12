import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitConverterScreen extends ConsumerStatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  ConsumerState<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends ConsumerState<UnitConverterScreen> {
  // Categories
  final List<String> _categories = [
    'Length',
    'Weight',
    'Temperature',
    'Volume',
  ];

  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double _inputValue = 0.0;
  double _result = 0.0;

  final TextEditingController _inputController = TextEditingController();

  // Conversion data
  final Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'Meters': 1.0,
      'Kilometers': 0.001,
      'Centimeters': 100.0,
      'Millimeters': 1000.0,
      'Miles': 0.000621371,
      'Yards': 1.09361,
      'Feet': 3.28084,
      'Inches': 39.3701,
    },
    'Weight': {
      'Kilograms': 1.0,
      'Grams': 1000.0,
      'Pounds': 2.20462,
      'Ounces': 35.274,
      'Tons': 0.001,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.0,
      'Kelvin': 1.0,
    },
    'Volume': {
      'Liters': 1.0,
      'Milliliters': 1000.0,
      'Gallons (US)': 0.264172,
      'Cups': 4.22675,
      'Tablespoons': 67.628,
    },
  };

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = 0.0);
      return;
    }
    final value = double.tryParse(_inputController.text);
    if (value != null) {
      setState(() {
        _inputValue = value;
        _convert();
      });
    }
  }

  void _convert() {
    if (_inputValue == 0) {
      _result = 0;
      return;
    }

    final rates = _conversionRates[_selectedCategory]!;

    if (_selectedCategory == 'Temperature') {
      _result = _convertTemperature(_inputValue, _fromUnit, _toUnit);
    } else {
      // Normal conversion: from base unit → to base unit
      final fromRate = rates[_fromUnit]!;
      final toRate = rates[_toUnit]!;
      _result = (_inputValue / fromRate) * toRate;
    }

    setState(() {});
  }

  double _convertTemperature(double value, String from, String to) {
    // First convert to Celsius
    double celsius;
    if (from == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      celsius = value - 273.15;
    } else {
      celsius = value;
    }

    // Then convert from Celsius to target
    if (to == 'Fahrenheit') {
      return celsius * 9 / 5 + 32;
    } else if (to == 'Kelvin') {
      return celsius + 273.15;
    } else {
      return celsius;
    }
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = _conversionRates[_selectedCategory]!.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                        _fromUnit = _conversionRates[value]!.keys.first;
                        _toUnit = _conversionRates[value]!.keys.elementAt(1);
                        _convert();
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter value',
                        border: const OutlineInputBorder(),
                        suffixText: _fromUnit,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromUnit,
                            decoration: const InputDecoration(labelText: 'From'),
                            items: units.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _fromUnit = value;
                                  _convert();
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: _swapUnits,
                          icon: const Icon(Icons.swap_horiz, size: 32),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: const InputDecoration(labelText: 'To'),
                            items: units.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _toUnit = value;
                                  _convert();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Result Card
            if (_result != 0 || _inputController.text.isNotEmpty)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Result',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _result.toStringAsFixed(4),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _toUnit,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}