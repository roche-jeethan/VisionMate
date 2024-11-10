import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:tech_pirates/features/voice_guidance/voice_assistance.dart';

part 'lang_event.dart';
part 'lang_state.dart';

List<String> lang = [
  "en-US",
  "kn-IN",
  " hi-IN",
];

String appLanguage = "en-US";

class LangBloc extends Bloc<LangEvent, LangState> {
  LangBloc() : super(LangInitial()) {
    on<LanguageAlertEvent>(selectLanguageVoice);
    on<LanguageSelectedEvent>(selectedLanguage);
    on<LanguageChangeEvent>(changeEvent);
  }

  void changeEvent(LanguageChangeEvent event, Emitter emit) {
    switch (event.systemLanguage) {
      case "ENGLISH":
        appLanguage = "en-US";
        break;
      case "HINDI":
        appLanguage = "hi-IN";
        break;
      case "KANNADA":
        appLanguage = "kn-IN";

        break;
      default:
        appLanguage = "en-US";
    }
  }

//it is alerting him about it
  void selectLanguageVoice(LanguageAlertEvent event, Emitter emit) {
    VoiceAssistance.speak(event.selectedLanguage, appLanguage);
  }

//it is updatin ui
  void selectedLanguage(LanguageSelectedEvent event, Emitter emit) {
    String lang = event.selectedLanguage;
    emit(LanguageSelectedState(selectedLanguage: event.selectedLanguage));
    switch (lang) {
      case "ENGLISH":
        break;
      default:
    }
  }
}
