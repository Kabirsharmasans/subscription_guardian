import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CancellationService {
  final String name;
  final String logoEmoji;
  final String description;
  final List<String> steps;
  final String? cancelUrl;
  final String? helpUrl;

  const CancellationService({
    required this.name,
    required this.logoEmoji,
    required this.description,
    required this.steps,
    this.cancelUrl,
    this.helpUrl,
  });
}

class CancellationGuideScreen extends StatelessWidget {
  const CancellationGuideScreen({super.key});

  final List<CancellationService> _services = const [
    CancellationService(
      name: '10 Play',
      logoEmoji: '▶️',
      description: '10 Play is a free service. You can deactivate your account to stop using it.',
      steps: [
        'Go to the 10 Play website and log in.',
        'Click on your name/email and go to "My TV".',
        'Navigate to the "Account" settings.',
        'Scroll down and click "Deactivate my account".',
      ],
      cancelUrl: 'https://10play.com.au/account',
    ),
    CancellationService(
      name: '7plus',
      logoEmoji: '▶️',
      description: '7plus is a free service. You can close your account to stop using it.',
      steps: [
        'Go to the 7plus website and log in.',
        'Navigate to the "Manage Account" page.',
        'Select the "Close Account" option.',
        'Confirm that you wish to close the account.',
      ],
      cancelUrl: 'https://7plus.com.au/account',
    ),
    CancellationService(
      name: '9now',
      logoEmoji: '▶️',
      description: '9now is a free service. You can deactivate your account to stop using it.',
      steps: [
        'Log in to your 9Now account.',
        'Click on your username and select "My Profile".',
        'At the bottom of the page, click on "Deactivate".',
        'Confirm by clicking "Deactivate my account".',
      ],
      cancelUrl: 'https://www.9now.com.au/my-profile',
    ),
    CancellationService(
      name: 'ABC iview',
      logoEmoji: '▶️',
      description: 'ABC iview is a free service. You can delete your ABC Account to stop using it.',
      steps: [
        'Go to the ABC Account settings page.',
        'Log in to your account.',
        'Find the option to delete your account.',
      ],
      cancelUrl: 'https://www.abc.net.au/myaccount',
    ),
    CancellationService(
      name: 'Acorn TV',
      logoEmoji: '📺',
      description: 'Cancel your Acorn TV subscription based on how you signed up.',
      steps: [
        'Website: Go to Acorn TV website > My Acorn TV > Manage Account > Cancel Membership.',
        'Amazon Prime: Go to Amazon account > Memberships & Subscriptions > Manage Subscription > Cancel Channel.',
        'Roku: Log in to Roku account > Manage Subscriptions > Cancel.',
        'Apple: Settings app > Your Name > Subscriptions > Acorn TV > Cancel Subscription.',
        'Google Play: Google Play Store app > Menu > Subscriptions > Acorn TV > Cancel Subscription.',
      ],
      helpUrl: 'https://support.acorn.tv/en/support/solutions/articles/101000424418-how-do-i-cancel-my-subscription-',
    ),
    CancellationService(
      name: 'Netflix',
      logoEmoji: '🎬',
      description: 'Cancel your Netflix subscription anytime online.',
      cancelUrl: 'https://www.netflix.com/YourAccount',
      steps: [
        'Sign in to your Netflix account',
        'Go to Account > Membership & Billing',
        'Click "Cancel Membership"',
        'Confirm cancellation',
        'You can still watch until your billing period ends'
      ],
    ),
    CancellationService(
      name: 'Spotify',
      logoEmoji: '🎵',
      description: 'Cancel Spotify Premium to return to the free tier.',
      cancelUrl: 'https://www.spotify.com/account/subscription/',
      steps: [
        'Log in to your Spotify account',
        'Go to Account Overview',
        'Click "Change or cancel your subscription"',
        'Click "Cancel Premium"',
        'Follow the prompts to confirm'
      ],
    ),
    CancellationService(
      name: 'Amazon Prime',
      logoEmoji: '📦',
      description: 'Cancel Amazon Prime membership and get a refund if unused.',
      cancelUrl: 'https://www.amazon.com/mc/yourprimemembership',
      steps: [
        'Go to Amazon Prime membership page',
        'Click "End membership"',
        'Choose whether to end now or at renewal',
        'Confirm cancellation',
        'You may be eligible for a refund if you haven\'t used benefits'
      ],
    ),
    CancellationService(
      name: 'Disney+',
      logoEmoji: '🏰',
      description: 'Cancel Disney+ subscription through your account settings.',
      cancelUrl: 'https://www.disneyplus.com/account/subscription',
      steps: [
        'Sign in to your Disney+ account',
        'Go to Account > Subscription',
        'Click "Cancel Subscription"',
        'Confirm your cancellation',
        'Access continues until the end of your billing period'
      ],
    ),
    CancellationService(
      name: 'Apple iCloud+',
      logoEmoji: '☁️',
      description: 'Downgrade iCloud+ storage plan or cancel subscription.',
      steps: [
        'iPhone/iPad: Settings > [Your Name] > iCloud > Manage Storage > Change Storage Plan',
        'Mac: Apple menu > System Settings > [Your Name] > iCloud > Manage',
        'Web: Sign in to iCloud.com > Account Settings > Manage',
        'Select a different plan or downgrade to free 5GB',
        'Confirm the change'
      ],
    ),
    CancellationService(
      name: 'YouTube Premium',
      logoEmoji: '▶️',
      description: 'Cancel YouTube Premium to return to ad-supported YouTube.',
      cancelUrl: 'https://www.youtube.com/paid_memberships',
      steps: [
        'Sign in to YouTube',
        'Go to youtube.com/paid_memberships',
        'Find YouTube Premium and click "Manage"',
        'Click "Cancel membership"',
        'Follow prompts to confirm cancellation'
      ],
    ),
    CancellationService(
      name: 'Hulu',
      logoEmoji: '📺',
      description: 'Cancel Hulu subscription from your account page.',
      cancelUrl: 'https://secure.hulu.com/account',
      steps: [
        'Log in to your Hulu account',
        'Go to Account page',
        'Click "Cancel" in the Your Subscription section',
        'Follow the prompts to confirm',
        'You can reactivate anytime before your next billing date'
      ],
    ),
    CancellationService(
      name: 'Max',
      logoEmoji: '📺',
      description: 'Cancel your Max (formerly HBO Max) subscription.',
      steps: [
        'Website: Go to max.com/subscription > Cancel Your Subscription.',
        'Amazon: Go to amazon.com/appstoresubscriptions > Find Max > Turn off auto-renewal.',
        'Apple: Settings app > Your Name > Subscriptions > Max > Cancel Subscription.',
        'Google Play: Google Play Store app > Menu > Subscriptions > Max > Cancel Subscription.',
        'Roku: my.roku.com/subscriptions > Find Max > Turn off auto-renew.',
      ],
      helpUrl: 'https://help.max.com/US-en/Answer/Detail/000001127',
    ),
    CancellationService(
      name: 'Peacock',
      logoEmoji: '🦚',
      description: 'Cancel your Peacock subscription.',
      steps: [
        'Website: Go to PeacockTV.com > Account > Plans & Payment > Change or Cancel Plan.',
        'Apple: App Store > Subscriptions > Peacock > Cancel Subscription.',
        'Google Play: Google Play Store app > Subscriptions > Peacock > Cancel subscription.',
        'Roku: Highlight Peacock app > Press * > Manage subscription > Cancel subscription.',
        'Amazon: amazon.com/appstoresubscriptions > Find Peacock > Manage Subscription.',
      ],
      helpUrl: 'https://www.peacocktv.com/help/article/cancellation',
    ),
    CancellationService(
      name: 'Sling TV',
      logoEmoji: '📺',
      description: 'Cancel your Sling TV subscription online.',
      steps: [
        'Go to Sling.com and log in.',
        'Go to "My Account".',
        'Click on "Cancel Subscription".',
        'Follow the prompts to confirm.',
      ],
      cancelUrl: 'https://www.sling.com/my-account',
    ),
    CancellationService(
      name: 'Crunchyroll',
      logoEmoji: '🍥',
      description: 'Cancel your Crunchyroll subscription.',
      steps: [
        'Website: Go to Crunchyroll website > My Account > Membership Plan > Cancel Membership.',
        'Apple: Settings app > Your Name > Subscriptions > Crunchyroll > Cancel Subscription.',
        'Google Play: Google Play Store app > Subscriptions > Crunchyroll > Cancel subscription.',
        'Roku: my.roku.com/subscriptions > Find Crunchyroll > Turn off auto-renew.',
        'PayPal: Log in to PayPal > Settings > Payments > Manage automatic payments > Ellation Holdings Inc. > Cancel.',
      ],
      helpUrl: 'https://help.crunchyroll.com/hc/en-us/articles/17931135995924-How-do-I-cancel-my-membership',
    ),
    CancellationService(
      name: 'BBC iPlayer',
      logoEmoji: '🇬🇧',
      description: 'BBC iPlayer is a free service. You can delete your BBC account to stop using it.',
      steps: [
        'Go to the BBC website and sign in.',
        'Go to "Account settings".',
        'Click on "Delete my account".',
        'Enter your password to confirm.',
      ],
      cancelUrl: 'https://www.bbc.co.uk/account',
    ),
    CancellationService(
      name: 'Crave',
      logoEmoji: '🇨🇦',
      description: 'Cancel your Crave subscription.',
      steps: [
        'Website: Go to crave.ca > Manage Account > Subscriptions > Cancel Subscription.',
        'TV/Cable/Mobility Provider: Contact your provider directly.',
        'Apple: Settings app > Your Name > Subscriptions > Crave > Cancel Subscription.',
        'Google Play: Google Play Store app > Subscriptions > Crave > Cancel subscription.',
        'Roku: my.roku.com/subscriptions > Find Crave > Turn off auto-renew.',
      ],
      helpUrl: 'https://www.crave.ca/en/support/cancellation-and-refunds-72924699',
    ),
    CancellationService(
      name: 'Stan',
      logoEmoji: '🇦🇺',
      description: 'Cancel your Stan subscription.',
      steps: [
        'Website: Go to stan.com.au > Manage Account > Cancel your subscription.',
        'Apple: Settings app > Your Name > Subscriptions > Stan > Cancel Subscription.',
        'Google Play: Google Play Store app > Subscriptions > Stan > Cancel subscription.',
      ],
      helpUrl: 'https://help.stan.com.au/hc/en-us/articles/202751450-How-do-I-cancel-my-subscription',
    ),
    CancellationService(
      name: 'Adobe Creative Cloud',
      logoEmoji: '🎨',
      description: 'Cancel Adobe subscription through your Adobe account.',
      cancelUrl: 'https://account.adobe.com/plans',
      steps: [
        'Sign in to your Adobe account',
        'Go to Plans & Products',
        'Find your subscription and click "Manage plan"',
        'Click "Cancel plan"',
        'Note: Early cancellation may incur fees depending on your plan'
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freedom Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cancel,
                  size: 40,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cancellation Guide',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step-by-step instructions to cancel popular subscriptions. Take back control of your finances!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Services List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return _buildServiceCard(context, service);
              },
            ),
          ),

          // Disclaimer
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Disclaimer: Cancellation processes may change. Always verify current steps on the official websites.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, CancellationService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Text(
          service.logoEmoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(service.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Steps to Cancel:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...service.steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(entry.value),
                        ),
                      ],
                    ),
                  );
                }),
                if (service.cancelUrl != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _launchUrl(context, service.cancelUrl!),
                      icon: const Icon(Icons.open_in_new),
                      label: Text('Go to ${service.name} Cancellation'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch $url'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    }
  }
}