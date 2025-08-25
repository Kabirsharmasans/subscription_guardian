import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class AddSubscriptionDialog extends StatefulWidget {
  final Subscription? subscription;
  final Function(Subscription) onSubscriptionAdded;

  const AddSubscriptionDialog({
    super.key,
    this.subscription,
    required this.onSubscriptionAdded,
  });

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _costController = TextEditingController();

  late DateTime _selectedDate;
  late String _selectedCurrency;
  String? _selectedCategoryId;
  final List<String> _currencyOptions = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'INR'];
  List<Category> _categories = [];

  // --- Data for Autocomplete ---
  late final Map<String, Color> _brandColors;
  late final List<String> _brandNames;

  bool get isEditing => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    _categories = DatabaseService.getAllCategories();
    _brandColors = DatabaseService.getBrandColors(); // Get brand data
    _brandNames = _brandColors.keys.toList();

    if (isEditing) {
      _serviceNameController.text = widget.subscription!.serviceName;
      _costController.text = widget.subscription!.monthlyCost.toString();
      _selectedDate = widget.subscription!.renewalDate;
      _selectedCurrency = widget.subscription!.currency;
      _selectedCategoryId = widget.subscription!.categoryId;
    } else {
      _selectedDate = DateTime.now();
      _selectedCurrency = 'USD';
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveSubscription() {
    if (_formKey.currentState?.validate() == true) {
      final subscription = Subscription(
        id: isEditing ? widget.subscription!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        serviceName: _serviceNameController.text.trim(),
        monthlyCost: double.parse(_costController.text),
        renewalDate: _selectedDate,
        createdAt: isEditing ? widget.subscription!.createdAt : DateTime.now(),
        currency: _selectedCurrency,
        categoryId: _selectedCategoryId,
      );

      widget.onSubscriptionAdded(subscription);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Subscription' : 'Add Subscription'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Autocomplete Service Name Field ---
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return _brandNames.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _serviceNameController.text = selection;
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                  // Sync our controller with the autocomplete's internal controller
                  if (_serviceNameController.text.isEmpty) {
                    _serviceNameController.value = fieldController.value;
                  }
                  return TextFormField(
                    controller: fieldController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Service Name',
                      hintText: 'e.g., Netflix, Spotify',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty == true) {
                        return 'Please enter a service name';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            final logoPath = DatabaseService.getLogoPath(option);
                            final brandColor = _brandColors[option.toLowerCase()];

                            return ListTile(
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: brandColor ?? Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: logoPath != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(logoPath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.bookmark, size: 18)),
                                )
                                    : const Icon(Icons.bookmark, size: 18),
                              ),
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Currency and Cost Fields
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency Dropdown
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                      items: _currencyOptions.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Monthly Cost Field
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Cost',
                        hintText: 'e.g., 15.99',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value?.trim().isEmpty == true) {
                          return 'Please enter the monthly cost';
                        }
                        final cost = double.tryParse(value!);
                        if (cost == null || cost <= 0) {
                          return 'Please enter a valid cost';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Renewal Date Picker
              TextFormField(
                controller: TextEditingController(
                  text: DateFormat.yMMMd().format(_selectedDate),
                ),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'First or Next Renewal Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveSubscription,
          child: Text(isEditing ? 'Save Changes' : 'Add Subscription'),
        ),
      ],
    );
  }
} 