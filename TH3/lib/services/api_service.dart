import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    try {
      // Chuyển đổi tên danh mục sang slug của API (VD: 'Điện thoại' -> 'smartphones')
      String categorySlug = categoryName == 'Điện thoại'
          ? 'smartphones'
          : categoryName == 'Laptop'
          ? 'laptops'
          : 'tablets';

      final response = await http
          .get(
            Uri.parse('https://dummyjson.com/products/category/$categorySlug'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // LẤY ĐÚNG KEY 'products' ĐỂ TRÁNH LỖI TYPE CASTING
        List jsonResponse = data['products'];
        return jsonResponse.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Quăng lỗi ra để HomeScreen bắt được và hiện giao diện Thử lại
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
