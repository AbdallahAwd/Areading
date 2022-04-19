import 'package:areading/transliations/locale_keys.g.dart';
import 'package:areading/views/Home/home_layer.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/log/login.dart';
import 'package:areading/views/log/signup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../bloc/log/login_cubit.dart';
import '../../bloc/log/login_states.dart';
import '../../shared/components/components.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
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
        if (state is LoginStateSuccess) {
          navigateAndRemove(
              context, PageTransitionType.rightToLeft, const HomeLayer());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                AnimatedBuilder(
                    animation: _controller!,
                    builder: (_, child) {
                      return Transform.rotate(
                          angle: _controller!.value * 2 * 3.14, child: child);
                    },
                    child: Image.asset('assets/images/logo.png')),
                Align(
                  alignment: context.deviceLocale == const Locale('ar')
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.welcome.tr(),
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      color: mainColor[index],
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: false,
                  ),
                ),
                Align(
                  alignment: context.deviceLocale == const Locale('ar')
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 69,
                        color: mainColor[index],
                      ),
                      children: const [
                        TextSpan(
                          text: 'A',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'reading',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    softWrap: false,
                  ),
                ),
                const Spacer(),
                defaultButton(
                  onPressed: () {
                    navigateTo(context, PageTransitionType.bottomToTop, Login(),
                        deuration: 250);
                  },
                  colors: mainColor[index],
                  textButton: LocaleKeys.login.tr(),
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultButton(
                    colors: Colors.white,
                    fontSize: 16,
                    textColor: Colors.black.withOpacity(0.5),
                    imageIcon: 'assets/images/google.png',
                    splashColor: mainColor[index],
                    onPressed: () {
                      LoginCubit.get(context).googleLogIn();
                    },
                    textButton: LocaleKeys.login_google.tr()),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      LocaleKeys.no_account.tr(),
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
                        color: mainColor[index],
                      ),
                      softWrap: false,
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                            context, PageTransitionType.bottomToTop, Signup());
                      },
                      child: Text(
                        LocaleKeys.signup.tr(),
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: Color(0xff486b89),
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
        );
      },
    );
  }
}
