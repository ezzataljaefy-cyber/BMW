import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../providers/subscription_providers.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(subscriptionProductsProvider);
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Premium'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Unlock all premium articles and features!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (subscriptionStatus.isSubscribed)
                _buildStatusCard(context, subscriptionStatus)
              else
                productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return const Text('No subscription products found.');
                    }
                    return Column(
                      children: products.map((product) {
                        return _buildProductCard(context, product, ref);
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error loading products: $err'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductDetails product, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.description),
        trailing: Text(product.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onTap: () {
          ref.read(subscriptionStatusProvider.notifier).purchase(product);
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, dynamic status) {
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(height: 10),
            const Text(
              'You are a Premium Member!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 5),
            if (status.expiryDate != null)
              Text(
                'Your subscription is valid until: ${status.expiryDate.toString().substring(0, 10)}',
                style: TextStyle(color: Colors.green.shade800),
              ),
          ],
        ),
      ),
    );
  }
}
