import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Support'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Subscription Guardian',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Mission Section
            _buildSection(
              context,
              'Our Mission',
              Icons.favorite,
              'Subscription Guardian helps you take control of your recurring payments in a completely private and free way. We believe everyone deserves to know exactly what they\'re paying for each month.',
              Colors.red,
            ),

            const SizedBox(height: 24),

            // Privacy Section
            _buildSection(
              context,
              'Your Privacy Matters',
              Icons.lock,
              'Your subscription data never leaves your device. We don\'t collect, store, or transmit any personal information. No accounts, no tracking, no data mining - just you and your data, safely stored locally.',
              Colors.green,
            ),

            const SizedBox(height: 24),

            // Free Forever Section
            _buildSection(
              context,
              'Free Forever',
              Icons.money_off,
              'This app is completely free with no ads, no premium features, and no hidden costs. It was built by someone who believes financial tools should be accessible to everyone.',
              Colors.blue,
            ),

            const SizedBox(height: 32),

            // Support Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.volunteer_activism,
                    size: 40,
                    color: Colors.purple.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Support the Mission',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If Subscription Guardian has helped you save money or gain clarity about your subscriptions, consider supporting its development with a small donation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.purple.shade700),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _launchUrl(context, 'https://ko-fi.com/subscriptionguardian'),
                    icon: const Icon(Icons.coffee),
                    label: const Text('Buy Me a Coffee'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Donations help keep this app free and ad-free for everyone!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.purple.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Features Overview
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              context,
              Icons.add_circle_outline,
              'Track Subscriptions',
              'Add and manage all your recurring subscriptions in one place',
            ),

            _buildFeatureItem(
              context,
              Icons.calculate_outlined,
              'Cost Calculator',
              'See your total monthly spending at a glance',
            ),

            _buildFeatureItem(
              context,
              Icons.notifications_outlined,
              'Smart Reminders',
              'Get notified 3 days before renewals so you never get surprised',
            ),

            _buildFeatureItem(
              context,
              Icons.cancel_outlined,
              'Cancellation Guide',
              'Step-by-step instructions to cancel popular services',
            ),

            _buildFeatureItem(
              context,
              Icons.security_outlined,
              'Complete Privacy',
              'All data stays on your device - we never see it',
            ),

            const SizedBox(height: 32),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Questions or Feedback?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'d love to hear from you! Send us an email with any questions, suggestions, or just to say hello.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _launchUrl(context, 'mailto:hello@subscriptionguardian.app'),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('hello@subscriptionguardian.app'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            Center(
              child: Text(
                '© 2024 Subscription Guardian\nMade with ❤️ for your financial freedom',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, String content, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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