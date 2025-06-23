import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://happyhour-backend.onrender.com/api',
    headers: {'Content-Type': 'application/json'},
  ));

  Future<List<dynamic>> fetchMeals() async {
    final response = await _dio.get('/meals');
    return response.data;
  }

  Future<void> sendOrder(Map<String, dynamic> order) async {
    await _dio.post('/orders', data: order);
  }
}

final apiService = ApiService();
