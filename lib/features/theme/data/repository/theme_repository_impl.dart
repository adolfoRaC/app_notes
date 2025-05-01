import 'package:app_notes/features/theme/data/datasource/theme_local_datasource.dart';
import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/features/theme/domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;
  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<ThemeEntity> getTheme() async {
    return await themeLocalDatasource.getTheme();
  }

  @override
  Future<void> saveTheme(ThemeEntity themeEntity) async {
    await themeLocalDatasource.saveTheme(themeEntity);
  }
}