import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/market.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import 'market_selection_screen.dart';

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

  List<Product> getProductsForMarket(Market market) {
    return [
      Product(
        id: '1',
        name: 'Помидоры розовые',
        category: 'Овощи',
        price: 120,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1635843131003-d5cd578b0f85?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      Product(
        id: '2',
        name: 'Огурцы среднеплодные',
        category: 'Овощи',
        price: 90,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1566486189376-d5f21e25aae4?q=80&w=1467&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      Product(
        id: '3',
        name: 'Перец красный',
        category: 'Овощи',
        price: 150,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1608737637507-9aaeb9f4bf30?q=80&w=1035&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      Product(
        id: '4',
        name: 'Картофель молодой',
        category: 'Овощи',
        price: 60,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=300&fit=crop',
      ),
      Product(
        id: '5',
        name: 'Салат айсберг',
        category: 'Овощи',
        price: 80,
        unit: 'шт',
        imageUrl: 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400&h=300&fit=crop',
      ),
      Product(
        id: '6',
        name: 'Яблоки Голден',
        category: 'Фрукты',
        price: 110,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=300&fit=crop',
      ),
      Product(
        id: '7',
        name: 'Бананы',
        category: 'Фрукты',
        price: 95,
        unit: 'кг',
        imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=300&fit=crop',
      ),
      Product(
        id: '8',
        name: 'Молоко 3.2%',
        category: 'Молочные',
        price: 75,
        unit: 'л',
        imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=300&fit=crop',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final selectedMarket = cartService.selectedMarket;
    
    // Если рынок не выбран - показываем предложение выбрать
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
                Icon(
                  Icons.store_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Выберите рынок для просмотра товаров',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Выбрать рынок',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Рынки'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Каталог'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MarketSelectionScreen(),
                ),
              );
            }
          },
        ),
      );
    }

    final allProducts = getProductsForMarket(selectedMarket);
    final filteredProducts = selectedCategory == 'Все'
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MarketSelectionScreen(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedMarket.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Открыт до ${selectedMarket.closingTime}',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black87),
                onPressed: () {
                  // Переход к корзине
                },
              ),
              if (cartService.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartService.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Категории
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryChip(
                  label: categories[index]['name']!,
                  icon: categories[index]['icon']!,
                  isSelected: selectedCategory == categories[index]['name'],
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index]['name']!;
                    });
                  },
                );
              },
            ),
          ),
          
          // Список продуктов
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: cartService.totalItems > 0 ? 180 : 90,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
              
                );
              },
            ),
          ),
        ],
      ),
      
      // Единый bottomNavigationBar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Панель корзины
          if (cartService.totalItems > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                            '${cartService.totalItems} товара',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${cartService.totalPrice.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Переход к оформлению заказа
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'К корзине',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Нижняя навигация
          BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green[700],
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Рынки'),
              BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Каталог'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarketSelectionScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}