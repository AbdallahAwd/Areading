// ignore_for_file: use_key_in_widget_constructors

import 'dart:math';

import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/transliations/locale_keys.g.dart';
import 'package:areading/views/heighlights/models/add.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/heighlight/heighlight_bloc.dart';
import '../bloc/home/home_states.dart';
import '../shared/notifications/awsome_no.dart';

class SwipingCard extends StatefulWidget {
  @override
  _SwipingCardState createState() => _SwipingCardState();
  final int slideNum;
  final List<AddHeighLight> slideText;
  const SwipingCard(this.slideNum, this.slideText);
}

class _SwipingCardState extends State<SwipingCard>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          controller!.forward();
        });
        NotificationApi.cancelNotification(0);
        final random = Random().nextInt(HeighCubit.get(context).txt.length - 1);
        NotificationApi.notify(
          title: HeighCubit.get(context).bookName[random],
          body: HeighCubit.get(context).txt[random],
          channelKey: 'Areading',
          image: HeighCubit.get(context).bookImage[random],
          notificationInterval: 8000,
          id: 0,
        );
      },
      child: CardStack(controller!, widget.slideNum, widget.slideText),
    );
  }
}

class CardStack extends StatefulWidget {
  final AnimationController controller;
  final int slideNum;
  final List<AddHeighLight> slideText;
  // ignore: prefer_const_constructors_in_immutables
  CardStack(this.controller, this.slideNum, this.slideText);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Animation<Offset>? slideAnimation;
  List<SlideCard>? cardList;

  @override
  void initState() {
    super.initState();
    cardList = List.generate(
      widget.slideNum,
      (int num) => SlideCard(num, widget.slideText),
    );
    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.ease,
      ),
    );
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.controller.reset();
        setState(
          () => cardList!.removeLast(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: cardList!.map(
        (item) {
          return Transform.translate(
            offset: Offset(0, -item.num * 5.0),
            child: SlideTransition(
              position: getSlideOffset(item.num),
              child: item,
            ),
          );
        },
      ).toList(),
    );
  }

  getSlideOffset(int cardnum) {
    if (cardnum == cardList!.length - 1) {
      return slideAnimation;
    } else {
      return const AlwaysStoppedAnimation(Offset.zero);
    }
  }
}

class SlideCard extends StatefulWidget {
  final int num;
  final List<AddHeighLight> text;

  const SlideCard(this.num, this.text);

  @override
  State<SlideCard> createState() => _SlideCardState();
}

class _SlideCardState extends State<SlideCard> {
  double height = 300;
  double size = 50;
  bool isshown = CacheHelper.getData(key: 'isshown') ?? false;
  @override
  void initState() {
    super.initState();
    change();
  }

  void change() {
    widget.num == 0 ? isshown = true : null;
  }

  @override
  Widget build(BuildContext context) {
    int indexRandom = Random().nextInt(widget.text.length);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (isshown) {
          return InkWell(
            onTap: () {
              setState(() {
                height = 0;
                size = 0;

                CacheHelper.setData(key: 'isshown', boolValue: isshown);
              });
            },
            child: AnimatedContainer(
              width: double.infinity,
              height: height,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                  color: mainColor[index],
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
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.good_job.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(80)),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: size,
                    ),
                  )
                ],
              )),
            ),
          );
        } else {
          return Center(
              child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: mainColor[index],
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
                          widget.text[indexRandom].bookimage!,
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
                              widget.text[indexRandom].bookname!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              widget.text[indexRandom].bookauthor!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: AutoSizeText(
                      widget.text[indexRandom].text!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.text[indexRandom].date!,
                        style: const TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ));
        }
      },
    );
  }
}
