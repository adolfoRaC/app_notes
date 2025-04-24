import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeLocalDatasource{
  final SharedPreferences sharedPreferences;

  ThemeLocalDatasource({required this.sharedPreferences});

  Future saveTheme(ThemeEntity themeEntity) async {
    final themeValue = themeEntity.themeType == ThemeType.dark ? 'dark' : 'light';
    await sharedPreferences.setString('theme_key', themeValue);
  }

  Future<ThemeEntity> getTheme() async {
    final themeValue = sharedPreferences.getString('theme_key') ?? 'light';
    final themeType = themeValue == 'dark' ? ThemeType.dark : ThemeType.light;
    return ThemeEntity(themeType: themeType);
  }
}