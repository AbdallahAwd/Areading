// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:areading/views/Home/home_layer.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/views/log/signup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/log/login_cubit.dart';
import '../../bloc/log/login_states.dart';
import '../../themes/colors.dart';
import '../../transliations/locale_keys.g.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

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
      listener: (BuildContext context, state) {
        if (state is LoginStateError) {
          var snackBar = SnackBar(
            content: Text(state.error.substring(31)),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is LoginStateSuccess) {
          toast(text: LocaleKeys.login_success.tr());
          navigateAndRemove(
              context, PageTransitionType.rightToLeft, const HomeLayer());
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
              child: FadeTransition(
            opacity: _animation!,
            alwaysIncludeSemantics: true,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    // physics: const BouncingScrollPhysics(),
                    children: [
                      Image.asset('assets/images/login.png'),
                      const SizedBox(
                        height: 50,
                      ),
                      // defaultTextFormFeild(
                      //   controller: emailController,
                      //   pre: Icons.email,
                      //   validate: (String? value) {
                      //     if (value!.isEmpty ||
                      //         !value.contains('@') ||
                      //         !value.contains('.')) {
                      //       return 'Enter a valid Email';
                      //     }
                      //     return null;
                      //   },
                      //   labelText: 'Email',
                      //   keyType: TextInputType.emailAddress,
                      // ),
                      textForm(
                        label: LocaleKeys.email.tr(),
                        icon: Icons.email_outlined,
                        keytype: TextInputType.emailAddress,
                        controller: emailController,
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
                          controller: passwordController,
                          validate: (String? value) {
                            if (value!.length < 8) {
                              return LocaleKeys.password_validation.tr();
                            }
                            return null;
                          },
                          icon: Icons.lock,
                          keytype: TextInputType.visiblePassword,
                          isPassword: true),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            navigateTo(context, PageTransitionType.rightToLeft,
                                ForgetPassword());
                          },
                          child: Text(
                            LocaleKeys.forget_pass.tr(),
                            style: const TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 15,
                              color: Color(0xff707070),
                            ),
                            softWrap: false,
                          ),
                        ),
                      ),
                      state is LoginStateLoading
                          ? LinearProgressIndicator(
                              color: mainColor[index],
                            )
                          : defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).logIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              colors: mainColor[index],
                              textButton: LocaleKeys.login.tr(),
                            ),
                      Row(
                        children: [
                          Text(
                            LocaleKeys.no_account.tr(),
                            style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16,
                                color: Color(0xff707070)),
                            softWrap: false,
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context,
                                  PageTransitionType.rightToLeft, Signup());
                            },
                            child: Text(
                              LocaleKeys.signup.tr(),
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16,
                                color: mainColor[index],
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: false,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}

Widget textForm(
        {IconData icon = Icons.person,
        required String label,
        required TextInputType keytype,
        required var validate,
        required TextEditingController controller,
        bool isPassword = false}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: keytype,
      validator: validate,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: mainColor[index]),
        prefixIcon: Icon(icon, color: mainColor[index]),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: mainColor[index])),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: mainColor[index])),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: mainColor[index])),
        labelText: label,
      ),
    );
