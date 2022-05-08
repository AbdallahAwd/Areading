import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/home/home_states.dart';
import '../../shared/components/components.dart';
import '../../transliations/locale_keys.g.dart';
import 'add_heighlight.dart';

class HeighLights extends StatefulWidget {
  const HeighLights({Key? key}) : super(key: key);

  @override
  State<HeighLights> createState() => _HeighLightsState();
}

class _HeighLightsState extends State<HeighLights> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(
          context, <String>['AddText', 'AddTextByCam']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is TextRecognizationSuccess) {
          navigateTo(
              context,
              PageTransitionType.leftToRight,
              AddHeighlight(
                scannedText: HomeCubit.get(context).scannedText,
              ));
        }
      },
      builder: (context, state) {
        return Center(
          child: state is TextRecognizationLoading
              ? const CircularProgressIndicator.adaptive()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                      tapTarget: const Icon(Icons.camera_alt),
                      featureId: 'AddTextByCam',
                      backgroundColor: mainColor[index],
                      targetColor: Colors.white,
                      title:
                          Text(LocaleKeys.heughlight_discovery_cam_title.tr()),
                      contentLocation: ContentLocation.trivial,
                      enablePulsingAnimation: true,
                      pulseDuration: const Duration(seconds: 2),
                      barrierDismissible: false,
                      overflowMode: OverflowMode.extendBackground,
                      openDuration: const Duration(seconds: 1),
                      description:
                          Text(LocaleKeys.heughlight_discovery_cam_dis.tr()),
                      child: addHeigh(
                        icon: Icons.camera_alt,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            HomeCubit.get(context)
                                                .getImage(ImageSource.camera);
                                            pop(context);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: mainColor[index],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(LocaleKeys.camera.tr())
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            HomeCubit.get(context)
                                                .getImage(ImageSource.gallery);
                                            pop(context);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: mainColor[index],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(LocaleKeys.gallery.tr())
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        text: LocaleKeys.camera.tr(),
                      ),
                    ),
                    DescribedFeatureOverlay(
                      tapTarget: const Icon(Icons.edit_note),
                      featureId: 'AddText',
                      backgroundColor: mainColor[index],
                      targetColor: Colors.white,
                      title: Text(LocaleKeys.heughlight_discovery_title.tr()),
                      contentLocation: ContentLocation.trivial,
                      enablePulsingAnimation: true,
                      pulseDuration: const Duration(seconds: 2),
                      barrierDismissible: false,
                      overflowMode: OverflowMode.extendBackground,
                      openDuration: const Duration(seconds: 1),
                      description:
                          Text(LocaleKeys.heughlight_discovery_dis.tr()),
                      child: addHeigh(
                        icon: Icons.edit_note,
                        onPressed: () {
                          navigateTo(context, PageTransitionType.rightToLeft,
                              const AddHeighlight());
                        },
                        text: LocaleKeys.text.tr(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
