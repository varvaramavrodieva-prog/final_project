import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart'; 
import 'menu_catalog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CartState _cartState = const CartState(cartItems: {});
  Market? _selectedMarket;

  void _selectMarket(Market market) {
    setState(() {
      _selectedMarket = market;
      _cartState = CartState(selectedMarket: market, cartItems: const {});
    });
  }

  void _addToCart(Product product) {
    final items = Map<String, Product>.from(_cartState.cartItems);
    if (items.containsKey(product.id)) {
      final existing = items[product.id]!;
      items[product.id] = Product(
        id: existing.id,
        name: existing.name,
        category: existing.category,
        price: existing.price,
        unit: existing.unit,
        imageUrl: existing.imageUrl,
        quantity: existing.quantity + 1,
      );
    } else {
      items[product.id] = Product(
        id: product.id,
        name: product.name,
        category: product.category,
        price: product.price,
        unit: product.unit,
        imageUrl: product.imageUrl,
        quantity: 1,
      );
    }
    setState(() {
      _cartState = _cartState.copyWith(cartItems: items);
    });
  }

  void _removeFromCart(String productId) {
    final items = Map<String, Product>.from(_cartState.cartItems);
    if (items.containsKey(productId)) {
      if (items[productId]!.quantity > 1) {
        final existing = items[productId]!;
        items[productId] = Product(
          id: existing.id,
          name: existing.name,
          category: existing.category,
          price: existing.price,
          unit: existing.unit,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity - 1,
        );
      } else {
        items.remove(productId);
      }
    }
    setState(() {
      _cartState = _cartState.copyWith(cartItems: items);
    });
  }

  void _clearCart() {
    setState(() {
      _cartState = _cartState.copyWith(cartItems: const {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CartInherited(
      state: _cartState.copyWith(selectedMarket: _selectedMarket),
      selectMarket: _selectMarket,
      addToCart: _addToCart,
      removeFromCart: _removeFromCart,
      clearCart: _clearCart,
      child: MaterialApp(
        title: 'Market App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/markets',
        routes: {
          '/markets': (context) => const MarketSelectionScreen(),
          '/catalog': (context) => const CatalogScreen(),
          '/cart': (context) => const CartScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedIndex = 2;

  bool isDelivery = true;
  TextEditingController streetController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController aptController = TextEditingController();

  List<CartItem> get cartItems {
    final cart = CartInherited.of(context);
    return cart.state.cartItems.values.map((product) {
      return CartItem(
        name: product.name,
        weight: product.unit,
        price: product.price.toInt(),
        quantity: product.quantity,
        imageUrl: product.imageUrl,
      );
    }).toList();
  }

  bool get isCartEmpty => cartItems.isEmpty;

  int get totalPrice {
    final cart = CartInherited.of(context);
    int sum = cart.state.totalPrice.toInt();
    if (isDelivery) sum += 150;
    return sum;
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Очистить корзину?"),
          content: const Text("Вы точно готовы удалить все товары?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                final cart = CartInherited.of(context);
                cart.clearCart();
                Navigator.of(context).pop();
              },
              child: const Text("Подтвердить", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 20),
                const Text(
                  "Заказ успешно оформлен",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D4A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/profile');
                    },
                    child: const Text(
                      "Перейти в профиль",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/markets');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/catalog');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D4A);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/catalog');
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Корзина", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text("Даниловский рынок", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: isCartEmpty ? null : _clearCart,
          ),
        ],
      ),
      body: isCartEmpty ? _buildEmptyCart(primaryGreen) : _buildActiveCart(primaryGreen),
      bottomNavigationBar: _buildBottomNav(primaryGreen),
    );
  }

  Widget _buildBottomNav(Color activeColor) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Рынки', 0, activeColor),
          _buildNavItem(Icons.dashboard_outlined, 'Каталог', 1, activeColor),
          _buildNavItem(Icons.shopping_cart_outlined, 'Корзина', 2, activeColor),
          _buildNavItem(Icons.person, 'Профиль', 3, activeColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Color activeColor) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onBottomNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? activeColor : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? activeColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Корзина кажется пуста...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          const Text(
            "Добавьте товары из каталога",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/catalog');
            },
            child: const Text("Перейти в каталог", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCart(Color primaryColor) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(cartItems[index], primaryColor);
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: -5)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    _buildDeliveryButton("Курьером", true, primaryColor),
                    _buildDeliveryButton("Самовывоз", false, primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (isDelivery) _buildAddressInputs(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Итого", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Доставка: ${isDelivery ? '150 ₽' : 'Бесплатно'}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                  Text("${totalPrice} ₽", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _placeOrder,
                  child: const Text("Оформить заказ", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryButton(String text, bool isActive, Color primaryColor) {
    bool isSelected = (isDelivery && isActive) || (!isDelivery && !isActive);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isDelivery = isActive),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressInputs() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: "Улица", border: OutlineInputBorder(), isDense: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: houseController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: "Дом", border: OutlineInputBorder(), isDense: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: aptController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: "Квартира", border: OutlineInputBorder(), isDense: true),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 80, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.weight, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                Text("${item.price} ₽", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                  onPressed: () {
                    
                  },
                ),
                Text("${item.quantity}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  onPressed: () {
                  
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final String weight;
  final int price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}