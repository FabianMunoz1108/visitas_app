import 'package:flutter/cupertino.dart';

class CustomNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomNavigationButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: child,
    );
  }
}