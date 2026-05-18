import 'package:flutter/material.dart';
import 'dart:math';

class Market {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double distance;
  final String closingTime;
  final String imageUrl;
  final bool isOpen;

  Market({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.closingTime,
    required this.imageUrl,
    this.isOpen = true,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.quantity = 0,
  });

  double get totalPrice => price * quantity;
}

class CartState {
  final Market? selectedMarket;
  final Map<String, Product> cartItems;

  const CartState({
    this.selectedMarket,
    this.cartItems = const {},
  });

  int get totalItems =>
      cartItems.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({
    Market? selectedMarket,
    bool clearMarket = false,
    Map<String, Product>? cartItems,
  }) {
    return CartState(
      selectedMarket: clearMarket ? null : (selectedMarket ?? this.selectedMarket),
      cartItems: cartItems ?? this.cartItems,
    );
  }
}

class CartInherited extends InheritedWidget {
  final CartState state;
  final void Function(Market market) selectMarket;
  final void Function(Product product) addToCart;
  final void Function(String productId) removeFromCart;
  final void Function() clearCart;

  const CartInherited({
    super.key,
    required this.state,
    required this.selectMarket,
    required this.addToCart,
    required this.removeFromCart,
    required this.clearCart,
    required super.child,
  });

  static CartInherited of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CartInherited>();
    assert(result != null, 'CartInherited not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CartInherited oldWidget) =>
      state != oldWidget.state;
}

class CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketCard extends StatelessWidget {
  final Market market;
  final VoidCallback onSelect;

  const MarketCard({
    super.key,
    required this.market,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  market.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.store, size: 64, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        market.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  market.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${market.distance.toStringAsFixed(1)} км',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Открыт до ${market.closingTime}',
                      style: TextStyle(
                        color: market.isOpen ? Colors.green[700] : Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Выбрать',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Карточка товара
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = CartInherited.of(context);
    final quantity = cart.state.cartItems[product.id]?.quantity ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text('Нет фото', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price.toStringAsFixed(0)} ₽ / ${product.unit}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  quantity > 0
                      ? Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => cart.removeFromCart(product.id),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.remove, size: 16, color: Colors.black87),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => cart.addToCart(product),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => cart.addToCart(product),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('В корзину'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Экран выбора рынка
class MarketSelectionScreen extends StatelessWidget {
  const MarketSelectionScreen({super.key});

  static final List<Market> _markets = [
    Market(
      id: '1',
      name: 'Кузнечный рынок',
      address: 'ул. Марата, 16',
      rating: 4.8,
      distance: 1.2,
      closingTime: '20:00',
      imageUrl: 'https://avatars.mds.yandex.net/get-altay/1024093/2a000001622cbecc9e3daf4f8b8ce7e1b5be/L_height',
      isOpen: true,
    ),
    Market(
      id: '2',
      name: 'Сенной рынок',
      address: 'Московский проспект, 4А',
      rating: 4.6,
      distance: 2.8,
      closingTime: '19:00',
      imageUrl: 'https://avatars.mds.yandex.net/get-altay/5104421/2a0000018124e30dae7c50cd9616e99c58c6/L_height',
      isOpen: true,
    ),
    Market(
      id: '3',
      name: 'Сытный рынок',
      address: 'ул. Сытнинская, 4',
      rating: 4.7,
      distance: 3.5,
      closingTime: '21:00',
      imageUrl: 'https://n1s1.hsmedia.ru/83/81/17/8381175be6fa03a4949a74caceddb3d3/656x438_1_cd44f72b2824bc51454a288a7df777e7@1200x800_0xi9DaV6CO_4238568279405303054.jpg.webp',
      isOpen: true,
    ),
    Market(
      id: '4',
      name: 'Василеостровский рынок',
      address: 'Большой проспект В.О., 16',
      rating: 4.5,
      distance: 4.1,
      closingTime: '20:00',
      imageUrl: 'https://avatars.mds.yandex.net/get-altay/4544819/2a000001775e0d7de7e486512f2eb480d716/L_height',
      isOpen: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = CartInherited.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/684/684908.png',
            height: 32,
            width: 32,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Санкт-Петербург',
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              'Выберите рынок',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Свежие продукты с лучших рынков',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _markets.length,
              itemBuilder: (context, index) {
                return MarketCard(
                  market: _markets[index],
                  onSelect: () {
                    cart.selectMarket(_markets[index]);
                    Navigator.pushReplacementNamed(context, '/catalog');
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Рынки'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Каталог'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/catalog');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

// Экран каталога
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'Все';

  final List<Map<String, String>> categories = [
    {'name': 'Все', 'icon': '🛒'},
    {'name': 'Овощи', 'icon': '🥬'},
    {'name': 'Фрукты', 'icon': '🍎'},
    {'name': 'Мясо', 'icon': '🥩'},
    {'name': 'Молочные', 'icon': '🥛'},
    {'name': 'Выпечка', 'icon': '🥐'},
  ];

  List<Product> get _allProducts => [
    Product(
      id: '1',
      name: 'Помидоры розовые',
      category: 'Овощи',
      price: 120,
      unit: 'кг',
      imageUrl: 'https://tsx.x5static.net/i/800x800-fit/xdelivery/files/2a/e9/4d352df4528e4a07479e9bc4b5c9.jpg',
    ),
    Product(
      id: '2',
      name: 'Огурцы среднеплодные',
      category: 'Овощи',
      price: 90,
      unit: 'кг',
      imageUrl: 'https://optim.tildacdn.com/tild3835-3734-4363-b833-373632373135/-/resize/422x/-/format/webp/DSC_0033_2.jpg.webp',
    ),
    Product(
      id: '3',
      name: 'Перец красный',
      category: 'Овощи',
      price: 150,
      unit: 'кг',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXNzDxKCp6Bjx89sstpdfujhLKA4Aysp2KNw&s',
    ),
    Product(
      id: '4',
      name: 'Картофель молодой',
      category: 'Овощи',
      price: 60,
      unit: 'кг',
      imageUrl: 'https://cdn.tveda.ru/thumbs/bd7/bd7f72c2828b449f759223e8de37af04/fc23b658b6d1c4db8d53fdc193bfc063.jpg',
    ),
    Product(
      id: '5',
      name: 'Салат айсберг',
      category: 'Овощи',
      price: 80,
      unit: 'шт',
      imageUrl: 'https://cdn.metro-cc.ru/ru/ru_pim_328140001001_02.png?maxwidth=460&maxheight=460&format=jpg&quality=90&width=460&height=460',
    ),
    Product(
      id: '6',
      name: 'Яблоки Голден',
      category: 'Фрукты',
      price: 110,
      unit: 'кг',
      imageUrl: 'https://images.gastronom.ru/X4e84Hn4aW6Jyni1zw6QpHKxApl_zKlDM8GmkVBGe6I/pr:product-cover-image/g:ce/rs:auto:0:0:0/L2Ntcy9hbGwtaW1hZ2VzLzZjY2I1YWE5LTAyMzgtNGUwOC05ODUwLWFjYTEwN2YzYzRlMi5qcGc.webp',
    ),
    Product(
      id: '7',
      name: 'Бананы',
      category: 'Фрукты',
      price: 95,
      unit: 'кг',
      imageUrl: 'https://static.tildacdn.com/tild6139-3936-4630-a332-363438656330/_1.jpg',
    ),
    Product(
      id: '8',
      name: 'Молоко 3.2%',
      category: 'Молочные',
      price: 75,
      unit: 'л',
      imageUrl: 'https://s3.coolclever.tech/img/0000000034010024/960/4512.webp',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = CartInherited.of(context);
    final selectedMarket = cart.state.selectedMarket;

    if (selectedMarket == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Каталог',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Выберите рынок для просмотра товаров',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/markets'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Выбрать рынок', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(0),
      );
    }

    final filteredProducts = selectedCategory == 'Все'
        ? _allProducts
        : _allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pushReplacementNamed(context, '/markets'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedMarket.name,
              style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              'Открыт до ${selectedMarket.closingTime}',
              style: TextStyle(color: Colors.green[700], fontSize: 12),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black87),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/cart');
                },
              ),
              if (cart.state.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${cart.state.totalItems}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
  children: [
    SizedBox(
  height: 120,
  child: Center(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          return CategoryChip(
            label: cat['name']!,
            icon: cat['icon']!,
            isSelected: selectedCategory == cat['name'],
            onTap: () {
              setState(() {
                selectedCategory = cat['name']!;
              });
            },
          );
        }).toList(),
      ),
    ),
  ),
),
          Expanded(
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: cart.state.totalItems > 0 ? 180 : 90,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: filteredProducts[index]);
        },
      ),
    ),
  ],
),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cart.state.totalItems > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cart.state.totalItems} товара',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          Text(
                            '${cart.state.totalPrice.toStringAsFixed(0)} ₽',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('К корзине', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          _buildBottomNav(1),
        ],
      ),
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Рынки'),
      BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Каталог'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/markets');
            break;
          case 1:
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/cart');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }
}