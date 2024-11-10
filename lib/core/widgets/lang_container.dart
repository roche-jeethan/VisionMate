//change language as user taps
//update him by alterting him using voice assis
//reser after user reaches to last lang
//call bloc to update the ui or calll the fuction

//app language should get updated

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pirates/bloc/language_bloc/bloc/lang_bloc.dart';
import 'package:tech_pirates/core/utils/text.dart';
import 'package:vibration/vibration.dart';

List<String> lang = ["ENGLISH", "HINDI", "KANNADA"];

class LangContainer extends StatelessWidget {
  const LangContainer({super.key});

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return GestureDetector(
      onTap: () async {
        Vibration.vibrate(duration: 500);
        await Future.delayed(Duration(milliseconds: 600));
        //update him wht he has selected
        context.read<LangBloc>().add(const LanguageAlertEvent(
            "Selecte Language double tap to change the language"));
      },
      onDoubleTap: () async {
        Vibration.vibrate(pattern: [500, 500]);
        await Future.delayed(Duration(milliseconds: 600));
        //update the bloc and make this
        if (index < 2) {
          index++;
        } else {
          index = 0;
        }
        context
            .read<LangBloc>()
            .add(LanguageChangeEvent(systemLanguage: lang[index]));
        context.read<LangBloc>().add(LanguageAlertEvent(lang[index]));
        context.read<LangBloc>().add(LanguageSelectedEvent(lang[index]));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 189, 216, 216),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TitleText(title: "Select Languages"),
              ),
              Center(
                child: BlocBuilder<LangBloc, LangState>(
                  builder: (context, state) {
                    if (state is LanguageSelectedState) {
                      return TitleText(title: state.selectedLanguage);
                    }
                    return TitleText(title: lang[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
