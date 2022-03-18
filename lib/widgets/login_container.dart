import 'package:flutter/material.dart';
import 'package:products_app/theme/app_theme.dart';

class LoginContainer extends StatelessWidget {

  final Widget child;

  const LoginContainer({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [

          const _PurpleBackground(),

          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              width: double.infinity,
              child: const Icon(Icons.person_pin_rounded, size: 80),
            ),
          ),

          child
          
        ]
      ),
    );
  }
}

class _PurpleBackground extends StatelessWidget {
  const _PurpleBackground({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    const BoxDecoration boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.primaryColor,
          AppTheme.secondaryColor
        ]
      ),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))
    );

    return Stack(
      children: [
        Container(
          height: size.height * .4,
          width: double.infinity,
          decoration: boxDecoration 
        ),

        const Positioned(child: _Bubble(), top: -50, left: 50),
        const Positioned(child: _Bubble(), bottom: -50, right: -50),
        const Positioned(child: _Bubble(), top: 150, right: 50),
        const Positioned(child: _Bubble(), bottom: 100, left: 80),
        const Positioned(child: _Triangle(), bottom: 250, left: 180),
        const Positioned(child: _Triangle(), bottom: 60, left: 280),
        const Positioned(child: _Triangle(), top: -50, right: -50),


      ]
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white10
      ),
    );
  }
}

class _Triangle extends StatelessWidget {
  const _Triangle({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(100, 100), painter: DrawTriangle());
  }
}

class DrawTriangle extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white24);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}