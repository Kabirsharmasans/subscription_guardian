import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/database_service.dart';
import '../models/subscription.dart';
import '../models/category.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, double>> _spendingByCategoryFuture;
  late Future<Map<String, double>> _monthlySpendingFuture;
  final _brandColors = DatabaseService.getBrandColors();

  @override
  void initState() {
    super.initState();
    _spendingByCategoryFuture = _getSpendingByCategory();
    _monthlySpendingFuture = _getMonthlySpending();
  }

  Future<Map<String, double>> _getSpendingByCategory() async {
    final subscriptions = DatabaseService.getAllSubscriptions();
    final categories = DatabaseService.getAllCategories();
    final spendingByCategory = <String, double>{};

    for (final category in categories) {
      spendingByCategory[category.name] = 0;
    }

    for (final subscription in subscriptions) {
      final category = categories.firstWhere((c) => c.id == subscription.categoryId, orElse: () => Category(id: 'other', name: 'Other'));
      spendingByCategory[category.name] = (spendingByCategory[category.name] ?? 0) + subscription.monthlyCost;
    }

    return spendingByCategory;
  }

  Future<Map<String, double>> _getMonthlySpending() async {
    final subscriptions = DatabaseService.getAllSubscriptions();
    final monthlySpending = <String, double>{};

    for (final subscription in subscriptions) {
      final month = DateFormat('MMM yyyy').format(subscription.renewalDate);
      monthlySpending[month] = (monthlySpending[month] ?? 0) + subscription.monthlyCost;
    }

    return monthlySpending;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Spending by Category',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: FutureBuilder<Map<String, double>>(
              future: _spendingByCategoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data to display.'));
                }

                final spendingByCategory = snapshot.data!;
                final List<Color> colors = _brandColors.values.toList();

                return PieChart(
                  PieChartData(
                    sections: List.generate(spendingByCategory.length, (index) {
                      final entry = spendingByCategory.entries.elementAt(index);
                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: entry.value,
                        title: '${entry.key}\n${entry.value.toStringAsFixed(2)}',
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Monthly Spending',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: FutureBuilder<Map<String, double>>(
              future: _monthlySpendingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data to display.'));
                }

                final monthlySpending = snapshot.data!;

                return BarChart(
                  BarChartData(
                    barGroups: List.generate(monthlySpending.length, (index) {
                      final entry = monthlySpending.entries.elementAt(index);
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            width: 16,
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final month = monthlySpending.keys.elementAt(value.toInt());
                            return Text(month);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
