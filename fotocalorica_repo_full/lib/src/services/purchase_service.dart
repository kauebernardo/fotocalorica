import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool isAvailable = false;
  bool isLoading = false;
  List<ProductDetails> products = [];
  static const String _monthlyId = 'fotocalorica_monthly'; // defina esse ID nas stores

  PurchaseService() {
    _init();
  }

  Future<void> _init() async {
    final available = await _iap.isAvailable();
    isAvailable = available;
    if (!available) return;
    final response = await _iap.queryProductDetails({_monthlyId}.toSet());
    products = response.productDetails;
    _iap.purchaseStream.listen((purchases) {
      // tratar updates (compras / falhas) - aqui você deve validar recibos no servidor
    });
    notifyListeners();
  }

  Future<void> buyMonthly() async {
    if (!isAvailable) return;
    isLoading = true; notifyListeners();
    final product = products.firstWhere((p) => p.id == _monthlyId, orElse: () => throw 'Produto não encontrado');
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam); // em subscriptions use buySubscription se disponível
    isLoading = false; notifyListeners();
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
