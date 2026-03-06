import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/loading_shimmer.dart';
import 'product_list_screen.dart'; // Bạn tạo màn hình danh sách sản phẩm theo category

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasError = false;
  bool _isLoading = true;

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Laptop',
      'icon': Icons.laptop_mac,
      'color': Color.fromARGB(255, 141, 199, 246),
    },
    {
      'title': 'Phụ kiện',
      'icon': Icons.headphones,
      'color': Color.fromARGB(255, 254, 172, 136),
    },
    {
      'title': 'Điện thoại',
      'icon': Icons.smartphone,
      'color': Color.fromARGB(255, 227, 245, 94),
    },
    {
      'title': 'Máy tính bảng',
      'icon': Icons.tablet_android,
      'color': Color.fromARGB(255, 115, 192, 121),
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkNetwork();
  }

  Future<void> _checkNetwork() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(seconds: 2)); // Hiệu ứng Shimmer

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('TH3 - Triệu Thị Tuyết Mai - 2351160535'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 189, 215),
      ),
      body: _isLoading
          ? const LoadingShimmer() // 1. Loading
          : _hasError
          ? _buildErrorUI() // 2. Error
          : _buildHomeContent(), // 3. Success
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Không có kết nối internet!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _checkNetwork,
            icon: const Icon(Icons.refresh),
            label: const Text('THỬ LẠI'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 20, 9, 57).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Chọn sản phẩm',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductListScreen(category: item['title']),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'], size: 60, color: item['color']),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          item['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
