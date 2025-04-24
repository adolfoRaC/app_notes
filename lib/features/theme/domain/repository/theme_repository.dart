import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';

abstract class ThemeRepository {
  Future<ThemeEntity> getTheme();
  Future saveTheme(ThemeEntity themeEntity);
}