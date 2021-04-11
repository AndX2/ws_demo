import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/util/style.dart';
import 'package:ws_demo/util/ui_util.dart';

const _facet = 12.0;
const _side = 4.0;
const _offset = 6.0;
const _strokeWidth = 1.0;
const _paddingMain = EdgeInsets.only(left: 96.0, top: 16.0);
const _paddingOther = EdgeInsets.only(right: 96.0, top: 16.0);

/// Виджет ссобщения в чате
class ChatMessageWidget extends StatelessWidget {
  final Message message;
  final ChatMessageOwner owner;

  const ChatMessageWidget.mine({Key key, this.message})
      : owner = ChatMessageOwner.mine,
        super(key: key);

  const ChatMessageWidget({Key key, this.message, this.owner}) : super(key: key);

  const ChatMessageWidget.other({Key key, this.message})
      : owner = ChatMessageOwner.other,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: owner == ChatMessageOwner.mine ? _paddingMain : _paddingOther,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _ChatMessageClipper(owner),
              child: Container(
                  color: owner == ChatMessageOwner.mine
                      ? ColorRes.msgBackBlue
                      : ColorRes.msgBackYellow),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _ChatMessagePainter(owner),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (owner != ChatMessageOwner.mine)
                  Text(
                    '${message.owner.ownerName}:',
                    style: context.sp(
                        StyleRes.content24Yellow.copyWith(decoration: TextDecoration.underline)),
                  ),
                SelectableText(
                  message.body,
                  style: context.sp(owner == ChatMessageOwner.mine
                      ? StyleRes.content24Blue
                      : StyleRes.content24Yellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Path getPath(Size size, ChatMessageOwner owner) {
    final path = Path();
    switch (owner) {
      case ChatMessageOwner.mine:
        path
          ..moveTo(_side, 0.0)
          ..lineTo(size.width - _offset, 0.0)
          ..lineTo(size.width - _offset, size.height - _offset)
          ..lineTo(size.width, size.height)
          ..lineTo(_facet, size.height)
          ..lineTo(0.0, size.height - _facet)
          ..lineTo(0.0, size.height * .5)
          ..lineTo(_side, size.height * .5 - _side)
          ..close();
        break;
      case ChatMessageOwner.other:
        path
          ..moveTo(0.0, size.height)
          ..lineTo(_offset, size.height - _offset)
          ..lineTo(_offset, 0.0)
          ..lineTo(size.width - _side, 0.0)
          ..lineTo(size.width - _side, size.height * .5 - _side)
          ..lineTo(size.width, size.height * .5)
          ..lineTo(size.width, size.height - _facet)
          ..lineTo(size.width - _facet, size.height)
          ..close();
        break;
      default:
    }
    return path;
  }
}

class _ChatMessageClipper extends CustomClipper<Path> {
  final ChatMessageOwner owner;

  _ChatMessageClipper(this.owner);

  @override
  Path getClip(Size size) => ChatMessageWidget.getPath(size, owner);

  @override
  bool shouldReclip(_ChatMessageClipper oldClipper) => false;
}

class _ChatMessagePainter extends CustomPainter {
  final ChatMessageOwner owner;
  _ChatMessagePainter(this.owner);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = owner == ChatMessageOwner.mine ? ColorRes.textBlue : ColorRes.textYellow
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    final path = ChatMessageWidget.getPath(size, owner);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChatMessagePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_ChatMessagePainter oldDelegate) => false;
}
