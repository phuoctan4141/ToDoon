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

class DrawerWidget extends StatefulWidget {
  bool notHome;
  Widget? content;
  FocusNode? focusNode;

  DrawerWidget({
    Key? key,
    this.notHome = true,
    this.content,
    this.focusNode,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.unfocus();
  }

  @override
  void dispose() {
    widget.focusNode?.unfocus();
    super.dispose();
  }

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
          (widget.content != null)
              ? Expanded(
                  child:
                      Card(child: SingleChildScrollView(child: widget.content)))
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

          if (widget.notHome) {
            Navigator.pushNamed(context, PlansPage.routeName);
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

          Navigator.pushNamed(context, SettingsPage.routeName);
        },
      ),
    );
  }

  Widget _adsContainer(BuildContext context) {
    if (Platform.isAndroid) {
      final _bannerAd = AdsHelper.instance.getBannerAd()!..load();
      return Card(
        child: SizedBox(
          height: 100,
          width: 378,
          child: AdWidget(
            ad: _bannerAd,
            key: UniqueKey(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
