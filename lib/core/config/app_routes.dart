import 'package:app_notes/core/config/route_names.dart';
import 'package:app_notes/features/home/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes{
   final  goRouter = GoRouter(
    initialLocation: RouteNames.homeScreen,
    routes: [
      GoRoute(
        path: RouteNames.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}