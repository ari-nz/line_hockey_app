import 'package:flutter/material.dart';

class Line extends StatefulWidget {
  final Offset _start;
  final Offset _end;

  Line(this._start, this._end);

  @override
  State<StatefulWidget> createState() => _LineState(_start, _end);


}

class _LineState extends State<Line> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Offset _start;
  Offset _end;
  Animation<double> animation;

  _LineState(Offset start, Offset end) {
    _start = start;
    _end = end;
  }

  @override
  void initState() {
    super.initState();
    var controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _progress = animation.value;
        });
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LinePainter(_progress, _start, _end));
  }
}

class LinePainter extends CustomPainter {
  Paint _paint;
  double _progress;
  Offset _start;
  Offset _end;

  LinePainter(this._progress, this._start, this._end) {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(_start, Offset(_start.dx + ((_end.dx - _start.dx) * _progress), _start.dy + ((_end.dy - _start.dy) * _progress) ), _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}