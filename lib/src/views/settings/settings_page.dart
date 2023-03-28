// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/settings_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/utils/ads_helper.dart';
import 'package:todoon/src/views/settings/components/settings_section.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = PAGE_SETTINGS;
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Set<LanguageData> available = <LanguageData>{};
  late List<ThemeMode> themeList = ThemeMode.values;
  late List<ColorMode> colorList = ColorMode.values;

  late SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    // Language list initialization.
    Language.instance.available.then((value) => setState(() {
          available = value;
        }));
  }

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        this.settingsController = settingsController;
        return Scaffold(
          appBar: AppBar(
            // ignore: prefer_const_constructors
            leading: BackButtonWidget(),
            title: Text(Language.instance.Settings_Title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            clipBehavior: Clip.antiAlias,
            children: [
              _buildThemesSection(context),
              _buildLanguagesSection(context),
              _buildColorsSection(context),
              //_adsContainer(context),
            ],
          ),
        );
      },
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget _adsContainer(BuildContext context) {
    if (Platform.isAndroid) {
      final _bannerAd = AdsHelper.instance.getBannerAd?..load();
      return Card(
        child: SizedBox(
          height: 100,
          child: AdWidget(
            ad: _bannerAd!,
            key: UniqueKey(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // create all of the theme mode sections.
  Widget _buildThemesSection(BuildContext context) {
    // Currently, Theme Mode.
    late ThemeMode current = settingsController.themeMode;
    late ColorMode color = settingsController.colorMode;

    return SettingsSection(
      title: Language.instance.Setting_Theme_Title,
      children: themeList
          .map(
            (data) => RadioListTile<ThemeMode>(
              activeColor: Themes.instance.RadioSelectedColor,
              value: data,
              groupValue: current,
              title: Text(themeModeTitle(context, data.index)),
              onChanged: (value) async {
                if (value != null) {
                  //set current themeMode
                  current = value;
                  await Themes.instance
                      .set(themeMode: current, colorMode: color);
                  // save setting to storage
                  settingsController.themeMode = current;
                  await settingsController.saveSetting();
                }
              },
            ),
          )
          .toList(),
    );
  }

  // Set the theme mode title.
  String themeModeTitle(BuildContext context, int index) {
    if (index == 0) {
      return Language.instance.Setting_System_Title;
    } else if (index == 1) {
      return Language.instance.Setting_Light_Title;
    }

    return Language.instance.Setting_Dark_Title;
  }

  // create all of the color mode sections.
  Widget _buildColorsSection(BuildContext context) {
    // Currently, Color Mode.
    late ThemeMode current = settingsController.themeMode;
    late ColorMode color = settingsController.colorMode;

    return SettingsSection(
      title: Language.instance.Setting_Colors_Title,
      children: colorList
          .map(
            (data) => RadioListTile<ColorMode>(
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
            ),
          )
          .toList(),
    );
  }

  // Set the theme mode title.
  String colorModeTitle(BuildContext context, int index) {
    if (index == 1) {
      return Language.instance.Setting_Bleed_Title;
    }
    return Language.instance.Setting_Azure_Title;
  }

  // Create all of the language sections.
  _buildLanguagesSection(BuildContext context) {
    // Currently, Language.
    late LanguageData current = context.watch<Language>().current;

    return SettingsSection(
      title: Language.instance.Setting_Language_Title,
      children: available
          .map((data) => RadioListTile<LanguageData>(
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
              ))
          .toList(),
    );
  }
}
