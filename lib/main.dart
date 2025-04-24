import 'package:app_notes/core/config/app_routes.dart';
import 'package:app_notes/core/theme/app_theme.dart';
import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/core/get_it/get_it.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_events.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const BlocsProvider());
}

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ThemeBloc>()..add(GetThemeEvent()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(state.themeEntity?.themeType == ThemeType.dark),
          routerConfig: AppRoutes().goRouter,
        );
      }
    );
  }
}
