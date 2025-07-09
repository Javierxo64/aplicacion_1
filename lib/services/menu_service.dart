import 'package:app/services/api_service.dart';

class MenuService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getTodayMenus(String token) async {
    final response = await _apiService.get('/menu/today', token);
    return response.data;
  }

  Future<Map<String, dynamic>> getCategoryMenu(String token, String categoryToken) async {
    final response = await _apiService.get('/menu/$categoryToken/today', token);
    return response.data;
  }
}