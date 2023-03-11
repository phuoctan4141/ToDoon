// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, prefer_const_constructors, no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/utils/ads_helper.dart';
import 'package:todoon/src/views/data/plans/plans_page.dart';
import 'package:todoon/src/views/settings/settings_page.dart';

class DrawerWidget extends StatelessWidget {
  bool notHome;
  Widget? content;

  DrawerWidget({
    Key? key,
    this.notHome = true,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          _Header(context),
          _Home(context),
          _Settings(context),
          (content != null)
              ? Expanded(
                  child: Card(child: SingleChildScrollView(child: content)))
              : Container(),
          const SizedBox(height: 3.0),
          _adsContainer(context),
          const SizedBox(height: 3.0),
          // (content != null) ? const Divider(thickness: 1) : Container(),
        ],
      ),
    );
  }

  Widget _Header(BuildContext context) {
    return SizedBox(
      height: 150,
      child: DrawerHeader(
        decoration: BoxDecoration(
          image: const DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/icons/banner.png')),
          color: Themes.instance.isLightMode
              ? Themes.instance.lightTheme.colorScheme.surface
              : Themes.instance.darkTheme.colorScheme.surface,
        ),
        child: ListTile(
          leading:
              const Image(image: AssetImage('assets/icons/todoon_256.ico')),
          title: Text(Strings.NAME_APP,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _Home(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.home, color: Themes.instance.DrawerIconColor),
        title: const Text(Strings.NAME_APP,
            style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.pop(context);

          if (notHome) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlansPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _Settings(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.settings, color: Themes.instance.DrawerIconColor),
        title: Text(Language.instance.Settings_Title,
            style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(),
            ),
          );
        },
      ),
    );
  }

  Widget _adsContainer(BuildContext context) {
    final _bannerAd = AdsHelper.instance.getBannerAd()!..load();

    if (Platform.isAndroid) {
      return Card(
        child: SizedBox(
          height: 100,
          width: 378,
          child: AdWidget(
            ad: _bannerAd,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
