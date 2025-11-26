import 'package:app_notes/core/config/app_routes.dart';
import 'package:app_notes/core/config/route_names.dart';
import 'package:app_notes/core/theme/app_theme.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_events.dart';
import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/core/get_it/get_it.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_events.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/controller/data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DataController());
  await init();
  runApp(
    const BlocsProvider(),
  );
}

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => getIt<NotesBloc>()..add(GetAllNotesEvent()),
        ),
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
      buildWhen: (previous, current) => previous.themeEntity?.themeType != current.themeEntity?.themeType,
      builder: (context, state) {
        final isDark = state.themeEntity?.themeType == ThemeType.dark;

        // Optimización: Memorizar el tema
        final theme = AppTheme.getTheme(isDark);
        return ResponsiveSizer(builder: (context, orientation, screenType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            initialRoute: RouteNames.notesScreen,
            getPages: AppRoutes.routes,

            // Optimización: Carga perezosa de rutas
            routingCallback: (routing) {
              // Aquí podrías liberar recursos cuando sales de ciertas pantallas
              if (routing?.current == RouteNames.notesScreen) {
                // Reset cualquier caché específico si es necesario
              }
            },

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', ''), // Español
            ],
          );
        });
      },
    );
  }
}
