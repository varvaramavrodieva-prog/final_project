import 'package:flutter/material.dart';
import 'package:final_project/main.dart'; // Импортируем CartScreen из main.dart

// === Модель товара (можно вынести в отдельный файл) ===
class CartItem {
  final String name;
  final String weight;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;
}

// === Страница каталога ===
class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  // Список товаров
  final List<CartItem> cartItems = [
    CartItem(
      name: "Помидоры розовые",
      weight: "1 кг",
      price: 120,
      quantity: 1,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVjFaoIDcUR5UKAkYF97K50AJtLQXJP86liQ&s",
    ),
    CartItem(
      name: "Огурцы среднеплодные",
      weight: "1 кг",
      price: 90,
      quantity: 2,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIoRuZrbHdhw4qaEmzZk0OLmArZs95E_vcqg&s",
    ),
    CartItem(
      name: "Картофель молодой",
      weight: "1 кг",
      price: 60,
      quantity: 1,
      imageUrl: "https://cdn.tveda.ru/thumbs/bd7/bd7f72c2828b449f759223e8de37af04/fc23b658b6d1c4db8d53fdc193bfc063.jpg",
    ),
    CartItem(
      name: "Редис сладкий",
      weight: "1 шт",
      price: 89,
      quantity: 1,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbp0VUCVXgY2R1EhPkliBeii-1D37r06_0nQ&s",
    ),
    CartItem(
      name: "Кабачок вкусный",
      weight: "1 кг",
      price: 112,
      quantity: 1,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDYN2qU1eTx-9GY8kdaNH1I2u2S1R3yc_mEg&s",
    ),
    CartItem(
      name: "Листья салата",
      weight: "1 шт",
      price: 80,
      quantity: 1,
      imageUrl: "https://minio.clevermart.kz/food/images/2022/6/24/93127bda-cd88-4e03-80ff-74c7f476dcd4/M_2122750_1.png",
    ),
  ];

  // Обновление количества товара
  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity < 1) return;
    setState(() {
      cartItems[index].quantity = newQuantity;
    });
  }

  // Подсчёт общей суммы
  double get _totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Переход в корзину при нажатии на стрелку
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Даниловский рынок',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'до 21:00',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // Переход в корзину при нажатии на иконку
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Сетка товаров
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildProductCard(cartItems[index], index);
              },
            ),
          ),
          
          // Итоговая панель
          _buildBottomBar(),
        ],
      ),
    );
  }

  // Карточка товара
  Widget _buildProductCard(CartItem item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение товара
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, 
                          color: Colors.grey, size: 40),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
                // Метка веса
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.weight,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Информация о товаре
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  
                  // Цена и управление количеством
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price} ₽',
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // Контроллер количества
                      _buildQuantityControl(index, item.quantity),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Контроллер количества (+/-)
  Widget _buildQuantityControl(int index, int quantity) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4CAF50)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка минус
          InkWell(
            onTap: () => _updateQuantity(index, quantity - 1),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(Icons.remove, size: 14, 
                color: quantity <= 1 ? Colors.grey : const Color(0xFF4CAF50)),
            ),
          ),
          
          // Значение количества
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Кнопка плюс
          InkWell(
            onTap: () => _updateQuantity(index, quantity + 1),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Icon(Icons.add, size: 14, color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  // Нижняя панель с итогом
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Итого',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${_totalAmount.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _totalAmount > 0 
                ? () {
                    // Переход в корзину для оформления заказа
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                'Оформить заказ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}