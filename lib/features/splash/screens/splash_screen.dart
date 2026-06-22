import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/auth/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkLogin();
      }
    });
  }

  Future<void> _checkLogin() async {
    final restored =
        await ref.read(authProvider.notifier).tryRestoreSession();

    if (!mounted) return;

    context.go(restored ? '/dashboard' : '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 340,
              height: 340,
              child: DotLottieLoader.fromAsset(
                'assets/animations/factory.lottie',
                frameBuilder: (context, dotlottie) {
                  if (dotlottie != null) {
                    return Lottie.memory(
                      dotlottie.animations.values.single,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Groovy Inventory',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
