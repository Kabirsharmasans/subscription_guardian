import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subscription_guardian/models/subscription.dart';
import 'package:subscription_guardian/services/database_service.dart';

class DataService {
  // Export subscriptions to a CSV file
  static Future<String?> exportSubscriptions() async {
    final subscriptions = DatabaseService.getAllSubscriptions();
    if (subscriptions.isEmpty) {
      return 'No subscriptions to export.';
    }

    final List<List<dynamic>> rows = [];
    // Add header row
    rows.add([
      'ID',
      'Service Name',
      'Monthly Cost',
      'Renewal Date',
      'Created At',
      'Is Active',
      'Currency',
      'Category ID',
    ]);

    // Add subscription data
    for (final sub in subscriptions) {
      rows.add([
        sub.id,
        sub.serviceName,
        sub.monthlyCost,
        sub.renewalDate.toIso8601String(),
        sub.createdAt.toIso8601String(),
        sub.isActive,
        sub.currency,
        sub.categoryId ?? '',
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/subscription_guardian_backup.csv';
      final file = File(path);
      await file.writeAsString(csvData);
      return 'Exported to $path';
    } catch (e) {
      return 'Error exporting data: $e';
    }
  }

  // Import subscriptions from a CSV file
  static Future<String?> importSubscriptions() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        return 'No file selected.';
      }

      final file = File(result.files.single.path!);
      final csvData = await file.readAsString();
      final rows = const CsvToListConverter().convert(csvData);

      if (rows.length < 2) {
        return 'CSV file is empty or has no data.';
      }

      // Skip header row
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final subscription = Subscription(
          id: row[0].toString(),
          serviceName: row[1].toString(),
          monthlyCost: double.parse(row[2].toString()),
          renewalDate: DateTime.parse(row[3].toString()),
          createdAt: DateTime.parse(row[4].toString()),
          isActive: row[5].toString().toLowerCase() == 'true',
          currency: row[6].toString(),
          categoryId: row[7].toString().isEmpty ? null : row[7].toString(),
        );
        await DatabaseService.addSubscription(subscription);
      }
      return 'Successfully imported ${rows.length - 1} subscriptions.';
    } catch (e) {
      return 'Error importing data: $e';
    }
  }
}
