import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/auth/login/login_provider.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/routes/router_provider.dart';

import '../../modules/orb/components/components.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  late final TextEditingController nicknameController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    // TODO: implement initState
    nicknameController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    // TODO: implement didUpdateWidget
    nicknameController.clear();
    passwordController.clear();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nicknameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '로그인',
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrbTextFormField(
              controller: nicknameController,
              labelText: '닉네임',
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '닉네임을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            OrbTextFormField(
              controller: passwordController,
              labelText: '비밀번호',
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                ref.read(loginProvider.notifier).getSignupToken().then(
                    (value) => ref
                        .read(routerProvider)
                        .push(RouteInfo.signUp.fullPath));
              },
              child: Text(
                '회원가입 하기',
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      submitButton: OrbButton(
        onPressed: () async {

          if (!formKey.currentState!.validate()) {
            return;
          }
          await ref.read(loginProvider.notifier).login(
              nickname: nicknameController.text,
              password: passwordController.text);
          if (!ref.read(loginProvider).hasError) {
            ref.read(routerProvider).push(RouteInfo.main.fullPath);
          }
        },
        buttonText: '로그인하기',
      ),
    );
  }
}
