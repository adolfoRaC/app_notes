import 'package:app_notes/features/theme/data/datasource/theme_local_datasource.dart';
import 'package:app_notes/features/theme/data/repository/theme_repository_impl.dart';
import 'package:app_notes/features/theme/domain/repository/theme_repository.dart';
import 'package:app_notes/features/theme/domain/usecase/get_theme_use_case.dart';
import 'package:app_notes/features/theme/domain/usecase/save_theme_use_case.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future init() async {
  getIt.registerSingleton(await SharedPreferences.getInstance());

  getIt.registerSingleton(ThemeLocalDatasource(sharedPreferences: getIt()));

  getIt.registerSingleton<ThemeRepository>(ThemeRepositoryImpl(
    themeLocalDatasource: getIt(),
  ));

  getIt.registerSingleton(GetThemeUseCase(themeRepository: getIt()));
  getIt.registerSingleton(SaveThemeUseCase(themeRepository: getIt()));

  getIt.registerFactory(() => ThemeBloc(
        getThemeUseCase: getIt(),
        saveThemeUseCase: getIt(),
      ));
}
