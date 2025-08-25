import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'add_subcription_dialog.dart';

// Enum to define the sorting options
enum SortBy { renewalDate, name, cost }

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Subscription> _subscriptions = [];
  List<Subscription> _filteredSubscriptions = [];
  Map<String, double> _totalMonthlyCostByCurrency = {};
  SortBy _currentSortBy = SortBy.renewalDate;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;

  late final Map<String, Color> _brandColors;

  @override
  void initState() {
    super.initState();
    _brandColors = DatabaseService.getBrandColors();
    _loadSubscriptions();
    _searchController.addListener(_applyFiltersAndSort);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSubscriptions() async {
    setState(() {
      _isLoading = true;
    });
    // Simulate a network delay or heavy computation
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _subscriptions = DatabaseService.getAllSubscriptions();
      _applyFiltersAndSort(); // Apply filters and sort after loading
      _totalMonthlyCostByCurrency = _calculateTotalCostByCurrency();
      _isLoading = false;
    });
  }

  void _applyFiltersAndSort() {
    List<Subscription> tempSubscriptions = List.from(_subscriptions);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      tempSubscriptions = tempSubscriptions.where((sub) {
        final query = _searchController.text.toLowerCase();
        return sub.serviceName.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategoryId != null) {
      tempSubscriptions = tempSubscriptions.where((sub) {
        return sub.categoryId == _selectedCategoryId;
      }).toList();
    }

    // Apply sorting
    switch (_currentSortBy) {
      case SortBy.renewalDate:
        tempSubscriptions.sort((a, b) => a.getDaysUntilRenewal().compareTo(b.getDaysUntilRenewal()));
        break;
      case SortBy.name:
        tempSubscriptions.sort((a, b) => a.serviceName.toLowerCase().compareTo(b.serviceName.toLowerCase()));
        break;
      case SortBy.cost:
        tempSubscriptions.sort((a, b) => b.monthlyCost.compareTo(a.monthlyCost));
        break;
    }

    setState(() {
      _filteredSubscriptions = tempSubscriptions;
    });
  }

  Map<String, double> _calculateTotalCostByCurrency() {
    final Map<String, double> totals = {};
    for (final sub in _subscriptions) {
      totals.update(sub.currency, (value) => value + sub.monthlyCost, ifAbsent: () => sub.monthlyCost);
    }
    return totals;
  }

  void _saveSubscription(Subscription subscription) {
    final isEditing = DatabaseService.getSubscription(subscription.id) != null;
    if (isEditing) {
      DatabaseService.updateSubscription(subscription).then((_) {
        NotificationService.scheduleRenewalReminder(subscription);
        _loadSubscriptions();
      });
    } else {
      DatabaseService.addSubscription(subscription).then((_) {
        NotificationService.scheduleRenewalReminder(subscription);
        _loadSubscriptions();
      });
    }
  }

  void _deleteSubscription(String id) {
    DatabaseService.deleteSubscription(id).then((_) {
      NotificationService.cancelNotification(id);
      _loadSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Guardian'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            onSelected: (SortBy result) {
              setState(() {
                _currentSortBy = result;
                _applyFiltersAndSort(); // Changed from _sortSubscriptions()
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.renewalDate,
                child: Text('Sort by Renewal Date'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.name,
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.cost,
                child: Text('Sort by Cost'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildTotalCostCard(),
          _buildFilterAndSearch(), // New widget
          const Divider(height: 1, indent: 16, endIndent: 16),
          Expanded(
            child: _filteredSubscriptions.isEmpty // Changed from _subscriptions
                ? _buildEmptyState()
                : _buildSubscriptionsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSubscriptionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterAndSearch() {
    final categories = DatabaseService.getAllCategories();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search subscriptions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _applyFiltersAndSort(),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            hint: const Text('Category'),
            value: _selectedCategoryId,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategoryId = newValue;
                _applyFiltersAndSort();
              });
            },
            items: [
              const DropdownMenuItem<String>(                value: null,
                child: Text('All'),
              ),
              ...categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  void _openSubscriptionDialog({Subscription? subscription}) {
    showDialog(
      context: context,
      builder: (context) => AddSubscriptionDialog(
        subscription: subscription,
        onSubscriptionAdded: _saveSubscription,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_task, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No subscriptions yet!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the "+" button to add your first one.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredSubscriptions.length, // Changed from _subscriptions
      itemBuilder: (context, index) {
        final subscription = _filteredSubscriptions[index]; // Changed from _subscriptions
        final daysUntilRenewal = subscription.getDaysUntilRenewal();
        final currencyFormat = NumberFormat.currency(
          symbol: _getCurrencySymbol(subscription.currency),
          decimalDigits: 2,
        );

        final logoPath = _getLogoPath(subscription.serviceName);
        final brandColor = _brandColors[subscription.serviceName.toLowerCase()];
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Dismissible(
            key: Key(subscription.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteSubscription(subscription.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${subscription.serviceName} deleted')),
              );
            },
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: brandColor ?? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: logoPath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(logoPath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if the image fails to load
                    return Icon(Icons.bookmark, color: brandColor != null ? Colors.white : Colors.grey);
                  }),
                )
                    : Icon(
                  Icons.bookmark,
                  color: brandColor != null ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              title: Text(subscription.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Renews in $daysUntilRenewal days on ${DateFormat.yMMMd().format(subscription.getNextRenewalDate())}'),
              trailing: Text(
                currencyFormat.format(subscription.monthlyCost),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: () => _openSubscriptionDialog(subscription: subscription),
            ),
          ),
        );
      },
    );
  }

  String? _getLogoPath(String serviceName) {
    // This function converts the service name into a filename-friendly format.
    final formattedName = serviceName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('+', 'plus')
        .replaceAll('.', '')
        .replaceAll('&', 'and')
        .replaceAll('/', ''); // Added to handle Vudu/Fandango
    return 'assets/logos/$formattedName.png';
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'JPY': return '¥';
      case 'CAD': return 'CA\$';
      case 'AUD': return 'A\$';
      case 'INR': return '₹';
      default: return '$currencyCode ';
    }
  }

  Widget _buildTotalCostCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Total Monthly Cost',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_totalMonthlyCostByCurrency.isEmpty)
            Text(
              '\$0.00',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          else
            Column(
              children: _totalMonthlyCostByCurrency.entries.map((entry) {
                final costText = '${_getCurrencySymbol(entry.key)} ${entry.value.toStringAsFixed(2)}';
                return Text(
                  costText,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 4),
          Text(
            '${_subscriptions.length} active subscriptions',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}