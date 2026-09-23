import 'package:flutter/material.dart';

import 'theme.dart';
import 'router.dart';
import '../features/auth/auth_state.dart';

class MyApp extends StatelessWidget {
  final AuthState authState;

  const MyApp({
    super.key,
    required this.authState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authState,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Bill Buddy',
          theme: AppTheme.lightTheme,
          routerConfig: createRouter(authState),
        );
      },
    );
  }
}