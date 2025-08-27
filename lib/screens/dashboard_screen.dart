import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/subscription.dart';
import '../models/category.dart';
import '../services/database_service.dart';
import '../services/currency_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Subscription> _subscriptions = [];
  List<Category> _categories = [];
  Map<String, double> _spendingByCategory = {};
  String _primaryCurrency = 'USD';
  final Map<String, Color> _categoryColors = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _subscriptions = DatabaseService.getAllSubscriptions();
      _categories = DatabaseService.getAllCategories();
      _primaryCurrency = CurrencyService.getPrimaryCurrency();
      _spendingByCategory = _calculateSpendingByCategory();
    });
  }

  Map<String, double> _calculateSpendingByCategory() {
    final Map<String, double> spending = {};
    for (final category in _categories) {
      spending[category.id] = 0.0;
    }

    for (final subscription in _subscriptions) {
      final cost = CurrencyService.convert(
        subscription.monthlyCost,
        subscription.currency,
      );
      final categoryId = subscription.categoryId ?? 'other';
      spending.update(
        categoryId,
        (value) => value + cost,
        ifAbsent: () => cost,
      );
    }
    return spending;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _subscriptions.isEmpty
          ? const Center(child: Text('No subscription data to display.'))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSpendingChart(),
                const SizedBox(height: 24),
                _buildCategoryList(),
              ],
            ),
    );
  }

  Widget _buildSpendingChart() {
    final List<PieChartSectionData> sections =
        _spendingByCategory.entries.where((entry) => entry.value > 0).map((
      entry,
    ) {
      final category = _categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(id: entry.key, name: entry.key),
      );
      return PieChartSectionData(
        color: _getColorForCategory(category.id),
        value: entry.value,
        title:
            '${(_getCategoryPercentage(entry.value) * 100).toStringAsFixed(0)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    if (sections.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No spending to display',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Spending by Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Category Totals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ..._spendingByCategory.entries.where((entry) => entry.value > 0).map((
            entry,
          ) {
            final category = _categories.firstWhere(
              (c) => c.id == entry.key,
              orElse: () => Category(id: entry.key, name: entry.key),
            );
            return ListTile(
              leading: Icon(
                Icons.circle,
                color: _getColorForCategory(category.id),
              ),
              title: Text(category.name),
              trailing: Text(
                '${_primaryCurrency} ${entry.value.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
    );
  }

  double _getCategoryPercentage(double categoryValue) {
    final total = _spendingByCategory.values.isEmpty
        ? 0
        : _spendingByCategory.values.reduce((a, b) => a + b);
    return total == 0 ? 0 : categoryValue / total;
  }

  Color _getColorForCategory(String categoryId) {
    // Return cached color if already assigned
    if (_categoryColors.containsKey(categoryId)) {
      return _categoryColors[categoryId]!;
    }

    // Assign a consistent color based on category ID
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];

    final color = colors[categoryId.hashCode.abs() % colors.length];
    _categoryColors[categoryId] = color;
    return color;
  }
}
