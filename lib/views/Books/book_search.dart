import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/Books/books.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home/home_states.dart';
import '../../transliations/locale_keys.g.dart';

// ignore: must_be_immutable
class BookSearch extends StatelessWidget {
  var searchController = TextEditingController();

  BookSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: SizedBox(
              height: 50,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor[index]),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor[index]),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.search),
                    hintText: LocaleKeys.search.tr()),
                onFieldSubmitted: (value) async {
                  HomeCubit.get(context).recentSearch.add(value);
                  await CacheHelper.setStrings(
                      'search', HomeCubit.get(context).recentSearch);
                  HomeCubit.get(context).getSearchBooks(searchController.text);
                },
              ),
            ),
          ),
          body: state is! GetBooksLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: HomeCubit.get(context).searchModel == null
                      ? ListView(
                          children: [
                            Text(
                              LocaleKeys.recent_search.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      searchController.text =
                                          HomeCubit.get(context)
                                              .recentSearch[index];
                                      HomeCubit.get(context).getSearchBooks(
                                          searchController.text);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        HomeCubit.get(context)
                                            .recentSearch[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemCount:
                                    HomeCubit.get(context).recentSearch.length)
                          ],
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => categoryBuilder(
                              HomeCubit.get(context).searchModel!.items![index],
                              context),
                          separatorBuilder: (context, index) => const SizedBox(
                              height: 20, child: Divider(height: 1)),
                          itemCount: 5),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
