import 'dart:math';

import 'package:areading/bloc/heighlight/heigh_state.dart';
import 'package:areading/bloc/heighlight/heighlight_bloc.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/heighlights/models/add.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';

import '../../transliations/locale_keys.g.dart';
import 'gen_image.dart';

class AllHeighlights extends StatefulWidget {
  const AllHeighlights({
    Key? key,
  }) : super(key: key);

  @override
  State<AllHeighlights> createState() => _AllHeighlightsState();
}

class _AllHeighlightsState extends State<AllHeighlights> {
  var editController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HeighCubit, HeighState>(
      listener: (context, state) {},
      builder: (context, index) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) => [
              SliverAppBar(

                  /// floatHeaderSlivers & floating both will be true
                  floating: true,
                  snap: true,

                  /// for animation. snap: true & floating: true both
                  title: Text(LocaleKeys.heighlight.tr()))
            ],
            body: HeighCubit.get(context).getAdded.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/noHeighlight.png',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(LocaleKeys.no_heighLight.tr()),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < HeighCubit.get(context).getAdded.length) {
                            return addToHeighLights(
                                HeighCubit.get(context).getAdded[index], index);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                LocaleKeys.no_more_heigh.tr(),
                                style: const TextStyle(color: Colors.grey),
                              )),
                            );
                          }
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount:
                            HeighCubit.get(context).getAdded.length + 1)),
          ),
        );
      },
    );
  }

  Widget addToHeighLights(AddHeighLight model, int indexa) => InkWell(
        onTap: () {
          vibrate();
          editController.text = model.text!;
          dialog(model, indexa);
        },
        child: Container(
          height: model.text!.length < 100 ? 200 : 300,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  .withOpacity(0.7),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        model.bookimage!,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/noBook.jpg',
                            width: 50,
                            height: 70,
                          );
                        },
                        width: 50,
                        height: 70,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.bookname!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            model.bookauthor!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: model.text!.length < 100 ? 40 : 140,
                  width: double.infinity,
                  child: AutoSizeText(
                    model.text!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(
                  height: 1,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AutoSizeText(model.date!,
                      style: const TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      );

  dialog(AddHeighLight model, int indexa) {
    Dialog mainDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        width: 350.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    model.bookimage!,
                    width: 60,
                    height: 67,
                    errorBuilder: (context, object, race) {
                      return Container(
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 0.5)),
                        child: Image.asset(
                          'assets/images/noBook.jpg',
                          width: 60,
                          height: 67,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.bookname!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.bookauthor!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: editController,
                maxLines: 5,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return LocaleKeys.txtfrom_field_validation.tr();
                  }
                  return null;
                },
                maxLength: 320,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                    label: Text(LocaleKeys.edit.tr())),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  dialogButton(
                      onTap: () {
                        vibrate();
                        HeighCubit.get(context)
                            .copy(editController.text, context);
                      },
                      icon: Icons.copy,
                      color: mainColor[index]),
                  dialogButton(
                      onTap: () {
                        vibrate();
                        pop(context);
                        navigateTo(
                            context,
                            PageTransitionType.rightToLeft,
                            GenImage(
                              model: model,
                            ));
                      },
                      icon: Icons.image_outlined,
                      color: mainColor[index]),
                  dialogButton(
                      onTap: () {
                        vibrate();
                        Share.share(editController.text + 'Areading App');
                      },
                      icon: Icons.ios_share_rounded,
                      color: mainColor[index]),
                  dialogButton(
                      onTap: () {
                        vibrate();
                        pop(context);

                        HeighCubit.get(context).deleteHeighLight(
                            HeighCubit.get(context).getAddedId[indexa]);
                      },
                      icon: Icons.delete,
                      color: Colors.red),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text(LocaleKeys.cancel.tr()),
                      onPressed: () {
                        pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: mainColor[index],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    ElevatedButton(
                      child: Text(LocaleKeys.save.tr()),
                      onPressed: () {
                        vibrate();
                        pop(context);
                        HeighCubit.get(context).updateHeighLight(
                            HeighCubit.get(context).getAddedId[indexa],
                            text: editController.text,
                            bookauthor: model.bookauthor,
                            bookimage: model.bookimage,
                            bookname: model.bookname,
                            date: model.date);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: mainColor[index],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => mainDialog,
    );
  }
}
