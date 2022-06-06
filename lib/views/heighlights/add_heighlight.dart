import 'package:areading/Ads/reworded_ad.dart';
import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/Books/model/book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Ads/done_ad.dart';
import '../../bloc/home/home_states.dart';
import '../../transliations/locale_keys.g.dart';

// ignore: must_be_immutable
class AddHeighlight extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final scannedText;
  const AddHeighlight({Key? key, this.scannedText}) : super(key: key);

  @override
  State<AddHeighlight> createState() => _AddHeighlightState();
}

class _AddHeighlightState extends State<AddHeighlight> {
  var heightController = TextEditingController();
  var bookController = TextEditingController();

  bool isSearch = false;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is AddSuccess) {
          Navigator.pop(context);
        }
        if (state is AddError) {
          snackBar(context, LocaleKeys.add_heigh_error.tr());
        }
      },
      builder: (context, state) {
        if (widget.scannedText != null) {
          heightController.text = widget.scannedText;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.add_heigh.tr()),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: heightController,
                    maxLines: 10,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.txtfrom_field_validation.tr();
                      }
                      return null;
                    },
                    maxLength: 320,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        hintText: LocaleKeys.write_txt.tr()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // DropdownButtonHideUnderline(
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //             color: Colors.grey.withOpacity(0.5), width: 1),
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: DropdownButton<String>(
                  //       // value: value ?? 'Lang',
                  //       hint: Padding(
                  //         padding: const EdgeInsets.all(5.0),
                  //         child: Text(
                  //             HomeCubit.get(context).dropValue ?? 'Private'),
                  //       ),
                  //       items: const [
                  //         DropdownMenuItem(
                  //           child: Text('Private'),
                  //           value: 'Private',
                  //         ),
                  //         DropdownMenuItem(
                  //           child: Text('Public'),
                  //           value: 'Public',
                  //         ),
                  //       ],
                  //       onChanged: (String? val) {
                  //         HomeCubit.get(context).changeDropValue(val);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultTextFormFeild(
                      controller: bookController,
                      pre: HomeCubit.get(context).bookImage != null
                          ? Image.network(
                              HomeCubit.get(context).bookImage!,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, ob, st) {
                                return Image.asset(
                                  'assets/images/noBook.jpg',
                                  width: 50,
                                  height: 50,
                                );
                              },
                            )
                          : const Icon(Icons.menu_book_rounded),
                      labelText: LocaleKeys.book_name.tr(),
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.book_validation.tr();
                        }
                        return null;
                      },
                      suff: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          LocaleKeys.none.tr(),
                          style: TextStyle(color: mainColor[index]),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      suffPress: () {
                        HomeCubit.get(context).bookAuthor = LocaleKeys.me.tr();
                        HomeCubit.get(context).bookName =
                            LocaleKeys.unknown.tr();
                        HomeCubit.get(context).bookImage =
                            'https://www.forewordreviews.com/books/covers/traveling-light.jpg';

                        if (heightController.text.isNotEmpty) {
                          HomeCubit.get(context)
                              .addHeighLight(text: heightController.text);
                          pop(context);
                          AdReworded.showAd();
                        } else {
                          snackBar(context, LocaleKeys.add_txt_save.tr());
                        }
                      },
                      onChange: (value) {
                        setState(() {
                          isSearch = true;
                        });
                        HomeCubit.get(context).getSearchBooks(value);
                      },
                      keyType: TextInputType.name),
                  const SizedBox(
                    height: 10,
                  ),
                  isSearch
                      ? SizedBox(
                          height: 250,
                          child: state is! GetBooksSuccess
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : ListView.separated(
                                  itemBuilder: (context, index) {
                                    return HomeCubit.get(context)
                                                .searchModel!
                                                .items ==
                                            null
                                        ? const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          )
                                        : searchBookBuilder(
                                            HomeCubit.get(context)
                                                .searchModel!
                                                .items![index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                        child:
                                            Divider(height: 1, thickness: 1.1),
                                      ),
                                  itemCount: HomeCubit.get(context)
                                      .searchModel!
                                      .items!
                                      .length),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            state is AddLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : defaultButton(
                    colors: mainColor[index],
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        HomeCubit.get(context)
                            .addHeighLight(text: heightController.text);
                        HomeCubit.get(context).searchModel = null;
                        DoneAd.showDoneAd();
                      }
                    },
                    borderRadius: 10,
                    height: 50,
                    textButton: LocaleKeys.done.tr())
          ],
        );
      },
    );
  }

  Widget searchBookBuilder(Items model) {
    return InkWell(
      onTap: () {
        setState(() {
          isSearch = false;
          bookController.text = model.volumeInfo!.title!;
        });
        HomeCubit.get(context).bookAuthor =
            model.volumeInfo?.authors?[0] ?? 'Unknown';
        HomeCubit.get(context).bookImage = model
                .volumeInfo!.imageLinks?.thumbnail ??
            'https://www.forewordreviews.com/books/covers/traveling-light.jpg';
        HomeCubit.get(context).bookName = model.volumeInfo!.title ?? 'Unknown';
      },
      child: Row(
        children: [
          Image.network(
            model.volumeInfo!.imageLinks?.smallThumbnail ??
                'https://www.forewordreviews.com/books/covers/traveling-light.jpg',
            width: 60,
            height: 60,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.volumeInfo!.title!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model.volumeInfo?.authors?[0] ?? 'Unknown',
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
