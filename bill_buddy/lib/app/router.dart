import 'package:go_router/go_router.dart';

import '../features/home/home.dart';
import '../features/add_biller/add_biller.dart';
import '../features/biller_selection/biller_selection.dart';
import '../features/biller_form/biller_form.dart';

import '../features/auth/auth_state.dart';
import '../features/auth/login.dart';
import '../features/auth/signup.dart';

import '../features/payment/payment_review.dart';
import '../features/payment/payment_success.dart';
import '../models/bill.dart';
import '../models/payment.dart';

GoRouter createRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;

      final isGoingToLogin =
          state.matchedLocation == '/login';

      final isGoingToSignup =
          state.matchedLocation == '/signup';

      final isGoingToAuth =
          isGoingToLogin || isGoingToSignup;

      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }

      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginScreen(
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return SignupScreen(
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/',
        builder: (context, state) {
          return HomeScreen(
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/add-biller',
        builder: (context, state) {
          return const AddBillerScreen();
        },
      ),

      GoRoute(
        path: '/biller-selection',
        builder: (context, state) {
          final category =
              state.uri.queryParameters['category'] ?? '';

          return BillerSelectionScreen(
            category: category,
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/biller-form',
        builder: (context, state) {
          final category =
              state.uri.queryParameters['category'] ?? '';

          final biller =
              state.uri.queryParameters['biller'] ?? '';

          return BillerFormScreen(
            category: category,
            biller: biller,
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/payment-review',
        builder: (context, state) {
          final bill = state.extra as Bill;

          return PaymentReviewScreen(
            bill: bill,
            authState: authState,
          );
        },
      ),

      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          final payment = state.extra as Payment;

          return PaymentSuccessScreen(
            payment: payment,
          );
        },
      ),
    ],
  );
}