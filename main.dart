import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CurrencyConverter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  
  // Popular currencies with their symbols
  final Map<String, String> currencies = {
    'USD': '🇺🇸 US Dollar',
    'EUR': '🇪🇺 Euro',
    'GBP': '🇬🇧 British Pound',
    'JPY': '🇯🇵 Japanese Yen',
    'AUD': '🇦🇺 Australian Dollar',
    'CAD': '🇨🇦 Canadian Dollar',
    'CHF': '🇨🇭 Swiss Franc',
    'CNY': '🇨🇳 Chinese Yuan',
    'INR': '🇮🇳 Indian Rupee',
    'KRW': '🇰🇷 South Korean Won',
    'BRL': '🇧🇷 Brazilian Real',
    'RUB': '🇷🇺 Russian Ruble',
    'ZAR': '🇿🇦 South African Rand',
    'SGD': '🇸🇬 Singapore Dollar',
    'HKD': '🇭🇰 Hong Kong Dollar',
  };

  @override
  void initState() {
    super.initState();
    _amountController.text = '1';
    _convertCurrency();
  }

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      double amount = double.parse(_amountController.text);
      
      // Using exchangerate-api.com (free tier)
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$_fromCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates'][_toCurrency];
        
        setState(() {
          _convertedAmount = amount * rate;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.attach_money, color: Colors.blue[600]),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _convertCurrency();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Currency Selection Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // From Currency
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _fromCurrency,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: currencies.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _fromCurrency = value!;
                                  });
                                  _convertCurrency();
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Swap Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: FloatingActionButton.small(
                            onPressed: _swapCurrencies,
                            backgroundColor: Colors.blue[600],
                            child: Icon(Icons.swap_horiz, color: Colors.white),
                          ),
                        ),
                        
                        // To Currency
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _toCurrency,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: currencies.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _toCurrency = value!;
                                  });
                                  _convertCurrency();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Result Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Converted Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            '${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    if (!_isLoading && _amountController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '${_amountController.text} $_fromCurrency = ${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Convert Button
            ElevatedButton(
              onPressed: _isLoading ? null : _convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                _isLoading ? 'Converting...' : 'Convert Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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