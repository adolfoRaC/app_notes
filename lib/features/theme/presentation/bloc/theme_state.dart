import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';

enum ThemeStatus{
  initial,
  loading,
  success,
  error
}

class ThemeState{
  final ThemeStatus status;
  final String? errorMessage;
  final ThemeEntity? themeEntity;

  const ThemeState({
    this.status = ThemeStatus.initial,
    this.errorMessage = '',
    this.themeEntity,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      status: ThemeStatus.initial,
    );
  }

  ThemeState copyWith({
    ThemeStatus? status,
    ThemeEntity? themeEntity,
    String? errorMessage,
  }) {
    return ThemeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      themeEntity: themeEntity ?? this.themeEntity,
    );
  }
}