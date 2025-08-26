import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../domain/repositories/subscription/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final InAppPurchase _inAppPurchase;
  final Dio _dio;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  SubscriptionRepositoryImpl({InAppPurchase? inAppPurchase, Dio? dio})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance,
        _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000/api'));

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  @override
  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      // Handle store not available
      print('The store is not available.');
    }
    // Listen to purchase updates
    _purchaseSubscription = purchaseStream.listen((purchaseDetailsList) {
      // Handle purchase updates here (e.g., validate with backend)
      _handlePurchaseUpdates(purchaseDetailsList);
    }, onDone: () {
      _purchaseSubscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending state if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          // Here you would typically validate the purchase with your backend
          // For this example, we assume the validation happens after the purchase flow is complete.
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  @override
  Future<List<ProductDetails>> getProducts(Set<String> productIds) async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      print('Failed to get products: ${response.error!.message}');
      return [];
    }
    return response.productDetails;
  }

  @override
  Future<bool> purchase(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    // This will trigger the native purchase UI
    // The result will be delivered via the purchaseStream
    return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<SubscriptionStatus> validateReceipt(String receiptData, String platform) async {
    try {
      final response = await _dio.post(
        '/iap/validate',
        data: {
          'receiptData': receiptData,
          'platform': platform,
          'userId': 'user123', // In a real app, get the actual user ID
        },
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return SubscriptionStatus(
          isSubscribed: response.data['subscriptionActive'],
          expiryDate: DateTime.tryParse(response.data['expiryDate'] ?? ''),
        );
      }
    } catch (e) {
      print('Receipt validation failed: $e');
    }
    return SubscriptionStatus(isSubscribed: false);
  }

  void dispose() {
    _purchaseSubscription.cancel();
  }
}
