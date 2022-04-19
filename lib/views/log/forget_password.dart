// ignore_for_file: must_be_immutable

import 'package:areading/bloc/log/login_cubit.dart';
import 'package:areading/views/log/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../themes/colors.dart';
import '../../transliations/locale_keys.g.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);
  var forgetPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            children: [
              Image.asset('assets/images/forget.png'),
              const SizedBox(
                height: 50,
              ),
              Text(
                LocaleKeys.forget_password_txt.tr(),
                style: const TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 15,
                  color: Color.fromARGB(255, 40, 83, 134),
                ),
                textAlign: TextAlign.center,
                softWrap: false,
              ),
              const SizedBox(
                height: 50,
              ),
              textForm(
                label: LocaleKeys.email.tr(),
                controller: forgetPasswordController,
                icon: Icons.email_outlined,
                keytype: TextInputType.emailAddress,
                validate: (String? value) {
                  if (value!.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return LocaleKeys.email_validation.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              defaultButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    LoginCubit.get(context)
                        .resetPassword(forgetPasswordController.text.trim());
                    pop(context);
                  }
                },
                colors: mainColor[index],
                textButton: LocaleKeys.send.tr().toUpperCase(),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
