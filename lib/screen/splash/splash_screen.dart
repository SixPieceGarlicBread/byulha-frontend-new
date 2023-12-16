import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/routes/router_path.dart';
import 'package:taba/routes/router_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  createState() => _SplashScreen();
}

class _SplashScreen extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(milliseconds: 2500),
      backgroundColor: Color(0xffefe9e3),
      onEnd: () {
        if (mounted) ref.read(routerProvider).pushReplacement(RouteInfo.login.fullPath);
      },
      splashScreenBody: FadeTransition(
        opacity: _controller,
        child: Center(
          child:
Image.asset(
            'assets/images/logo.png',
            width: 500,
            height: 500,
          ),

 /*         Text(
            'PURPLE',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color(0xff625a8b),
            ),
          ),
*/
        ),
      ),
    );
  }
}
