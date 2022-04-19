import 'package:flutter/material.dart';

class TapToExpand extends StatefulWidget {
  final Widget body;
  final String caption;
  final Color color;
  final int index;
  const TapToExpand({
    Key? key,
    required this.body,
    required this.caption,
    required this.color,
    required this.index,
  }) : super(key: key);
  @override
  _TapToExpandState createState() => _TapToExpandState();
}

class _TapToExpandState extends State<TapToExpand> {
  bool isExpanded = true;
  bool isExpanded2 = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
          horizontal: isExpanded ? 25 : 0,
          vertical: 20,
        ),
        padding: const EdgeInsets.all(20),
        height: isExpanded ? 70 : 250,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1200),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20,
              offset: Offset(5, 10),
            ),
          ],
          color: widget.color,
          borderRadius: BorderRadius.all(
            Radius.circular(isExpanded ? 20 : 0),
          ),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.caption,
                  style: TextStyle(
                    color: widget.index == 0 || widget.index == 1
                        ? Colors.black
                        : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 27,
                ),
              ],
            ),
            isExpanded ? const SizedBox() : const SizedBox(height: 20),
            AnimatedCrossFade(
              firstChild: const Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
              secondChild: widget.body,
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 1200),
              reverseDuration: Duration.zero,
              sizeCurve: Curves.fastLinearToSlowEaseIn,
            ),
          ],
        ),
      ),
    );
  }
}
