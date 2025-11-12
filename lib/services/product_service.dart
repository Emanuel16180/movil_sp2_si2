import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://192.168.252.42:8000/api', // ← Cambia la IP si es necesario
      baseUrl: 'https://ecommercebackend-7m3u.onrender.com/api',
    ),
  );

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/products/');
      if (response.statusCode == 200) {
        List<Product> products = (response.data as List)
            .map((json) => Product.fromJson(json))
            .toList();
        return products;
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
