import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/settings_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/routes/routes_export.dart';

class IntroPage extends StatefulWidget {
  static const routeName = PAGE_INTRO;
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late SettingsController settingsController;

  late Set<LanguageData> available = <LanguageData>{};
  late List<ColorMode> colorList = ColorMode.values;
  late List<PageViewModel> pages;

  @override
  void initState() {
    super.initState();
    SettingsController.instance.onFirstTime;
    // Language list initialization.
    Language.instance.available.then((value) => setState(() {
          available = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        this.settingsController = settingsController;
        pages = [
          firstpage,
          secondPage,
          thirdPage,
        ];
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
            child: IntroductionScreen(
              pages: pages,
              dotsDecorator: DotsDecorator(
                size: const Size(15, 15),
                color: Theme.of(context).colorScheme.primary,
                activeSize: const Size.square(20),
                activeColor: Theme.of(context).colorScheme.secondary,
                activeShape: RoundedRectangleBorder(
                    borderRadius: Themes.instance.switchRollBorder),
              ),
              showDoneButton: true,
              done: Text(
                Language.instance.Done,
                style: const TextStyle(fontSize: 20),
              ),
              showSkipButton: true,
              skip: Text(
                Language.instance.Skip,
                style: const TextStyle(fontSize: 20),
              ),
              skipStyle: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.tertiary),
              showNextButton: true,
              next: const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
              nextStyle: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.tertiary),
              onDone: () => onDone(context),
              doneStyle: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.tertiary),
              curve: Curves.bounceOut,
            ),
          ),
        );
      },
    );
  }

  PageViewModel get firstpage => PageViewModel(
      title: Language.instance.Welcome_Title,
      body: Language.instance.Welcome_Content,
      image: Center(
        child: Lottie.asset(ToDoonIcons.do_work_lottie),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ));

  PageViewModel get secondPage {
    // Currently, Language.
    late LanguageData current = context.watch<Language>().current;

    return PageViewModel(
        image: Center(
          child: Lottie.asset(ToDoonIcons.language_lottie),
        ),
        title: Language.instance.Welcome_Title,
        bodyWidget: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 150,
            ),
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  Language.instance.Setting_Language_Title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ),
        footer: Column(
          children: available.map((data) {
            return RadioListTile<LanguageData>(
              activeColor: Themes.instance.RadioSelectedColor,
              value: data,
              groupValue: current,
              title: Text(data.name),
              onChanged: (value) async {
                if (value != null) {
                  // set current Language
                  current = value;
                  await Language.instance.set(value: value);
                  // save setting to storage
                  settingsController.languageData = current;
                  await settingsController.saveSetting();
                }
              },
            );
          }).toList(),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          imagePadding: EdgeInsets.only(top: 24.0),
          titlePadding: EdgeInsets.only(bottom: 24.0),
          bodyAlignment: Alignment.bottomCenter,
        ));
  }

  PageViewModel get thirdPage {
    // Currently, Color Mode.
    late ThemeMode current = settingsController.themeMode;
    late ColorMode color = settingsController.colorMode;

    return PageViewModel(
        image: Center(
          child: Lottie.asset(ToDoonIcons.color_lottie),
        ),
        title: Language.instance.Welcome_Title,
        bodyWidget: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 150,
            ),
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  Language.instance.Setting_Colors_Title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ),
        footer: Column(
          children: colorList.map((data) {
            return RadioListTile<ColorMode>(
              activeColor: Themes.instance.RadioSelectedColor,
              value: data,
              groupValue: color,
              title: Text(colorModeTitle(context, data.index)),
              onChanged: (value) async {
                if (value != null) {
                  //set current colorMode
                  color = value;
                  await Themes.instance
                      .set(themeMode: current, colorMode: color);
                  // save setting to storage
                  settingsController.colorMode = color;
                  await settingsController.saveSetting();
                }
              },
            );
          }).toList(),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          imagePadding: EdgeInsets.only(top: 24.0),
          titlePadding: EdgeInsets.only(bottom: 24.0),
          bodyAlignment: Alignment.bottomCenter,
        ));
  }

  // Set the color mode title.
  String colorModeTitle(BuildContext context, int index) {
    if (index == 1) {
      return Language.instance.Setting_Bleed_Title;
    }
    return Language.instance.Setting_Azure_Title;
  }

  void onDone(context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PlansPage()));
  }
}
