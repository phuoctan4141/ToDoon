// ignore_for_file: unused_field, prefer_final_fields, avoid_print, prefer_const_constructors, unused_element

import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob Helper.
class AdsHelper {
  static final AdsHelper instance = AdsHelper();

  static String get _adUnitId => Platform.isAndroid
      ? 'ca-app-pub-5975775955552049/8098480661'
      : 'ca-app-pub-5975775955552049/8098480661';

  /// Initial [Ads] for the application.
  static Future<void> initialize() async {
    // ignore: unnecessary_null_comparison
    if (MobileAds.instance == null) {
      await MobileAds.instance.initialize();
    }
  }

  /// get Banner Ad.
  BannerAd? getBannerAd() {
    BannerAd bAd = BannerAd(
        adUnitId: _adUnitId,
        size: AdSize.fluid,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: const AdRequest());

    return bAd;
  }
}
