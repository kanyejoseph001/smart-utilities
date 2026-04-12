import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: '1');
  
  String _fromCurrency = 'USD';
  String _toCurrency = 'NGN';           // Default for Nigeria
  double _result = 0.0;
  bool _isLoading = false;
  String? _error;

  // Popular currencies (feel free to add more)
  final List<String> _currencies = [
    'USD', 'EUR', 'NGN', 'GBP', 'JPY', 'CAD', 'AUD', 'INR', 'CNY', 'ZAR'
  ];

  Map<String, double> _exchangeRates = {};

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate.host/latest?base=$_fromCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _exchangeRates = Map<String, double>.from(
            (data['rates'] as Map).map((key, value) => MapEntry(key, value.toDouble())),
          );
          _convert();
        });
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      setState(() => _error = 'No internet or API error. Try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _convert() {
    if (_exchangeRates.isEmpty || _amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    final rate = _exchangeRates[_toCurrency] ?? 1.0;

    setState(() {
      _result = amount * rate;
      _error = null;
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _fetchExchangeRates(); // Refresh rates with new base
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Amount Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _convert(),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        // From Currency
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromCurrency,
                            decoration: const InputDecoration(labelText: 'From'),
                            items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _fromCurrency = val);
                                _fetchExchangeRates();
                              }
                            },
                          ),
                        ),
                        IconButton(onPressed: _swapCurrencies, icon: const Icon(Icons.swap_horiz, size: 32)),
                        // To Currency
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toCurrency,
                            decoration: const InputDecoration(labelText: 'To'),
                            items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _toCurrency = val);
                                _convert();
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

            // Result
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Converted Amount', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text(
                        _result.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      Text(_toCurrency, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 8),
                      Text('1 $_fromCurrency = ${_exchangeRates[_toCurrency]?.toStringAsFixed(4) ?? ''} $_toCurrency'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 40),
            const Text(
              'Rates powered by exchangerate.host\n(Updates live when you change currency)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}