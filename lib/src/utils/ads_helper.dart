// ignore_for_file: unused_field, prefer_final_fields, avoid_print, prefer_const_constructors, unused_element, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob Helper.
class AdsHelper {
  static final AdsHelper instance = AdsHelper();

  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111';

  static String get nativeAdUnitId => 'ca-app-pub-3940256099942544/2247696110';

  /// Initial [Ads] for the application.
  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      await MobileAds.instance.initialize();
    }
  }

  /// get Banner Ad.
  BannerAd? get getBannerAd {
    var _ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdClosed: (Ad ad) {
        print("Ad Closed");
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      }, onAdLoaded: (Ad ad) {
        print('Ad Loaded');
      }, onAdOpened: (Ad ad) {
        print('Ad opened');
      }),
    );

    return _ad;
  }

  // get Native Ad.
  NativeAd? get getNativeAd {
    var _ad = NativeAd(
      adUnitId: nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (Ad ad) => print('Ad clicked.'),
      ),
    );

    return _ad;
  }
}
