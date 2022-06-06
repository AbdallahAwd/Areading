class AdHelper {
  static const bool isTest = true;
  static String get doneAd {
    if (isTest) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    return 'ca-app-pub-2400508280875448/3472660745';
  }

  static String get bannerAd {
    if (isTest) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return 'ca-app-pub-2400508280875448/9521928309';
  }

  static String get rewardedAd {
    if (isTest) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return 'ca-app-pub-2400508280875448/4107945369';
  }
}
