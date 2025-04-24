import 'package:app_notes/features/theme/domain/entity/theme_entity.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_events.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis notas',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.themeEntity?.themeType == ThemeType.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                context.read<ThemeBloc>().add(ToggleThemeEvent());
              },
            );
          }),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
