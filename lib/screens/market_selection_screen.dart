import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/market.dart';
import '../services/cart_service.dart';
import '../widgets/market_card.dart';
import 'catalog_screen.dart';

class MarketSelectionScreen extends StatelessWidget {
  const MarketSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Market> markets = [
      Market(
        id: '1',
        name: 'Кузнечный рынок',
        address: 'ул. Марата, 16',
        rating: 4.8,
        distance: 1.2,
        closingTime: '20:00',
        imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800',
        isOpen: true,
      ),
      Market(
        id: '2',
        name: 'Сенной рынок',
        address: 'Московский проспект, 4А',
        rating: 4.6,
        distance: 2.8,
        closingTime: '19:00',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
        isOpen: true,
      ),
      Market(
        id: '3',
        name: 'Сытный рынок',
        address: 'ул. Сытнинская, 4',
        rating: 4.7,
        distance: 3.5,
        closingTime: '21:00',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1686529896385-8a8d581d0225?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        isOpen: true,
      ),
      Market(
        id: '4',
        name: 'Василеостровский рынок',
        address: 'Большой проспект В.О., 16',
        rating: 4.5,
        distance: 4.1,
        closingTime: '20:00',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1663040589382-88caf6b2bc60?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        isOpen: false,
      ),
    ];

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
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Выберите рынок',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
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
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: markets.length,
              itemBuilder: (context, index) {
                return MarketCard(
                  market: markets[index],
                  onSelect: () {
                    context.read<CartService>().selectMarket(markets[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CatalogScreen(),
                      ),
                    );
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
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Каталог'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        onTap: (index) {
          if (index == 1) {
            // Переход на вкладку Каталог
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CatalogScreen(),
              ),
            );
          } else if (index == 2) {
            // Корзина
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Корзина будет у ваших коллег')),
            );
          } else if (index == 3) {
            // Профиль
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Профиль будет у ваших коллег')),
            );
          }
        },
      ),
    );
  }
}