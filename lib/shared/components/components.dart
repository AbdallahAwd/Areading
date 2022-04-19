import 'package:areading/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

Widget defaultButton(
        {double width = double.infinity,
        double height = 65,
        required Color colors,
        var textColor = Colors.white,
        double borderRadius = 20,
        var splashColor = Colors.white,
        IconData? icon,
        String? imageIcon,
        required var onPressed,
        required String textButton,
        double fontSize = 30,
        var fontWeight = FontWeight.w600}) =>
    SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            onPrimary: splashColor,
            primary: colors,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                side: const BorderSide(color: Colors.grey, width: 0.5))),
        child: icon != null || imageIcon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == null
                      ? Image.asset(
                          imageIcon!,
                          width: 25,
                          height: 25,
                        )
                      : Icon(icon),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    textButton,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
                    softWrap: false,
                  ),
                ],
              )
            : Text(
                textButton,
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
                softWrap: false,
              ),
      ),
    );

Widget defaultTextFormFeild({
  required TextEditingController controller,
  required Widget pre,
  required String labelText,
  var validate,
  var onChange,
  var onSave,
  Widget? suff,
  bool isObscure = false,
  required TextInputType keyType,
  var suffPress,
  var submit,
  bool? enable,
}) =>
    TextFormField(
      keyboardType: keyType,
      obscureText: isObscure,
      controller: controller,
      onChanged: onChange,
      enabled: enable,
      onSaved: onSave,
      onFieldSubmitted: submit,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: mainColor[index]),
        prefixIcon: pre,
        suffixIcon: InkWell(onTap: suffPress, child: suff),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: mainColor[index])),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: mainColor[index])),
        labelText: labelText,
      ),
      validator: validate,
    );

navigateTo(
  context,
  pageTransition,
  screen, {
  alignment,
  int deuration = 250,
}) {
  return Navigator.push(
      context,
      PageTransition(
          type: pageTransition,
          alignment: alignment,
          child: screen,
          duration: Duration(milliseconds: deuration)));
}

navigateAndRemove(context, pageTransition, screen, {alignment}) {
  return Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: pageTransition,
        alignment: alignment,
        child: screen,
      ),
      (route) => false);
}

pop(context) {
  return Navigator.pop(context);
}

vibrate() {
  return HapticFeedback.lightImpact();
}

toast({required String text, Color color = Colors.grey}) {
  return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget heighlight(context, {String? text, assetName, icons}) => Container(
      decoration: BoxDecoration(
        color: mainColor[index],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(width: 1.0, color: const Color(0xff707070)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text!,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            softWrap: false,
          ),
          assetName == null
              ? Icon(
                  icons,
                  color: Colors.white,
                  size: 30,
                )
              : Image.asset('assets/images/$assetName')
        ],
      ),
    );

Widget addHeigh({
  double size = 50,
  required IconData icon,
  required onPressed,
  required String text,
}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            iconSize: size,
            color: mainColor[index],
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: size,
            )),
        Text(text)
      ],
    );

snackBar(context, String text, {Color color = Colors.red}) {
  var snackBar = SnackBar(
    content: Text(text),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String formattedDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM, dd , yyyy').format(now);
  return formattedDate;
}

Widget dialogButton({IconData? icon, var color = Colors.white, var onTap}) =>
    InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white,
            )));
