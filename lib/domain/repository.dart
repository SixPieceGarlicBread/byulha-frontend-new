// repository.dart
import 'package:image_picker/image_picker.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/dio_provider.dart';
import 'auth/login/login.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository(ref.read(dioProvider)));

class Repository {

  final Dio _dio;
  String? accessToken;
  Repository(this._dio);

  Future<String> getSignupToken() async {
    final response = await _dio.get('/user/signup-token');
    return response.data['signupToken'];
  }

  Future<bool> sendSMS({required String phoneNumber, required String signupToken}) async {
    final response = await _dio.post(
      '/sms/$signupToken',
      data: {
        'phoneNumber': phoneNumber,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifySMS({required String code, required String signupToken}) async {
    final response = await _dio.post(
      '/sms/verify/$signupToken',
      data: {
        'code': code,
      },
    );
    return response.statusCode == 200;
  }

  Future<Login> login(String nickname, String password) async {
    final response = await _dio.post(
      '/user/login',
      data: {
        'nickname': nickname,
        'password': password,
      },
    );
    accessToken = response.data['accessToken'];
    return Login.fromJson(response.data);
  }

  Future<bool> signUp({
    required String signupToken,
    required String name,
    required String nickname,
    required String age,
    required String gender,
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post(
      '/user/$signupToken',
      data: {
        'name': name,
        'nickname': nickname,
        'age' : age,
        'gender' : gender,
        'phone' : phone,
        'password': password,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyNickname({required String nickname}) async {
    final response = await _dio.post(
      '/user/signup/verify/$nickname',
    );
    return response.statusCode == 200;
  }

  Future<PerfumeList> getPerfumeList(int page, int size) async {
    final response = await _dio.get(
      '/perfume?page=$page&size=$size&sort=rating,desc',
    );
    if (response.statusCode == 200) {
      return PerfumeList.fromJson(response.data);
    } else {
      throw Exception('Failed to load perfumes');
    }
  }

  Future<PerfumeList> getRecommendedPerfumeList(List<XFile> images) async{
    final files = images.map((e) => MultipartFile.fromFileSync(
      e.path,
    )).toList();
    final response = await _dio.post(
      '/user/upload/image-test?page=0&size=20',
      data: FormData.fromMap({
        'images': files,
      }),
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization' : 'Bearer $accessToken',
        },
      ),
    );
    return PerfumeList.fromJson(response.data);
  }

  Future<PerfumeDetail> getPerfumeDetail(int id) async{
    final response = await _dio.post(
      '/perfume/$id',
    );
    return PerfumeDetail.fromJson(response.data);
  }
}
