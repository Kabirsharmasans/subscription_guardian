import 'package:flutter/material.dart';
import 'package:subscription_guardian/screens/about_screen.dart';
import 'package:subscription_guardian/services/settings_service.dart';
import 'package:subscription_guardian/services/notification_service.dart';
import 'package:subscription_guardian/services/database_service.dart';
import 'package:subscription_guardian/models/category.dart';
import 'package:subscription_guardian/models/subscription.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:subscription_guardian/services/home_widget_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String)? onThemeChanged;
  const SettingsScreen({super.key, this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _SettingsScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('About the app and contact information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for upcoming renewals'),
            value: SettingsService.notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                SettingsService.notificationsEnabled = value;
                // Re-schedule notifications based on new setting
                if (value) {
                  // If enabling, schedule all notifications
                  // This will also handle the reminderDays setting
                  NotificationService.scheduleAllReminderNotifications();
                } else {
                  // If disabling, cancel all notifications
                  NotificationService.cancelAllNotifications();
                }
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_alarm_outlined),
            title: const Text('Reminder Days'),
            subtitle: const Text('Set when to receive renewal reminders'),
            onTap: () {
              _showReminderDaysDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: SettingsService.themeModeString,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    SettingsService.themeModeString = newValue;
                    widget.onThemeChanged?.call(newValue);
                  });
                }
              },
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'system',
                  child: Text('System Default'),
                ),
                DropdownMenuItem<String>(
                  value: 'light',
                  child: Text('Light'),
                ),
                DropdownMenuItem<String>(
                  value: 'dark',
                  child: Text('Dark'),
                ),
                DropdownMenuItem<String>(
                  value: 'amoled',
                  child: Text('AMOLED'),
                ),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.attach_money),
            title: const Text('Show Monthly Total'),
            subtitle:
                const Text('Display total monthly spending on home screen'),
            value: SettingsService.showMonthlyTotal,
            onChanged: (bool value) {
              setState(() {
                SettingsService.showMonthlyTotal = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets_outlined),
            title: const Text('Update Home Widget'),
            subtitle: const Text('Manually update the home widget'),
            onTap: () {
              HomeWidgetService.updateWidget();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home widget updated')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('Import Subscriptions'),
            subtitle: const Text('Import subscriptions from a CSV file'),
            onTap: _importSubscriptions,
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export Subscriptions'),
            subtitle: const Text('Export subscriptions to a CSV file'),
            onTap: _exportSubscriptions,
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Manage Categories'),
            subtitle:
                const Text('Add, edit, or delete subscription categories'),
            onTap: () {
              _showCategoryManagementDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all subscriptions and reset app'),
            onTap: () {
              _showClearDataDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Understand how your data is handled'),
            onTap: () {
              _showPrivacyDialog();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportSubscriptions() async {
    final subscriptions = DatabaseService.getAllSubscriptions();
    final List<List<dynamic>> rows = [];
    rows.add([
      'Service Name',
      'Monthly Cost',
      'Renewal Date',
      'Category ID'
    ]);
    for (final sub in subscriptions) {
      rows.add([
        sub.serviceName,
        sub.monthlyCost,
        sub.renewalDate.toIso8601String(),
        sub.categoryId
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);

    try {
      final String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Subscriptions CSV',
        fileName: 'subscriptions.csv',
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsString(csv);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscriptions exported successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting subscriptions: $e')),
      );
    }
  }

  Future<void> _importSubscriptions() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();
        final List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

        // Skip header row
        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          final subscription = Subscription(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            serviceName: row[0],
            monthlyCost: row[1],
            renewalDate: DateTime.parse(row[2]),
            categoryId: row[3],
            createdAt: DateTime.now(),
            currency: SettingsService.defaultCurrency,
          );
          await DatabaseService.addSubscription(subscription);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscriptions imported successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing subscriptions: $e')),
      );
    }
  }

  void _showCategoryManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Categories'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: _CategoryManagementWidget(
            onCategoriesChanged: () {
              // Refresh any parent widgets if needed
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your subscriptions and reset the app. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Clear all data
              final subscriptions = DatabaseService.getAllSubscriptions();
              for (final sub in subscriptions) {
                await DatabaseService.deleteSubscription(sub.id);
              }
              // Clear categories
              await DatabaseService.categoriesBox.clear();
              // Reset all settings
              await SettingsService.resetAllSettings();

              await NotificationService.scheduleAllReminderNotifications();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Subscription Guardian is committed to protecting your privacy:\n\n' 
            '• All your subscription data is stored locally on your device\n' 
            '• We never collect, transmit, or store any personal information\n' 
            '• No accounts are required to use this app\n' 
            '• No analytics or tracking are performed\n' 
            '• No internet connection is required for core functionality\n\n' 
            'Your financial data is completely private and under your control.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showReminderDaysDialog() {
    final List<String> allReminderOptions = [
      '12 hours',
      '1 day',
      '2 days',
      '3 days',
      '1 week',
    ];
    List<String> selectedOptions = List.from(SettingsService.reminderDaysList);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // Add StatefulBuilder here
        builder: (context, dialogSetState) => AlertDialog(
          title: const Text('Select Reminder Days'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: allReminderOptions.map((option) =>
                CheckboxListTile(
                  title: Text(option),
                  value: selectedOptions.contains(option),
                  onChanged: (bool? value) {
                    dialogSetState(() {
                      // Use dialogSetState instead of setState
                      if (value == true) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                  },
                )
              ).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  SettingsService.reminderDaysList = selectedOptions;
                  NotificationService.scheduleAllReminderNotifications();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryManagementWidget extends StatefulWidget {
  final VoidCallback onCategoriesChanged;
  const _CategoryManagementWidget({required this.onCategoriesChanged});

  @override
  State<_CategoryManagementWidget> createState() =>
      _CategoryManagementWidgetState();
}

class _CategoryManagementWidgetState extends State<_CategoryManagementWidget> {
  List<Category> _categories = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    setState(() {
      _categories = DatabaseService.getAllCategories();
    });
  }

  void _addCategory() {
    if (_nameController.text.trim().isNotEmpty) {
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
      );

      DatabaseService.categoriesBox.put(category.id, category);
      _nameController.clear();
      _loadCategories();
      widget.onCategoriesChanged();
    }
  }

  void _deleteCategory(Category category) {
    // Check if any subscriptions use this category
    final subscriptions = DatabaseService.getAllSubscriptions();
    final hasSubscriptions =
        subscriptions.any((sub) => sub.categoryId == category.id);

    if (hasSubscriptions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Cannot delete category: it is being used by subscriptions')),
      );
      return;
    }
    DatabaseService.categoriesBox.delete(category.id);
    _loadCategories();
    widget.onCategoriesChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add new category
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'New category name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addCategory(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Categories list
        Expanded(
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isDefault = [
                'entertainment',
                'work',
                'utilities',
                'music',
                'other'
              ].contains(category.id);

              return ListTile(
                title: Text(category.name),
                trailing: isDefault
                    ? const Icon(Icons.lock_outline, color: Colors.grey)
                    : IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteCategory(category),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}