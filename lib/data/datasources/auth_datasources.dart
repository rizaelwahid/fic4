import 'package:fic4_flutter_auth_bloc/data/localsources/auth_local_storage.dart';
import 'package:fic4_flutter_auth_bloc/data/models/request/login_model.dart';
import 'package:fic4_flutter_auth_bloc/data/models/request/register_model.dart';
import 'package:fic4_flutter_auth_bloc/data/models/response/login_response_model.dart';
import 'package:fic4_flutter_auth_bloc/data/models/response/profile_response_model.dart';
import 'package:fic4_flutter_auth_bloc/data/models/response/register_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class AuthDatasource {
  Future<RegisterResponseModel> register(RegisterModel registerModel) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/users/'),
      body: registerModel.toMap(),
    );

    final result = RegisterResponseModel.fromJson(response.body);
    return result;
  }

  // Future<LoginResponseModel> login(LoginModel loginModel) async {
  //   final response = await http.post(
  //     Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
  //     body: loginModel.toMap(),
  //   );

  //   final result = LoginResponseModel.fromJson(response.body);
  //   return result;
  // }

  Future<Either<String, LoginResponseModel>> login(
      LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
        body: loginModel.toMap(),
      );

      if (response.statusCode == 200) {
        final result = LoginResponseModel.fromJson(response.body);
        print(result);
        return Right(result);
      } else {
        return Left('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  Future<ProfileResponseModel> getProfile() async {
    final token = await AuthLocalStorage().getToken();
    var headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/auth/profile'),
      headers: headers,
    );

    final result = ProfileResponseModel.fromJson(response.body);
    return result;
  }
}
