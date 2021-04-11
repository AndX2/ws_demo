import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ws_demo/ui/widget/screen_back.dart';
import 'package:ws_demo/util/style.dart';
import 'package:ws_demo/util/ui_util.dart';

const _side = 8.0;
const _strokeWidth = 1.0;

class ChannelHeaderWidget extends StatelessWidget {
  final Widget child;

  const ChannelHeaderWidget({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: _RoomHeaderClipper(),
            child: ScreenBackWidget(
              child: Container(),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _RoomHeaderPainter(),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, MediaQuery.of(context).padding.top, 16.0, 8.0),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  if (kIsWeb)
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: context.sw600 ? 24.0 : 32.0,
                        color: ColorRes.textRed,
                      ),
                    ),
                  if (!kIsWeb) SizedBox(width: 8.0),
                  SizedBox(height: 56.0),
                  Expanded(child: child),
                ],
              )),
        ),
      ],
    );
  }

  static Path getPath(Size size) {
    final path = Path();
    path
      ..lineTo(0.0, size.height)
      ..lineTo(size.width * .3, size.height)
      ..lineTo(size.width * .3 + _side, size.height - _side)
      ..lineTo(size.width, size.height - _side)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  static Path getPathPainter(Size size) {
    final path = Path();
    path
      ..moveTo(0.0, size.height)
      ..lineTo(size.width * .3, size.height)
      ..lineTo(size.width * .3 + _side, size.height - _side)
      ..lineTo(size.width, size.height - _side);
    return path;
  }
}

class _RoomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => ChannelHeaderWidget.getPath(size);

  @override
  bool shouldReclip(_RoomHeaderClipper oldClipper) => false;
}

class _RoomHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorRes.textRed
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    final path = ChannelHeaderWidget.getPathPainter(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RoomHeaderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_RoomHeaderPainter oldDelegate) => false;
}
