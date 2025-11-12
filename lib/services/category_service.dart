import 'package:dio/dio.dart';
import '../models/category_model.dart';

class CategoryService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://192.168.252.42:8000/api', 
      baseUrl: 'https://ecommercebackend-7m3u.onrender.com/api',
    ),
  );

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories/');
      if (response.statusCode == 200) {
        List<Category> categories = (response.data as List)
            .map((json) => Category.fromJson(json))
            .toList();
        return categories;
      } else {
        throw Exception('Error al cargar categorías');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
