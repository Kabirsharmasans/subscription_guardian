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
  Map<String, double> _totalMonthlyCostByCurrency = {};
  SortBy _currentSortBy = Sort.renewalDate; // Default sort

  // --- BRANDBOOK: A comprehensive map of brand colors ---
  final Map<String, Color> _brandColors = {
    // Global / Cross-Region
    'netflix': const Color(0xFFE50914),
    'amazon prime video': const Color(0xFF00A8E1),
    'disney+': const Color(0xFF1139AB),
    'apple tv+': const Color(0xFF000000),
    'max': const Color(0xFF6633FF),
    'hulu': const Color(0xFF1CE783),
    'paramount+': const Color(0xFF0064FF),
    'peacock': const Color(0xFF000000),
    'youtube premium': const Color(0xFFFF0000),
    'youtube tv': const Color(0xFFFF0000),
    'sling tv': const Color(0xFFF26B3A),
    'fubo': const Color(0xFFF7941D),
    'philo': const Color(0xFFDA002A),
    'directv stream': const Color(0xFF00A6D6),
    'espn+': const Color(0xFFCD0001),
    'starz': const Color(0xFFD92128),
    'mgm+': const Color(0xFFB7A667),
    'amc+': const Color(0xFFD81E28),
    'shudder': const Color(0xFFE53935),
    'curiosity stream': const Color(0xFFF26522),
    'discovery+': const Color(0xFF0A1F3C),
    'britbox': const Color(0xFF002244),
    'acorn tv': const Color(0xFF7A9A01),
    'the criterion channel': const Color(0xFF000000),
    'mubi': const Color(0xFF244A9A),
    'kanopy': const Color(0xFFD50032),
    'hoopla': const Color(0xFF4A90E2),
    'plex': const Color(0xFFE5A00D),
    'pluto tv': const Color(0xFFF9D423),
    'tubi': const Color(0xFFE21A23),
    'freevee': const Color(0xFF14B4A5),
    'vudu/fandango at home': const Color(0xFF333333),
    'crunchyroll': const Color(0xFFF47521),
    'hidive': const Color(0xFF00AEEF),
    'wwe network': const Color(0xFF000000),
    'dazn': const Color(0xFFF8F8F8),
    'ufc fight pass': const Color(0xFFD20A0A),
    'nba league pass': const Color(0xFF002B5C),
    'nfl+': const Color(0xFF013369),
    'f1 tv': const Color(0xFFE10600),

    // United States & Canada
    'crave': const Color(0xFF00ADC6),
    'cbc gem': const Color(0xFF000000),
    'club illico': const Color(0xFF0033A0),
    'ici tou.tv': const Color(0xFFE3001B),
    'citytv+': const Color(0xFFED1C24),
    'stacktv': const Color(0xFF231F20),
    'sportsnet now': const Color(0xFF004C97),
    'tsn+': const Color(0xFFC41230),
    'paramount+ with showtime': const Color(0xFF0064FF),
    'hallmark movies now': const Color(0xFFC71585),
    'pbs passport': const Color(0xFF0078C1),

    // United Kingdom & Ireland
    'now': const Color(0xFF32D1A3),
    'itvx': const Color(0xFF333333),
    'bbc iplayer': const Color(0xFFF54997),
    'channel 4': const Color(0xFF000000),
    'my5': const Color(0xFFEC1C24),
    'stv player': const Color(0xFF005EB8),
    'discovery+ uk': const Color(0xFF0A1F3C),
    'britbox uk': const Color(0xFF002244),
    'rté player': const Color(0xFF00A550),
    'virgin media player': const Color(0xFFED1A3D),

    // Nordics
    'viaplay': const Color(0xFFFF0077),
    'tv 2 play': const Color(0xFFE4002B),
    'tv4 play': const Color(0xFF0067A9),
    'dr tv': const Color(0xFFE5001C),
    'nrk tv': const Color(0xFF00A9E0),
    'svt play': const Color(0xFF39B54A),
    'yle areena': const Color(0xFF0072C6),
    'ruutu': const Color(0xFF00AEEF),
    'telia play': const Color(0xFF662D91),

    // DACH (Germany/Austria/Switzerland)
    'joyn': const Color(0xFFFF005A),
    'rtl+': const Color(0xFFE6001A),
    'zattoo': const Color(0xFFF16623),
    'waipu.tv': const Color(0xFF00AEEF),
    'magentatv': const Color(0xFFE20074),
    'ard mediathek': const Color(0xFF003366),
    'zdfmediathek': const Color(0xFFF37A1F),
    'srf play': const Color(0xFFED1C24),
    'orf tvthek': const Color(0xFFDA291C),
    'sky show': const Color(0xFF0072C8),

    // France & Monaco
    'mycanal': const Color(0xFF000000),
    'molotov': const Color(0xFFF0134D),
    'france.tv': const Color(0xFF000091),
    'arte.tv': const Color(0xFF282828),
    'ocs': const Color(0xFFFF7A00),

    // Iberia (Spain/Portugal)
    'movistar plus+': const Color(0xFF00A9E0),
    'atresplayer': const Color(0xFFFF7300),
    'mitele': const Color(0xFF0072CE),
    'rtve play': const Color(0xFFC8102E),
    'filmin': const Color(0xFF00A651),
    'flixolé': const Color(0xFFE50914),
    'rtp play': const Color(0xFF00A54F),
    'tvi play': const Color(0xFF0055A4),
    'opto sic': const Color(0xFFED1C24),

    // Italy
    'mediaset infinity': const Color(0xFF005CA9),
    'raiplay': const Color(0xFF0067A8),
    'timvision': const Color(0xFFDA291C),
    'now (it)': const Color(0xFF32D1A3),
    'chili': const Color(0xFFE50914),
    'discovery+ italy': const Color(0xFF0A1F3C),

    // Benelux
    'videoland': const Color(0xFFF37321),
    'nlziet': const Color(0xFF29ABE2),
    'npo start/plus': const Color(0xFF0077C8),
    'kijk': const Color(0xFFF37321),
    'pathé thuis': const Color(0xFFE50914),
    'streamz': const Color(0xFFFF005A),
    'vrt max': const Color(0xFF000000),
    'rtbf auvio': const Color(0xFFF15A22),

    // Central & Eastern Europe
    'player.pl': const Color(0xFF1E3DE0),
    'canal+ online': const Color(0xFF000000),
    'tvp vod': const Color(0xFFC8102E),
    'polsat box go': const Color(0xFF00A9E0),
    'voyo': const Color(0xFF00AEEF),
    'iprima': const Color(0xFF00AEEF),
    'stream.cz': const Color(0xFFE50914),
    'joj play': const Color(0xFFE6001A),
    'antenaplay': const Color(0xFF00AEEF),
    'digi online': const Color(0xFF00AEEF),

    // Turkey
    'blutv': const Color(0xFF00AEEF),
    'exxen': const Color(0xFFF50057),
    'puhutv': const Color(0xFF1D1D1D),
    'gain': const Color(0xFF00FFC2),
    'bein connect tr': const Color(0xFF7A007A),

    // Russia & CIS
    'ivi': const Color(0xFFE50914),
    'okko': const Color(0xFFE50914),
    'kinopoisk': const Color(0xFFFF6600),
    'more.tv': const Color(0xFF00AEEF),
    'start': const Color(0xFFF50057),
    'premier': const Color(0xFF000000),
    'megogo': const Color(0xFF00AEEF),

    // MENA
    'shahid': const Color(0xFF00AEEF),
    'osn+': const Color(0xFF00AEEF),
    'starzplay arabia': const Color(0xFFD92128),
    'tod': const Color(0xFF7A007A),
    'jawwy tv': const Color(0xFF00AEEF),
    'weyyak': const Color(0xFF00AEEF),
    'watch it!': const Color(0xFF00AEEF),
    'adtv': const Color(0xFF00AEEF),

    // Sub-Saharan Africa
    'showmax': const Color(0xFFE50914),
    'dstv stream': const Color(0xFF0033A0),
    'gotv stream': const Color(0xFF00AEEF),
    'irokotv': const Color(0xFF00AEEF),
    'wi-flix': const Color(0xFF00AEEF),
    'evod': const Color(0xFF00AEEF),

    // South Asia (India etc.)
    'disney+ hotstar': const Color(0xFF1F80E0),
    'jiocinema': const Color(0xFFF37A1F),
    'sonyliv': const Color(0xFF00AEEF),
    'zee5': const Color(0xFF820082),
    'aha': const Color(0xFFFF6600),
    'sun nxt': const Color(0xFFF37A1F),
    'eros now': const Color(0xFFE50914),
    'mx player': const Color(0xFF00AEEF),
    'hoichoi': const Color(0xFFF37A1F),
    'altt': const Color(0xFF00AEEF),
    'shemaroome': const Color(0xFF00AEEF),
    'discovery+ (in)': const Color(0xFF0A1F3C),
    'tvfplay': const Color(0xFF00AEEF),
    'manoramamax': const Color(0xFF00AEEF),
    'nammaflix': const Color(0xFF00AEEF),
    'planet marathi': const Color(0xFF00AEEF),
    'chaupal': const Color(0xFF00AEEF),
    'stage': const Color(0xFF00AEEF),
    'koode': const Color(0xFF00AEEF),
    'epic on': const Color(0xFF00AEEF),
    'ullu': const Color(0xFF00AEEF),
    'kooku': const Color(0xFF00AEEF),
    'hungama play': const Color(0xFF00AEEF),
    'docubay': const Color(0xFF00AEEF),
    'arré': const Color(0xFF00AEEF),
    'bioscope': const Color(0xFF00AEEF),
    'bongo': const Color(0xFF00AEEF),
    'tamasha': const Color(0xFF00AEEF),
    'tapmad tv': const Color(0xFF00AEEF),
    'ary zap': const Color(0xFF00AEEF),
    'ptvflix': const Color(0xFF00AEEF),
    'nettv nepal': const Color(0xFF00AEEF),

    // East Asia
    'u-next': const Color(0xFF00AEEF),
    'lemino': const Color(0xFF00AEEF),
    'hulu japan': const Color(0xFF1CE783),
    'abema': const Color(0xFF00AEEF),
    'd anime store': const Color(0xFF00AEEF),
    'dmm tv': const Color(0xFF00AEEF),
    'wowow on demand': const Color(0xFF00AEEF),
    'wavve': const Color(0xFF00AEEF),
    'tving': const Color(0xFFE50914),
    'coupang play': const Color(0xFF00AEEF),
    'watcha': const Color(0xFF00AEEF),
    'iqiyi': const Color(0xFF00AEEF),
    'tencent video': const Color(0xFF00AEEF),
    'wetv': const Color(0xFF00AEEF),
    'youku': const Color(0xFF00AEEF),
    'mango tv': const Color(0xFFFF6600),
    'bilibili': const Color(0xFF00AEEF),
    'sohu tv': const Color(0xFF00AEEF),
    'pptv': const Color(0xFF00AEEF),
    'myvideo': const Color(0xFF00AEEF),
    'friday video': const Color(0xFF00AEEF),
    'hami video': const Color(0xFF00AEEF),
    'kktv': const Color(0xFF00AEEF),
    'viu': const Color(0xFF00AEEF),
    'now e': const Color(0xFF00AEEF),

    // Southeast Asia
    'mewatch': const Color(0xFF00AEEF),
    'starhub tv+': const Color(0xFF00AEEF),
    'singtel cast': const Color(0xFF00AEEF),
    'trueid': const Color(0xFF00AEEF),
    'monomax': const Color(0xFF00AEEF),
    'vidio': const Color(0xFF00AEEF),
    'mola': const Color(0xFF00AEEF),
    'goplay': const Color(0xFF00AEEF),
    'klikfilm': const Color(0xFF00AEEF),
    'rcti+': const Color(0xFF00AEEF),
    'tonton': const Color(0xFF00AEEF),
    'sooka': const Color(0xFF00AEEF),
    'astro go': const Color(0xFF00AEEF),
    'iwanttfc': const Color(0xFF00AEEF),
    'vivamax': const Color(0xFF00AEEF),
    'fpt play': const Color(0xFF00AEEF),
    'vieon': const Color(0xFF00AEEF),
    'galaxy play': const Color(0xFF00AEEF),

    // Oceania
    'stan': const Color(0xFF00A9E0),
    'binge': const Color(0xFFF20080),
    'kayo sports': const Color(0xFF00C3E6),
    'foxtel now': const Color(0xFF00AEEF),
    'abc iview': const Color(0xFF00AEEF),
    'sbs on demand': const Color(0xFF00AEEF),
    '7plus': const Color(0xFF00AEEF),
    '9now': const Color(0xFF00AEEF),
    '10 play': const Color(0xFF00AEEF),
    'neon': const Color(0xFF00AEEF),
    'sky sport now': const Color(0xFF00AEEF),
    'tvnz+': const Color(0xFF00AEEF),
    'threenow': const Color(0xFF00AEEF),

    // Latin America
    'vix': const Color(0xFF00AEEF),
    'blim tv': const Color(0xFF00AEEF),
    'claro video': const Color(0xFF00AEEF),
    'filminlatino': const Color(0xFF00AEEF),
    'globoplay': const Color(0xFF00AEEF),
    'telecine': const Color(0xFF00AEEF),
    'looke': const Color(0xFF00AEEF),
    'lionsgate+': const Color(0xFF00AEEF),
    'flow': const Color(0xFF00AEEF),
    'dgo': const Color(0xFF00AEEF),
    'movistar play': const Color(0xFF00AEEF),
    'vera tv': const Color(0xFF00AEEF),
    'zapping': const Color(0xFF00AEEF),
    'caracol play': const Color(0xFF00AEEF),
    'nuestra tele': const Color(0xFF00AEEF),
    'latina play': const Color(0xFF00AEEF),
    'ecuavisa play': const Color(0xFF00AEEF),
  };

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  void _loadSubscriptions() {
    setState(() {
      _subscriptions = DatabaseService.getAllSubscriptions();
      _sortSubscriptions();
      _totalMonthlyCostByCurrency = _calculateTotalCostByCurrency();
    });
  }

  void _sortSubscriptions() {
    switch (_currentSortBy) {
      case SortBy.renewalDate:
        _subscriptions.sort((a, b) => a.getDaysUntilRenewal().compareTo(b.getDaysUntilRenewal()));
        break;
      case SortBy.name:
        _subscriptions.sort((a, b) => a.serviceName.toLowerCase().compareTo(b.serviceName.toLowerCase()));
        break;
      case SortBy.cost:
        _subscriptions.sort((a, b) => b.monthlyCost.compareTo(a.monthlyCost));
        break;
    }
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
                _sortSubscriptions();
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
      body: Column(
        children: [
          _buildTotalCostCard(),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Expanded(
            child: _subscriptions.isEmpty
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
      itemCount: _subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = _subscriptions[index];
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
