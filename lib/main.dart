import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Светлый фон как на макете
        fontFamily: 'sans-serif',
      ),
      // Здесь мы запускаем сразу экран корзины
      home: const CartScreen(),
    );
  }
}

// Модель товара в корзине
class CartItem {
  final String name;
  final String weight;
  final int price;
  int quantity;
  final String imageUrl; // Ссылка на картинку

  CartItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Список товаров (сюда вы добавите свои данные)
  List<CartItem> cartItems = [
    CartItem(
      name: "Помидоры розовые",
      weight: "1 кг",
      price: 120,
      quantity: 1,
      imageUrl: "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&q=80&w=200", // Пример картинки
    ),
    CartItem(
      name: "Огурцы среднеплодные",
      weight: "1 кг",
      price: 90,
      quantity: 2,
      imageUrl: "https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?auto=format&fit=crop&q=80&w=200",
    ),
    CartItem(
      name: "Картофель молодой",
      weight: "1 кг",
      price: 60,
      quantity: 1,
      imageUrl: "https://images.unsplash.com/photo-1518977676601-b28f1a796396?auto=format&fit=crop&q=80&w=200",
    ),
    // Добавьте еще товары здесь
  ];

  bool isDelivery = true; // true = Курьер, false = Самовывоз

  // Функция для подсчета итоговой суммы
  int get totalPrice {
    int sum = 0;
    for (var item in cartItems) {
      sum += item.price * item.quantity;
    }
    if (isDelivery) {
      sum += 150; // Стоимость доставки
    }
    return sum;
  }

  // Переход на экран Каталога (Страница 2)
  void _goToCatalog() {
    // TODO: Замените на реальную навигацию к экрану коллеги
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CatalogScreen()));
    print("Навигация в каталог");
  }

  // Переход на экран Профиля (Страница 4)
  void _goToProfile() {
    // TODO: Замените на реальную навигацию к экрану коллеги
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    print("Навигация в профиль");
  }

  // Навигация на другие экраны из нижней панели
  void _onBottomNavTap(int index) {
    if (index == 1) _goToCatalog();
    if (index == 3) _goToProfile();
  }

  @override
  Widget build(BuildContext context) {
    // Основная тема цветов (как на макете)
    const Color primaryGreen = Color(0xFF2E7D4A);
    const Color bgGreen = Color(0xFF4CAF50); // Для фона шапки профиля, если нужно
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goToCatalog, // Стрелка назад ведет на Стр 2
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Корзина",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              "Даниловский рынок",
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. Вертикально скроллящийся список товаров
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(cartItems[index], primaryGreen);
              },
            ),
          ),

          // 2. Блок доставки (не скроллится вместе с товарами, но может быть внутри, если нужно)
          // В данном дизайне он фиксирован над кнопкой "Итого"
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Адрес
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "ул. Ленина, 25, кв. 12",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Переключатель Курьер / Самовывоз
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isDelivery = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isDelivery ? primaryGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Курьером",
                                style: TextStyle(
                                  color: isDelivery ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isDelivery = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isDelivery ? primaryGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Самовывоз",
                                style: TextStyle(
                                  color: !isDelivery ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Цена доставки
                Text(
                  isDelivery ? "150 ₽" : "Бесплатно",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                const SizedBox(height: 12),

                // ПОЛЕ КОММЕНТАРИЯ (Показывается только если курьер)
                if (isDelivery)
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Пожелания к заказу",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),

          // 3. Подвал с итогом и кнопкой
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Итого", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("4 товара • 4 кг", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Text(
                      "${totalPrice} ₽",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Окно "Заказ успешно оформлен"
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 50),
                              const SizedBox(height: 15),
                              const Text(
                                "Заказ успешно оформлен",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // Закрыть диалог
                                    _goToProfile(); // Переход на экран 4
                                  },
                                  child: const Text("Перейти в профиль", style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Оформить заказ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // 4. Нижняя панель навигации
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Выделена вкладка "Корзина"
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'Рынки'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Каталог'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }

  // Виджет одного товара в списке
  Widget _buildCartItem(CartItem item, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Картинка товара
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Если картинка не загрузится, покажем серый квадрат
                return Container(width: 80, height: 80, color: Colors.grey[300]);
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Описание
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item.weight,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "${item.price} ₽",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Счетчик количества (+ / -)
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (item.quantity > 1) {
                      setState(() => item.quantity--);
                    }
                  },
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() => item.quantity++);
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