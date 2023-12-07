import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taba/domain/auth/login/login_provider.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/screen/error/route_error_screen.dart';
import 'package:taba/screen/login/login_screen.dart';
import 'package:taba/screen/login/sign_up/signup_screen.dart';
import 'package:taba/screen/main/home/home_screen.dart';
import 'package:taba/screen/splash/splash_screen.dart';

import '../screen/main/home/image_recognition_screen.dart';
import '../screen/main/main_screen.dart';
import '../screen/main/profile_screen.dart';

final Provider<GoRouter> routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouteInfo.main.fullPath,
      routes: [
        GoRoute(
          path: RouteInfo.splash.fullPath,
          builder: (context, state) => SplashScreen(key: state.pageKey),
        ),
        GoRoute(
          path: RouteInfo.main.fullPath,
          builder: (context, state) => MainScreen(key: state.pageKey),
          routes: [
            GoRoute(
              path: RouteInfo.home.path,
              builder: (context, state) => HomeScreen(key: state.pageKey),
              routes: [
                GoRoute(
                  path: RouteInfo.imageRecognition.path,
                  builder: (context, state) =>
                      ImageRecognitionScreen(key: state.pageKey),
                ),
              ],
            ),
            GoRoute(
              path: RouteInfo.profile.path,
              builder: (context, state) => ProfileScreen(key: state.pageKey),
            ),
          ],
        ),
        GoRoute(
          path: RouteInfo.login.fullPath,
          builder: (context, state) => LoginScreen(key: state.pageKey),
          routes: [
            GoRoute(
              path: RouteInfo.signUp.path,
              builder: (context, state) => SignUpScreen(key: state.pageKey),
            ),
            // GoRoute(
            //   path: RouteInfo.loginHelp.path,
            //   builder: (context, state) => LoginHelpScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.findUserId.path,
            //   builder: (context, state) => FindUserIdScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.findUserIdComplete.path,
            //   builder: (context, state) =>
            //       FindUserIdCompleteScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.sendSMStoResetPassword.path,
            //   builder: (context, state) =>
            //       SendSMStoResetPasswordScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.verifySMStoResetPassword.path,
            //   builder: (context, state) =>
            //       VerifySMStoResetPasswordScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.resetPassword.path,
            //   builder: (context, state) => ResetPasswordScreen(key: state.pageKey),
            // ),
            // GoRoute(
            //   path: RouteInfo.resetPasswordComplete.path,
            //   builder: (context, state) =>
            //       ResetPasswordCompleteScreen(key: state.pageKey),
            // ),
          ],
        ),
      ],
      errorBuilder: (context, state) => RouteErrorScreen(
        key: state.pageKey,
        errorMessage: state.error.toString(),
      ),
      redirect: (context, state) {
        if (state.fullPath == null || state.fullPath!.isEmpty) {
          //page not found error
        } else if (ref.watch(loginProvider).value == null &&
            !state.fullPath!.contains(RouteInfo.login.fullPath)) {
          //return RouteName.login;
        }
        return null;
      },
    );
  },
);
