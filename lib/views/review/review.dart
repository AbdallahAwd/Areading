import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/heighlight/heigh_state.dart';
import '../../bloc/heighlight/heighlight_bloc.dart';
import '../../custom/swiping_card.dart';
import '../../shared/components/components.dart';
import '../../transliations/locale_keys.g.dart';
import 'all_heighlights.dart';

class Review extends StatelessWidget {
  const Review({Key? key}) : super(key: key);
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
                    SwipingCard(isshown != null ? 1 : 6,
                        HeighCubit.get(context).getAdded),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
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
