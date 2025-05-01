import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/features/theme/domain/usecases/get_theme_use_case.dart';
import 'package:app_notes/features/theme/domain/usecases/save_theme_use_case.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_events.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvents, ThemeState> {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeBloc({
    required this.getThemeUseCase,
    required this.saveThemeUseCase,
  }) : super(ThemeState.initial()) {
    on<GetThemeEvent>(onGetThemeEvent);
    on<ToggleThemeEvent>(onToggleThemeEvent);
  }

  Future<void> onGetThemeEvent(GetThemeEvent event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(status: ThemeStatus.loading));
    try {
      final result = await getThemeUseCase();
      emit(state.copyWith(
        status: ThemeStatus.success,
        themeEntity: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ThemeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> onToggleThemeEvent(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    if (state.themeEntity != null) {
      final newThemeType = state.themeEntity!.themeType == ThemeType.dark ? ThemeType.light : ThemeType.dark;
      final newThemeEntity = ThemeEntity(themeType: newThemeType);
      try {
        await saveThemeUseCase(newThemeEntity);
        emit(state.copyWith(status: ThemeStatus.success, themeEntity: newThemeEntity));
      } catch (e) {
        emit(state.copyWith(
          status: ThemeStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }
}
