import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'adunit.dart';

class AdManager extends GetxController {
  late final AppLifecycleReactor appLifecycleReactor;

  AppOpenAd? _appOpenAd;

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  @override
  Future<void> onInit() async {
    appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: AdManager());
    appLifecycleReactor.listenToAppStateChanges();
    super.onInit();
  }

  InterstitialAd? interstitialAd;

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
        adUnitId: AdUnits.interstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) async {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            interstitialAd = ad;
            await ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  Future<void> rewardedAd() async {
    await RewardedAd.load(
        adUnitId: AdUnits.reward,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) async {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            await ad.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void onClose() {
    _appOpenAd?.dispose();
    super.onClose();
  }

  Future<void> loadAppOpenAd() async {
    AppOpenAd.load(
      adUnitId: AdUnits.appOpen,
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          ad.fullScreenContentCallback = const FullScreenContentCallback();
          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('AppOpenAd failed to load: $error');
          }
        },
      ),
      request: const AdRequest(),
    );
  }
}

class AppLifecycleReactor {
  final AdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  Future<void> _onAppStateChanged(AppState appState) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (appState == AppState.foreground) {
      await appOpenAdManager.loadAppOpenAd();
    }
  }
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? bannerAd;

  Future<void> loadBanner() async {
    await BannerAd(
      adUnitId: AdUnits.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          if (kDebugMode) {
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
          }
        },
      ),
    ).load();
    setState(() {});
  }

  @override
  void initState() {
    loadBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd == null
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: AdSize.banner.width.toDouble(),
              minHeight: AdSize.banner.height.toDouble(),
              maxWidth: AdSize.fullBanner.width.toDouble(),
              maxHeight: AdSize.fullBanner.height.toDouble(),
            ),
            child: AdWidget(ad: bannerAd!));
  }
}

class NativeAdsWidget extends StatefulWidget {
  const NativeAdsWidget({super.key, required this.widget});
  final Widget widget;

  @override
  State<NativeAdsWidget> createState() => NativeAdsWidgetState();
}

class NativeAdsWidgetState extends State<NativeAdsWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  /// Loads a native ad.
  Future<void> loadAd() async {
    _nativeAd = NativeAd(
      adUnitId: AdUnits.native,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          setState(() {
            _nativeAdIsLoaded = false;
          });
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        mainBackgroundColor: Colors.transparent,
        cornerRadius: 10.0,
        // callToActionTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.cyan,
        //     backgroundColor: Colors.red,
        //     style: NativeTemplateFontStyle.monospace,
        //     size: 16.0),
        // primaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.red,
        //     backgroundColor: Colors.cyan,
        //     style: NativeTemplateFontStyle.italic,
        //     size: 16.0),
        // secondaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.green,
        //     backgroundColor: Colors.black,
        //     style: NativeTemplateFontStyle.bold,
        //     size: 16.0),
        // tertiaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.brown,
        //     backgroundColor: Colors.amber,
        //     style: NativeTemplateFontStyle.normal,
        //     size: 16.0),
      ),
    );
    await _nativeAd?.load();
  }

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_nativeAdIsLoaded) {
      return widget.widget;
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          // minWidth: ,
          // minHeight: AdSize.banner.height.toDouble(),
          minWidth: 320,
          minHeight: 400,
        ),
        child: AdWidget(ad: _nativeAd!));
    }
  }
}


AdManager adManager = Get.find<AdManager>();
