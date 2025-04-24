import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/features/theme/domain/repository/theme_repository.dart';

class SaveThemeUseCase{
  final ThemeRepository themeRepository;

  SaveThemeUseCase({required this.themeRepository});

  Future<void> call(ThemeEntity themeEntity) async {
    await themeRepository.saveTheme(themeEntity);
  }
}