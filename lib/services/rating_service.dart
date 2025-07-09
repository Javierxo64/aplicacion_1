import 'package:app/services/api_service.dart';

class RatingService {
  final ApiService _apiService = ApiService();

  Future<void> rateDish(String token, String dishToken, int rating) async {
    await _apiService.post(
      '/evaluation/dish',
      token,
      {'dishToken': dishToken, 'rate': rating},
    );
  }
}

