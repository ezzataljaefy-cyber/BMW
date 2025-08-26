import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionStatus {
  final bool isSubscribed;
  final DateTime? expiryDate;

  SubscriptionStatus({required this.isSubscribed, this.expiryDate});
}

abstract class SubscriptionRepository {
  Future<List<ProductDetails>> getProducts(Set<String> productIds);

  Future<bool> purchase(ProductDetails productDetails);

  Future<SubscriptionStatus> validateReceipt(String receiptData, String platform);

  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<void> initialize();
}
