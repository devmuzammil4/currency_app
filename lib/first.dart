import 'package:currency_app/provider/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstApp extends StatefulWidget {
  const FirstApp({super.key});

  @override
  State<FirstApp> createState() => _FirstAppState();
}

class _FirstAppState extends State<FirstApp> {
  final TextEditingController amountController = TextEditingController();
  double result = 0.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CurrencyProvider>().loadExchangeRate();
      }
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _handleConversion(CurrencyProvider provider) {
    final String textInput = amountController.text.trim();

    if (textInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount first")),
      );
      return;
    }

    final double? inputAmount = double.tryParse(textInput);
    if (inputAmount != null) {
      setState(() {
        result = provider.convertUsdToPkr(inputAmount);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2.0),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Consumer architecture pattern targeting updates efficiently
              Consumer<CurrencyProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (provider.hasError) {
                    return Column(
                      children: [
                        Text(
                          provider.errorMessage ?? "An error occurred",
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => provider.loadExchangeRate(),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          result.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Current Rate: 1 USD = ${provider.exchangeRate.toStringAsFixed(2)} PKR",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 25),

              TextField(
                controller: amountController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Please enter amount in USD",
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.monetization_on),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => _handleConversion(context.read<CurrencyProvider>()),
                child: const Text(
                  "Convert",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
