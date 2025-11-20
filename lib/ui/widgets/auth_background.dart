import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFADD8E6 ), Color(0xFF87CEEB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _TopWaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 18,
          top: 42,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, color: Colors.black54),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 50);
    path.quadraticBezierTo(size.width * 0.75, size.height - 90, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
