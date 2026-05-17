import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/market.dart';

class CartService extends ChangeNotifier {
  Market? _selectedMarket;
  final Map<String, Product> _cartItems = {};
  String? _deliveryAddress;

  Market? get selectedMarket => _selectedMarket;
  Map<String, Product> get cartItems => _cartItems;
  String? get deliveryAddress => _deliveryAddress;
  
  int get totalItems => _cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _cartItems.values.fold(0, (sum, item) => sum + item.totalPrice);

  void selectMarket(Market market) {
    _selectedMarket = market;
    _cartItems.clear(); // Очищаем корзину при смене рынка
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = Product(
        id: product.id,
        name: product.name,
        category: product.category,
        price: product.price,
        unit: product.unit,
        imageUrl: product.imageUrl,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity > 1) {
        _cartItems[productId]!.quantity--;
      } else {
        _cartItems.remove(productId);
      }
      notifyListeners();
    }
  }

  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}