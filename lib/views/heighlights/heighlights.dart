import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/home/home_states.dart';
import '../../shared/components/components.dart';
import '../../transliations/locale_keys.g.dart';
import 'add_heighlight.dart';

class HeighLights extends StatelessWidget {
  const HeighLights({Key? key}) : super(key: key);

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
                    addHeigh(
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
                    addHeigh(
                      icon: Icons.edit_note,
                      onPressed: () {
                        navigateTo(context, PageTransitionType.rightToLeft,
                            const AddHeighlight());
                      },
                      text: LocaleKeys.text.tr(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}