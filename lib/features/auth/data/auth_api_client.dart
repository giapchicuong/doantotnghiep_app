import 'package:dio/dio.dart';

import '../dtos/login_dto.dart';
import '../dtos/login_success_dto.dart';
import '../dtos/register_dto.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient(this.dio);

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      final response = await dio.post('/login', data: loginDto.toJson());
      final int ec = response.data['EC'];
      switch (ec) {
        case 0:
          return LoginSuccessDto.fromJson(response.data['DT']);
        default:
          throw Exception(response.data['EM']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['EM']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> register(RegisterDto registerDto) async {
    try {
      final response = await dio.post('/register', data: registerDto.toJson());
      final int ec = response.data['EC'];
      if (ec != 0) {
        throw Exception(response.data['EM']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['EM']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
