import 'package:flutter/material.dart';

import 'package:tech_pirates/core/utils/text.dart';
import 'package:tech_pirates/core/widgets/lang_container.dart';
import 'package:tech_pirates/core/widgets/setting_container.dart';
import 'package:vibration/vibration.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  void changePage() async {
    Vibration.vibrate(pattern: [500, 500]);
    await Future.delayed(Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(title: "Setting"),
      ),
      body: ListView(children: [
        Column(
          children: [
            const LangContainer(),
            SettingContainer(
              whatHeSelected: "Profile",
              title: "Profile",
              caption: "NAME",
              fun: changePage,
              color: const Color.fromARGB(255, 113, 172, 220),
            ),
            SettingContainer(
              whatHeSelected: "Subscription",
              title: "Subscription",
              caption: "Subscribe",
              fun: () async {
                Vibration.vibrate(pattern: [500, 500]);
                await Future.delayed(Duration(milliseconds: 600));
              },
              color: const Color.fromARGB(255, 230, 165, 108),
            )
          ],
        ),
      ]),
    );
  }
}
