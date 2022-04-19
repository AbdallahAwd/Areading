import 'dart:math';

import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/Books/model/book_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../transliations/locale_keys.g.dart';

// ignore: must_be_immutable
class BookDescription extends StatelessWidget {
  final Items model;
  BookDescription({Key? key, required this.model}) : super(key: key);
  List<double> rating = [3.5, 4, 4.5, 5];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Image.network(
                      model.volumeInfo!.imageLinks?.thumbnail ??
                          'https://www.forewordreviews.com/books/covers/traveling-light.jpg',
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    model.volumeInfo!.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      model.volumeInfo?.authors?[0] ?? LocaleKeys.unknown.tr()),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainColor[index].withOpacity(0.8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (model.volumeInfo?.pageCount != null)
                              Text(
                                model.volumeInfo!.pageCount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 60,
                              child: AutoSizeText(
                                LocaleKeys.num_page.tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        const VerticalDivider(
                          width: 1,
                          color: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              model.volumeInfo?.language ?? 'en',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              LocaleKeys.lang.tr(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        const VerticalDivider(
                          width: 1,
                          color: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              model.volumeInfo!.categories?[0] ??
                                  LocaleKeys.unknown.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              LocaleKeys.cate.tr(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              LocaleKeys.rating.tr(),
              style: TextStyle(color: mainColor[index], fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: model.volumeInfo!.averageRating?.toDouble() ??
                    rating[Random().nextInt(2)],
                size: 40.0,
                color: Colors.amber,
                borderColor: Colors.amber,
                spacing: 5.0),
            const SizedBox(
              height: 10,
            ),
            Text(
              LocaleKeys.discription.tr(),
              style: TextStyle(
                fontSize: 25,
                color: mainColor[index],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                model.volumeInfo?.description ??
                    LocaleKeys.unknown_discription.tr(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (model.saleInfo?.listPrice?.amount != null)
              Row(
                children: [
                  Text(
                    LocaleKeys.price.tr(),
                    style: TextStyle(
                      fontSize: 25,
                      color: mainColor[index],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(model.saleInfo!.listPrice!.amount.toString() +
                      ' ' +
                      model.saleInfo!.listPrice!.currencyCode!)
                ],
              ),
          ],
        ),
      ),
      persistentFooterButtons: [
        if (model.saleInfo?.listPrice?.amount != null)
          defaultButton(
              colors: mainColor[index],
              onPressed: () async {
                if (!await launch(model.volumeInfo!.infoLink!)) {
                  throw 'Could not launch ${model.volumeInfo!.previewLink!}';
                }
              },
              textButton: LocaleKeys.lets_read.tr()),
      ],
    );
  }
}
