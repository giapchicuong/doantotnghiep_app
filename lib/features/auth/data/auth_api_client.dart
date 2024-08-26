import 'package:dio/dio.dart';

import '../dtos/login_dto.dart';
import '../dtos/login_success_dto.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient(this.dio);

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      final response = await dio.post('/authApp/login/', data: {
        'username': loginDto.username,
        'password': loginDto.password,
      });
      return LoginSuccessDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error_message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
