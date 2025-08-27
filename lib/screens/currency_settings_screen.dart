import 'package:flutter/material.dart';
import 'package:subscription_guardian/services/currency_service.dart';

class CurrencySettingsScreen extends StatefulWidget {
  const CurrencySettingsScreen({super.key});

  @override
  State<CurrencySettingsScreen> createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  String _primaryCurrency = 'USD';
  Map<String, double> _conversionRates = {};
  final List<String> _currencyOptions = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'INR',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _primaryCurrency = CurrencyService.getPrimaryCurrency();
      _conversionRates = CurrencyService.getConversionRates();
    });
  }

  void _setPrimaryCurrency(String? currency) {
    if (currency != null) {
      CurrencyService.setPrimaryCurrency(currency).then((_) {
        _loadSettings();
      });
    }
  }

  void _showRateDialog({String? currency, double? rate}) {
    final isEditing = currency != null;
    String selectedCurrency = currency ?? _currencyOptions.first;
    final rateController = TextEditingController(text: rate?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Rate' : 'Add Rate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                items: _currencyOptions
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: isEditing
                    ? null
                    : (value) {
                        if (value != null) {
                          selectedCurrency = value;
                        }
                      },
                decoration: const InputDecoration(labelText: 'Currency'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rateController,
                decoration: InputDecoration(
                  labelText: 'Conversion Rate to $_primaryCurrency',
                  hintText: 'e.g., 0.85',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newRate = double.tryParse(rateController.text);
                if (newRate != null) {
                  CurrencyService.setConversionRate(
                    selectedCurrency,
                    newRate,
                  ).then((_) {
                    _loadSettings();
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Settings')),
      body: ListView(
        children: [
          // Primary Currency Setting
          ListTile(
            title: const Text('Primary Currency'),
            subtitle: const Text('The main currency for totals'),
            trailing: DropdownButton<String>(
              value: _primaryCurrency,
              items: _currencyOptions
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: _setPrimaryCurrency,
            ),
          ),
          const Divider(),

          // Conversion Rates Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Conversion Rates',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ..._conversionRates.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(
                '1 ${entry.key} = ${entry.value} $_primaryCurrency',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showRateDialog(currency: entry.key, rate: entry.value),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      CurrencyService.removeConversionRate(
                        entry.key,
                      ).then((_) => _loadSettings());
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRateDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
