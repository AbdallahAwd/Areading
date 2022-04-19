import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/bloc/home/home_states.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../custom/my_flutter_app_icons.dart';
import '../../transliations/locale_keys.g.dart';
import '../Books/book_search.dart';

class HomeLayer extends StatelessWidget {
  const HomeLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> title = [
      'Areading',
      LocaleKeys.add_heigh.tr(),
      LocaleKeys.book.tr(),
      LocaleKeys.setting.tr()
    ];
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: cubit.floatIndex == 0
                ? null
                : AppBar(
                    title: Text(
                      title[cubit.floatIndex],
                      style: TextStyle(color: mainColor[index]),
                    ),
                    actions: [
                      cubit.floatIndex == 2
                          ? IconButton(
                              onPressed: () {
                                navigateTo(
                                    context,
                                    PageTransitionType.rightToLeft,
                                    BookSearch());
                              },
                              color: mainColor[index],
                              icon: const Icon(Icons.search),
                            )
                          : const SizedBox()
                    ],
                    bottom: cubit.floatIndex == 3
                        ? TabBar(
                            labelColor: mainColor[index],
                            indicatorColor: mainColor[index],
                            unselectedLabelColor: Colors.grey,
                            labelPadding: const EdgeInsets.all(0),
                            tabs: [
                              Tab(
                                text: LocaleKeys.personal.tr(),
                              ),
                              Tab(
                                text: LocaleKeys.app.tr(),
                              ),
                            ],
                          )
                        : null,
                  ),
            body: RefreshIndicator(
                onRefresh: () async {
                  HomeCubit.get(context).getTopBooks();
                  HomeCubit.get(context).getRandomBooks();
                },
                backgroundColor: mainColor[index],
                color: Colors.white,
                strokeWidth: 3,
                displacement: 10,
                edgeOffset: 0,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                child: cubit.screens[cubit.floatIndex]),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingNavbar(
                onTap: (int val) {
                  cubit.changeFloatindex(val);
                },
                currentIndex: cubit.floatIndex,
                backgroundColor: mainColor[index],
                items: [
                  FloatingNavbarItem(
                      icon: MyIcons.fountain_pen_close_up,
                      title: LocaleKeys.review.tr()),
                  FloatingNavbarItem(
                      icon: Icons.add_circle_outline,
                      title: LocaleKeys.heighlight.tr()),
                  FloatingNavbarItem(
                      icon: Icons.menu_book_rounded,
                      title: LocaleKeys.book.tr()),
                  FloatingNavbarItem(
                      icon: Icons.settings, title: LocaleKeys.setting.tr()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
