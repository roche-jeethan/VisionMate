part of 'lang_bloc.dart';

sealed class LangState extends Equatable {
  const LangState();

  @override
  List<Object> get props => [];
}

final class LangInitial extends LangState {}

class LanguageAlertState extends LangState {}

class LanguageSelectedState extends LangState {
  const LanguageSelectedState({
    required this.selectedLanguage,
  });
  final String selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];
}
