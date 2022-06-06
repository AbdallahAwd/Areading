import 'dart:typed_data';

import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/heighlights/models/add.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import '../../Ads/reworded_ad.dart';
import '../../custom/expandable.dart';
import '../../transliations/locale_keys.g.dart';

class GenImage extends StatefulWidget {
  final AddHeighLight model;
  const GenImage({Key? key, required this.model}) : super(key: key);

  @override
  State<GenImage> createState() => _GenImageState();
}

class _GenImageState extends State<GenImage> {
  PaletteColor colors = PaletteColor(mainColor[index], 2);
  Color? pickedColor;
  bool isRendering = false;

  updateColor() async {
    final PaletteGenerator generate = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.model.bookimage!),
    );
    if (generate.lightMutedColor != null) {
      colors = generate.lightMutedColor!;
    } else {
      colors = PaletteColor(mainColor[index], 1);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    preventScreenShot();
    updateColor();
  }

  void preventScreenShot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void allowScreenShot() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    super.dispose();
    allowScreenShot();
  }

  int indexa = 0;
  int textIndex = 0;
  double height = 280;
  double position = 70;
  List<Color> textColor = [
    Colors.black,
    Colors.white,
  ];
  @override
  Widget build(BuildContext context) {
    List<Color> imageColor = [
      colors.color,
      Colors.white,
      Colors.red,
      Colors.indigo,
      Colors.black
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.render_image.tr()),
      ),
      body: HomeCubit.get(context).hasInternet
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: <Widget>[
                  isRendering
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: LinearProgressIndicator(
                            color: mainColor[index],
                          ),
                        )
                      : const SizedBox(),
                  imageBuilder(imageColor: imageColor),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return colorBuilder(imageColor, index, 0);
                      },
                      itemCount: imageColor.length,
                    ),
                  ),
                  TapToExpand(
                    caption: LocaleKeys.customize.tr(),
                    color: imageColor[indexa],
                    index: indexa,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.height.tr(),
                          style: TextStyle(
                            color: indexa == 0 || indexa == 1
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        Slider(
                            thumbColor: Colors.white,
                            activeColor: Colors.grey[600],
                            inactiveColor: Colors.grey[300],
                            max: 360,
                            min: 200,
                            value: height,
                            onChanged: (value) {
                              setState(() {
                                height = value;
                              });
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          LocaleKeys.position.tr(),
                          style: TextStyle(
                            color: indexa == 0 || indexa == 1
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        Slider(
                            thumbColor: Colors.white,
                            activeColor: Colors.grey[600],
                            inactiveColor: Colors.grey[300],
                            max: 100,
                            min: 50,
                            value: position,
                            onChanged: (value) {
                              setState(() {
                                position = value;
                              });
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          LocaleKeys.txt_color.tr(),
                          style: TextStyle(
                            color: indexa == 0 || indexa == 1
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return colorBuilder(textColor, index, 1);
                              },
                              itemCount: textColor.length),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: Text(LocaleKeys.pick_color.tr()),
                          style: ElevatedButton.styleFrom(
                              primary: mainColor[index]),
                          onPressed: () {
                            colorDialog(imageColor);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
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
            ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            defaultButton(
                width: 150,
                fontSize: 18,
                borderRadius: 10,
                height: 50,
                colors: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  pop(context);
                },
                textButton: LocaleKeys.cancel.tr()),
            defaultButton(
                width: 150,
                fontSize: 18,
                height: 50,
                borderRadius: 10,
                colors: mainColor[index],
                textColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    isRendering = true;
                  });

                  final controller = ScreenshotController();
                  final bytes = await controller.captureFromWidget(
                      Material(child: imageBuilder(imageColor: imageColor)));
                  saveImage(bytes, 'Areading' + DateTime.now().toString());
                  AdReworded.showAd();
                  pop(context);
                },
                textButton: LocaleKeys.save.tr()),
          ],
        )
      ],
    );
  }

  Future<String> saveImage(Uint8List bytes, String name) async {
    await Permission.storage.isDenied
        ? await [Permission.storage].request()
        : null;
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  Widget colorBuilder(List<Color> imageColor, index, int arra) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              arra == 0 ? indexa = index : textIndex = index;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: imageColor[index],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      );

  Widget imageBuilder({List<Color>? imageColor}) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Container(
          width: 385,
          // widget.model.text!.length > 250 ? 350 : 280
          height: height,
          padding: const EdgeInsets.only(left: 20, bottom: 8, right: 8, top: 8),
          color: pickedColor ?? imageColor![indexa],
          child: Stack(
            children: <Widget>[
              Positioned(
                right: position,
                child: Text('،،',
                    style: TextStyle(
                      color: textColor[textIndex],
                      fontSize: 50,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                      angle: 0.33,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5)),
                        child: Image.network(
                          widget.model.bookimage!,
                          errorBuilder: ((context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/noBook.jpg',
                              width: 90,
                            );
                          }),
                          width: 90,
                        ),
                      )),
                ),
              ),
              Positioned(
                // widget.model.text!.length < 100 ? 80 : 60
                top: position,
                child: SizedBox(
                  width: 260,
                  child: Container(
                    margin: const EdgeInsets.only(right: 25),
                    child: AutoSizeText(
                      widget.model.text!,
                      textDirection: context.locale == const Locale('ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyle(
                          height: 1.1,
                          fontSize: 18,
                          color: textColor[textIndex],
                          fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 2,
                    color: textColor[textIndex],
                    endIndent: 200,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.model.bookauthor!,
                    style: TextStyle(
                      color: textColor[textIndex],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget buildColorPicker(imageColor) {
    return ColorPicker(
        pickerColor: pickedColor ?? imageColor[indexa],
        onColorChanged: (color) {
          pickedColor = color;
        });
  }

  colorDialog(List<Color> imageColor) {
    Dialog dialog = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Pick Color'),
            const SizedBox(
              height: 10,
            ),
            buildColorPicker(imageColor),
            TextButton(
                onPressed: () {
                  pop(context);

                  setState(() {});
                },
                child: const Text('Select'))
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
