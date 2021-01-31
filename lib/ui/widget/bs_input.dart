import 'package:flutter/material.dart';
import 'package:ws_demo/ui/widget/primary_btn.dart';
import 'package:ws_demo/util/style.dart';
import 'package:ws_demo/util/ui_util.dart';

const _fabDeck = 80.0;
const _facet = 24.0;
const _side = 32.0;
const _shift = 8.0;

/// BottomSheet текстового ввода (имя, название зоздаваемого канала)
class BsContent extends StatelessWidget {
  final TextEditingController textEditingController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;
  final String hint;

  const BsContent({
    Key key,
    this.textEditingController,
    this.formKey,
    this.onPressed,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: _BsClipper(),
          child: Container(
            height: 240.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .5, 1.0],
                colors: [
                  ColorRes.backGradientBegin,
                  ColorRes.backGradientCenter,
                  ColorRes.backGradientEnd,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _BsPainter(),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) => value.length < 3 ? 'нужно больше символов' : null,
                      controller: textEditingController,
                      autofocus: true,
                      style: context.sp(StyleRes.content40Blue),
                      textAlign: TextAlign.center,
                      cursorColor: ColorRes.textBlue,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: context.sp(StyleRes.content24Blue.copyWith(color: ColorRes.msgBackBlue)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                PrimaryBtn(
                  padding: const EdgeInsets.fromLTRB(40.0, 12.0, 24.0, 6.0),
                  onPressed: onPressed,
                  child: Text(
                    'Принять',
                    style: context.sp(StyleRes.head36Red),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _BsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0.0, _facet)
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, _side)
      ..lineTo(size.width - _fabDeck, _side)
      ..lineTo(size.width - _fabDeck - _side, 0.0)
      ..lineTo(_facet, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _BsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = ColorRes.textRed;
    final path = Path()
      ..moveTo(size.width, _side)
      ..lineTo(size.width - _fabDeck, _side)
      ..lineTo(size.width - _fabDeck - _side, 0.0)
      ..lineTo(_facet, 0.0)
      ..lineTo(0.0, _facet);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BsPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_BsPainter oldDelegate) => false;
}
