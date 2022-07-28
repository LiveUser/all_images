import 'package:flutter/material.dart';

class LoadingThingy extends StatelessWidget {
  const LoadingThingy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}
class CircularButton extends StatelessWidget {
  const CircularButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  final IconData icon;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 20,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}