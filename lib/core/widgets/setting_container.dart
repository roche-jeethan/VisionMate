import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pirates/bloc/language_bloc/bloc/lang_bloc.dart';
import 'package:tech_pirates/core/utils/text.dart';

List<String> lang = ["ENGLISH", "HINDI", "KANNADA"];

class SettingContainer extends StatelessWidget {
  const SettingContainer(
      {super.key,
      required this.whatHeSelected,
      required this.title,
      required this.caption,
      required this.fun,
      required this.color});

  final String whatHeSelected;
  final String title;
  final String caption;
  final VoidCallback fun;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //update him wht he has selected
        context.read<LangBloc>().add(
              LanguageAlertEvent("$whatHeSelected Double tap to select it"),
            );
      },
      onDoubleTap: fun,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleText(title: title),
              ),
              Center(
                child: TitleText(title: caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
