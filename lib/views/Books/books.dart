import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/Books/book_description.dart';
import 'package:areading/views/Books/model/book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/home/home_states.dart';
import '../../transliations/locale_keys.g.dart';

// ignore: must_be_immutable
class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final topController = ScrollController();
  final cateController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>['SearchBooks']);
    });
    topController.addListener(() {
      if (topController.position.maxScrollExtent == topController.offset) {
        HomeCubit.get(context).limit += 3;
        HomeCubit.get(context).getTopBooks();
        HomeCubit.get(context)
            .bookModel!
            .items!
            .addAll(HomeCubit.get(context).bookModel!.items!);
      }
    });
    cateController.addListener(() {
      if (cateController.position.maxScrollExtent == cateController.offset) {
        HomeCubit.get(context).limit += 3;
        HomeCubit.get(context).getRandomBooks();
        HomeCubit.get(context)
            .bookModel2!
            .items!
            .addAll(HomeCubit.get(context).bookModel2!.items!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (HomeCubit.get(context).hasInternet) {
      return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return HomeCubit.get(context).bookModel2 == null ||
                  HomeCubit.get(context).bookModel == null
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    controller: cateController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        LocaleKeys.top.tr(),
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 25,
                          color: mainColor[index],
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                            controller: topController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index <
                                  HomeCubit.get(context)
                                      .bookModel!
                                      .items!
                                      .length) {
                                return topBuilder(
                                    HomeCubit.get(context)
                                        .bookModel!
                                        .items![index],
                                    context);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            itemCount: HomeCubit.get(context)
                                    .bookModel!
                                    .items!
                                    .length +
                                1),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        LocaleKeys.all_cate.tr(),
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 25,
                          color: mainColor[index],
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: false,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index <
                                HomeCubit.get(context)
                                    .bookModel2!
                                    .items!
                                    .length) {
                              return categoryBuilder(
                                  HomeCubit.get(context)
                                      .bookModel2!
                                      .items![index],
                                  context);
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          itemCount:
                              HomeCubit.get(context).bookModel2!.items!.length +
                                  1),
                    ],
                  ));
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/noBook.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(LocaleKeys.internet_connection.tr())
          ],
        ),
      );
    }
  }
}

Widget categoryBuilder(Items model, context) => InkWell(
      onTap: () {
        navigateTo(
            context,
            PageTransitionType.bottomToTop,
            BookDescription(
              model: model,
            ));
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Image.network(
              model.volumeInfo?.imageLinks?.thumbnail ??
                  'https://www.forewordreviews.com/books/covers/traveling-light.jpg',
              width: 110,
              fit: BoxFit.cover,
              errorBuilder: ((context, error, stackTrace) => const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator.adaptive())),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.volumeInfo!.title!,
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model.volumeInfo?.authors?[0] ?? LocaleKeys.unknown.tr(),
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model.volumeInfo!.description ??
                      LocaleKeys.unknown_discription.tr(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: mainColor[index],
                    borderRadius: BorderRadius.circular(5.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                  ),
                  child: Text(
                    model.volumeInfo?.categories?[0] ?? LocaleKeys.unknown.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
Widget topBuilder(Items model, context) => InkWell(
      onTap: () {
        navigateTo(
            context,
            PageTransitionType.bottomToTop,
            BookDescription(
              model: model,
            ));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            width: 150,
            padding: const EdgeInsets.all(10),
            height: 230,
            decoration: BoxDecoration(
                color: mainColor[index].withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.volumeInfo!.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  model.volumeInfo?.authors?[0] ?? LocaleKeys.unknown.tr(),
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: false,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Image.network(
              model.volumeInfo?.imageLinks?.thumbnail ??
                  'https://www.forewordreviews.com/books/covers/traveling-light.jpg',
              height: 190,
              width: 125,
              fit: BoxFit.cover,
              errorBuilder: ((context, error, stackTrace) => const SizedBox(
                  width: 100,
                  height: 60,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator()))),
            ),
          ),
        ],
      ),
    );
