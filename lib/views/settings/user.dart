import 'package:areading/bloc/setting/setting.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/views/log/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/setting/setting_states.dart';
import '../../themes/colors.dart';
import '../../transliations/locale_keys.g.dart';

// ignore: must_be_immutable
class Users extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Users({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        SettingCubit cubit = SettingCubit.get(context);
        if (state is GetUserLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                setBuilder(
                  field: LocaleKeys.name.tr(),
                  onTap: () {
                    nameController.text = cubit.model.name!;
                    showBottomSheet(context);
                  },
                  fieldValue: cubit.model.name!,
                  prefixIcon: Icons.person,
                  icon: Icons.edit,
                ),
                const SizedBox(
                  height: 50,
                ),
                setBuilder(
                  field: LocaleKeys.email.tr(),
                  prefixIcon: Icons.email,
                  fieldValue: cubit.model.email!,
                ),
                const SizedBox(
                  height: 50,
                ),
                setBuilder(
                    field: LocaleKeys.password.tr(),
                    onTap: () {
                      showBottomSheet(context, isPassword: true);
                    },
                    fieldValue: '************',
                    prefixIcon: Icons.lock,
                    icon: Icons.edit)
              ],
            ),
          );
        }
      },
    );
  }

  setBuilder({
    required String field,
    required String fieldValue,
    var onTap,
    IconData? icon,
    required IconData prefixIcon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(prefixIcon, size: 30, color: Colors.grey),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              field,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              fieldValue,
            )
          ],
        ),
        const Spacer(),
        icon == null
            ? const SizedBox()
            : InkWell(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: mainColor[index],
                ),
              )
      ],
    );
  }

  showBottomSheet(
    context, {
    bool isPassword = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Form(
        key: formKey,
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isPassword
                    ? LocaleKeys.change_pass.tr()
                    : LocaleKeys.change_name.tr()),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: textForm(
                      label: isPassword
                          ? LocaleKeys.confirm_email.tr()
                          : LocaleKeys.name.tr(),
                      keytype: isPassword
                          ? TextInputType.emailAddress
                          : TextInputType.name,
                      validate: (String? value) {
                        if (isPassword) {
                          if (SettingCubit.get(context).model.email !=
                              value!.trim()) {
                            return LocaleKeys.confirm_email_validation.tr();
                          }
                          return null;
                        } else {
                          if (value!.isEmpty) {
                            return LocaleKeys.name_validation.tr();
                          }
                          return null;
                        }
                      },
                      icon: isPassword ? Icons.email : Icons.person,
                      controller:
                          isPassword ? emailController : nameController),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    defaultButton(
                        width: 100,
                        height: 40,
                        fontSize: 15,
                        borderRadius: 10,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        colors: Colors.white,
                        onPressed: () {
                          pop(context);
                        },
                        textButton: LocaleKeys.cancel.tr()),
                    defaultButton(
                        width: 100,
                        height: 40,
                        fontSize: 15,
                        borderRadius: 10,
                        fontWeight: FontWeight.w600,
                        colors: mainColor[index],
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (!isPassword) {
                              SettingCubit.get(context).updateNameOrPassword(
                                  nameController.text.trim(),
                                  SettingCubit.get(context).model.email!);
                            } else {
                              SettingCubit.get(context).resetPassword(
                                  SettingCubit.get(context)
                                      .model
                                      .email!
                                      .trim());
                              toast(text: LocaleKeys.send_email.tr());
                            }
                            pop(context);
                          }
                        },
                        textButton: LocaleKeys.save.tr()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
