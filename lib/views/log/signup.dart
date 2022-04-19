// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:areading/bloc/log/login_cubit.dart';
import 'package:areading/views/log/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../transliations/locale_keys.g.dart';
import '../Home/home_layer.dart';
import '../../bloc/log/login_states.dart';
import '../../shared/components/components.dart';
import '../../themes/colors.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var nameController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  AnimationController? _controller;
  Animation<double>? _animation;
  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..animateTo(1);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginStateError) {
          var snackBar = SnackBar(
            content: Text(state.error.substring(36)),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is LoginStateSuccess) {
          toast(text: LocaleKeys.login_success.tr());
          navigateAndRemove(
              context, PageTransitionType.rightToLeft, const HomeLayer());
        }
        if (state is SaveUserDataError) {
          var snackBar = SnackBar(
            content: Text(state.error.substring(30)),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: FadeTransition(
              opacity: _animation!,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Image.asset('assets/images/signUp.png'),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        LocaleKeys.signup.tr(),
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 30,
                        ),
                        softWrap: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      textForm(
                        label: LocaleKeys.name.tr(),
                        controller: nameController,
                        icon: Icons.person,
                        keytype: TextInputType.name,
                        validate: (String? value) {
                          if (value!.length < 4) {
                            return LocaleKeys.name_validation.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textForm(
                        label: LocaleKeys.email.tr(),
                        controller: emailController,
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
                      textForm(
                          label: LocaleKeys.password.tr(),
                          icon: Icons.lock,
                          controller: passwordController,
                          keytype: TextInputType.visiblePassword,
                          validate: (String? value) {
                            if (value!.length < 8) {
                              return LocaleKeys.password_validation.tr();
                            }
                            return null;
                          },
                          isPassword: true),
                      const SizedBox(
                        height: 20,
                      ),
                      state is LoginStateLoading
                          ? const LinearProgressIndicator()
                          : defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).signIn(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              colors: mainColor[index],
                              textButton: LocaleKeys.signup.tr().toUpperCase(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
