import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../data/repositories/subscription/subscription_repository_impl.dart';
import '../../domain/repositories/subscription/subscription_repository.dart';

// Provider for the repository
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final repo = SubscriptionRepositoryImpl();
  repo.initialize(); // Initialize the purchase stream listener
  return repo;
});

// Provider for the list of subscription products
final subscriptionProductsProvider = FutureProvider<List<ProductDetails>>((ref) {
  const Set<String> productIds = {
    // These IDs must match the ones in your .env.example and store listings
    'monthly_subscription_android', // Placeholder ID
    'monthly_subscription_ios',     // Placeholder ID
  };
  return ref.watch(subscriptionRepositoryProvider).getProducts(productIds);
});

// Provider to manage the user's subscription status
final subscriptionStatusProvider = StateNotifierProvider<SubscriptionStatusNotifier, SubscriptionStatus>((ref) {
  return SubscriptionStatusNotifier(ref);
});

class SubscriptionStatusNotifier extends StateNotifier<SubscriptionStatus> {
  final Ref _ref;

  SubscriptionStatusNotifier(this._ref) : super(SubscriptionStatus(isSubscribed: false)) {
    _listenToPurchaseUpdates();
  }

  void _listenToPurchaseUpdates() {
    _ref.read(subscriptionRepositoryProvider).purchaseStream.listen((purchaseDetailsList) {
      for (final purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
          // A purchase was made or restored, now validate it.
          _validatePurchase(purchase);
        }
      }
    });
  }

  Future<void> _validatePurchase(PurchaseDetails purchase) async {
    final receipt = purchase.verificationData.serverVerificationData;
    final platform = Platform.isIOS ? 'ios' : 'android';

    final status = await _ref.read(subscriptionRepositoryProvider).validateReceipt(receipt, platform);
    state = status;

    if (purchase.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchase);
    }
  }

  // A method to manually check status if needed
  Future<void> checkSubscriptionStatus() async {
    // This would be more complex, involving checking a stored receipt
    // For now, we assume the stream handles everything.
    print("Manually checking subscription status (not implemented).");
  }

  Future<void> purchase(ProductDetails product) async {
    try {
      await _ref.read(subscriptionRepositoryProvider).purchase(product);
    } catch (e) {
      print("Purchase failed: $e");
    }
  }
}
