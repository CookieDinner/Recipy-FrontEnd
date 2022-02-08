
import 'package:flutter/material.dart';

class Waves extends StatelessWidget {
  Waves({Key? key, this.color1 = Colors.black, this.color2 = Colors.white}) : super(key: key);

  Color color1;
  Color color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color2,
      child: ClipPath(
        child: Container(
          height: 50,
          color: color1
        ),
        clipper: Clipper(),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => false;
}
