import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyHomePage(),
    );
  }
}

class CurrencyHomePage extends StatefulWidget {
  const CurrencyHomePage({super.key});

  @override
  State<CurrencyHomePage> createState() => _CurrencyHomePageState();
}

class _CurrencyHomePageState extends State<CurrencyHomePage> {
  // Variables to hold input and result
  final TextEditingController _amountController = TextEditingController();
  double _result = 0.0;
  String _fromCurrency = 'USD';
  String _toCurrency = 'PKR';

  // Dummy exchange rates (For UI testing)
  final Map<String, double> _rates = {
    'USD': 1.0,
    'PKR': 278.5,
    'EUR': 0.92,
    'SAR': 3.75,
  };

  void _convertCurrency() {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      // Invalid input handle karne ke liye
      return;
    }

    setState(() {
      // Base USD conversion logic
      double amountInUSD = amount / _rates[_fromCurrency]!;
      _result = amountInUSD * _rates[_toCurrency]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdowns row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // From Currency
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromCurrency,
                    decoration: const InputDecoration(labelText: 'From'),
                    items: _rates.keys.map((String curr) {
                      return DropdownMenuItem(value: curr, child: Text(curr));
                    }).toList(),
                    onChanged: (val) => setState(() => _fromCurrency = val!),
                  ),
                ),
                const SizedBox(width: 20),
                // To Currency
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toCurrency,
                    decoration: const InputDecoration(labelText: 'To'),
                    items: _rates.keys.map((String curr) {
                      return DropdownMenuItem(value: curr, child: Text(curr));
                    }).toList(),
                    onChanged: (val) => setState(() => _toCurrency = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Convert Button
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Convert', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 40),

            // Result Display
            Center(
              child: Text(
                _result == 0.0 ? '0.00' : '${_result.toStringAsFixed(2)} $_toCurrency',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
