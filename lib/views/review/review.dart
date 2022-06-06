import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../Ads/reworded_ad.dart';
import '../../bloc/heighlight/heigh_state.dart';
import '../../bloc/heighlight/heighlight_bloc.dart';
import '../../custom/swiping_card.dart';
import '../../shared/components/components.dart';
import '../../transliations/locale_keys.g.dart';
import 'all_heighlights.dart';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>['SwipCard']);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool? isshown = CacheHelper.getData(key: 'isshown');
    return BlocConsumer<HeighCubit, HeighState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  richText(),
                  const SizedBox(
                    height: 40,
                  ),
                  if (HeighCubit.get(context).getAdded.isNotEmpty)
                    DescribedFeatureOverlay(
                      tapTarget: const Icon(Icons.touch_app),
                      featureId: 'SwipCard',
                      backgroundColor: mainColor[index],
                      targetColor: Colors.white,
                      title: Text(LocaleKeys.review_discovery_title.tr()),
                      contentLocation: ContentLocation.above,
                      enablePulsingAnimation: true,
                      pulseDuration: const Duration(seconds: 2),
                      barrierDismissible: false,
                      overflowMode: OverflowMode.extendBackground,
                      openDuration: const Duration(seconds: 1),
                      description: Text(LocaleKeys.review_discovery_dis.tr()),
                      child: SwipingCard(isshown != null ? 1 : 6,
                          HeighCubit.get(context).getAdded),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      AdReworded.loadRewaredAd();
                      navigateTo(context, PageTransitionType.bottomToTop,
                          const AllHeighlights());
                    },
                    child: heighlight(context,
                        text: LocaleKeys.all_heigh.tr(), assetName: 'box.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // heighlight(context,
                  //     text: 'Public HeighLights', icons: MyIcons.relations)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget richText() => Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 69,
          color: mainColor[index],
        ),
        children: const [
          TextSpan(
            text: 'A',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'reading',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textHeightBehavior:
          const TextHeightBehavior(applyHeightToFirstAscent: false),
      softWrap: false,
    );
