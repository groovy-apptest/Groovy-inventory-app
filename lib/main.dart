import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/router/app_router.dart';
import 'package:groovy_inventory/app/theme/app_theme.dart';
import 'package:groovy_inventory/core/utils/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  log.i('Groovy Inventory started');
  runApp(const ProviderScope(child: GroovyInventoryApp()));
}

class GroovyInventoryApp extends StatelessWidget {
  const GroovyInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Groovy Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
