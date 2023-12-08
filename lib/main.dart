import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/modules/orb/components/components.dart';
import 'package:taba/routes/router_provider.dart';
import 'package:taba/utils/exception_handler.dart';
import 'package:taba/utils/theme_provider.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  ExceptionHandler(
    onException: (String message) {
      OrbSnackBar.show(
        context: globalNavigatorKey.currentContext!,
        message: message,
        type: OrbSnackBarType.error,
      );
    }
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Flutter Demo',
      theme: ref.watch(themeProvider),
      home: Router(
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
