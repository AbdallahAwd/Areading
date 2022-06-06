import 'dart:developer';

import 'package:areading/Ads/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdReworded {
  static RewardedAd? _ad;
  static bool isAddReady = false;
  static void loadRewaredAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAd,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          _ad = ad;
          isAddReady = true;
        }, onAdFailedToLoad: (error) {
          log('Error happened $error');
        }));
  }

  static void showAd() {
    if (isAddReady) {
      _ad!.show(onUserEarnedReward: (ad, rewordedItem) {
        log('Rewarded ad reward ${rewordedItem.type}');
      });
    }
  }
}
