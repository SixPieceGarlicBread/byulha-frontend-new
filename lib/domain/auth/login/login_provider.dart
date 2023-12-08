import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/auth/login/login.dart';
import 'package:taba/main.dart';
import 'package:taba/modules/orb/components/components.dart';

import '../../repository.dart';

final loginProvider =
AsyncNotifierProvider<LoginNotifier, Login?>(() => LoginNotifier());

class LoginNotifier extends AsyncNotifier<Login?> {
  String? signupToken;
  String validNickname = "";
  Future<void> login(
      {required String nickname, required String password}) async {
    state = await AsyncValue.guard(() async =>
    await ref.read(repositoryProvider).login(nickname, password));
  }

  Future<void> getSignupToken() async {
    signupToken = await ref.read(repositoryProvider).getSignupToken();
  }

  Future<bool> signUp({
    required String name,
    required String nickname,
    required String age,
    required String gender,
    required String phone,
    required String password,
  }) async {

    return await ref.read(repositoryProvider).signUp(
      signupToken: signupToken!,
      name: name,
      nickname: nickname,
      age: age,
      gender: gender,
      phone: phone,
      password: password,
    );
  }

  Future<bool> sendSMS({required String phoneNumber}) async {
    return await ref.read(repositoryProvider).sendSMS(
        signupToken: signupToken!,
        phoneNumber: phoneNumber
    );
  }

  Future<bool> verifySMS({required String code}) async {
    return await ref.read(repositoryProvider).verifySMS(
      signupToken: signupToken!,
      code: code
    );
  }

  Future<void> verifyNickname({required String nickname}) async {
    validNickname = "";
    final result = await AsyncValue.guard(() async =>
    await ref.read(repositoryProvider).verifyNickname(nickname : nickname));
    if (!result.hasError) {
      validNickname = nickname;
    }
  }

  Future<bool> setNickname({required String nickname}) async {
    if (validNickname != nickname) {
      OrbSnackBar.show(
        context: globalNavigatorKey.currentContext!,
        message: "닉네임 중복확인을 해주세요.",
        type: OrbSnackBarType.error,
      );
      return false;
    }
    return true;
  }



  @override
  FutureOr<Login?> build() async {
    // TODO: implement build
    return state.value;
  }
}
