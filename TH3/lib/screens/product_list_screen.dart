import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String category;
  const ProductListScreen({super.key, required this.category});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureProducts = ApiService().fetchProductsByCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.category}'),
        backgroundColor: const Color.fromARGB(255, 211, 166, 211),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          // 1. TRẠNG THÁI LOADING (Sử dụng vòng xoay hoặc Shimmer)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. TRẠNG THÁI LỖI & NÚT THỬ LẠI (YÊU CẦU BẮT BUỘC)
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Lỗi: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _loadData, // Gọi lại hàm để tải lại dữ liệu
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // 3. TRẠNG THÁI THÀNH CÔNG
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: snapshot.data![index]),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
