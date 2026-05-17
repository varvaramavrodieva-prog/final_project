import 'package:flutter/material.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  
  bool _showDeliveryAddresses = false;
  bool _showPaymentMethods = false;
  bool _showFavorites = false;

  final List<Map<String, String>> _deliveryAddresses = [
    {'label': 'Дом', 'value': 'ул. Пушкина, д. 10, кв. 25'},
    {'label': 'Работа', 'value': 'проспект Ленина, д. 50, офис 301'},
  ];

  final List<Map<String, String>> _paymentMethods = [
    {'label': 'Visa', 'value': '•••• 1234'},
    {'label': 'Mastercard', 'value': '•••• 5678'},
    {'label': 'Наличные', 'value': 'При получении'},
  ];

  final List<Map<String, String>> _favorites = [
    {'label': 'Молоко', 'value': 'Домик в деревне 3.2%'},
    {'label': 'Хлеб', 'value': 'Бородинский нарезка'},
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ Изменили на тот же цвет, что в корзине
    const primaryGreen = Color(0xFF2E7D4A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя зеленая панель профиля
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16, bottom: 24, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      GestureDetector(
                        child: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://static.independent.co.uk/2024/05/24/13/Gordon.jpg?quality=75&width=1368&crop=3%3A2%2Csmart&auto=webp',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey[300]);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Гордон Рамзи',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '+7 999 123-45-67',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Блок "Мои данные"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Мои данные',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildExpandableSection(
                    icon: Icons.location_on_outlined,
                    title: 'Адреса доставки',
                    count: '2',
                    isExpanded: _showDeliveryAddresses,
                    onToggle: () => setState(() => _showDeliveryAddresses = !_showDeliveryAddresses),
                    items: _deliveryAddresses,
                    primaryColor: primaryGreen,
                  ),
                  
                  const Divider(height: 1, thickness: 0.5),
                  
                  // 🔹 Способы оплаты
                  _buildExpandableSection(
                    icon: Icons.credit_card_outlined,
                    title: 'Способы оплаты',
                    count: '3',
                    isExpanded: _showPaymentMethods,
                    onToggle: () => setState(() => _showPaymentMethods = !_showPaymentMethods),
                    items: _paymentMethods,
                    primaryColor: primaryGreen,
                  ),
                  
                  const Divider(height: 1, thickness: 0.5),
                  
                  // Любимые продукты 
                  _buildExpandableSection(
                    icon: Icons.favorite_border,
                    title: 'Любимые продукты',
                    count: '2', 
                    isExpanded: _showFavorites,
                    onToggle: () => setState(() => _showFavorites = !_showFavorites),
                    items: _favorites,
                    primaryColor: primaryGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Заголовок истории заказов
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'История заказов',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Смотреть все',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Список заказов
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final orders = [
                          {'id': '1234', 'date': '24 мая 2024, 18:30', 'price': '1 230 ₽', 'status': 'Доставлен'},
                          {'id': '1233', 'date': '20 мая 2024, 14:20', 'price': '875 ₽', 'status': 'Доставлен'},
                          {'id': '1232', 'date': '15 мая 2024, 16:45', 'price': '1 450 ₽', 'status': 'Доставлен'},
                          {'id': '1231', 'date': '12 мая 2024, 9:30', 'price': '3 230 ₽', 'status': 'Доставлен'},
                          {'id': '1230', 'date': '11 мая 2024, 12:20', 'price': '875 ₽', 'status': 'Доставлен'},
                        ];
                        final order = orders[index];
                        return _buildOrderCard(
                          orderNumber: 'Заказ №${order['id']}',
                          date: order['date']!,
                          price: order['price']!,
                          status: order['status']!,
                          primaryColor: primaryGreen,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Нижняя навигация
            _buildBottomNav(primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required String count,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Map<String, String>> items,
    required Color primaryColor,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(icon, color: primaryColor, size: 15),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Выпадающий список элементов
        if (isExpanded) ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Text(
                  '${item['label']}: ',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: Text(
                    item['value']!,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String date,
    required String price,
    required String status,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://krasnyy-sulin.flowers-cvety.ru/sites/default/files/styles/414x414/public/bouquets/nabor_produktov_pervoy_neobhodimosti_v_upakovke.jpg?itok=FaQ4Qs7h',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey[200],
                  child: const Icon(Icons.shopping_basket, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
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
      onTap: () {
        setState(() => _selectedIndex = index);
        
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        }
      },
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
}