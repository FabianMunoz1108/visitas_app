import 'package:flutter/cupertino.dart';

/// Botón de navegación personalizado
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

/// Campo de texto de búsqueda personalizado
class CustomSearchTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String placeholder;

  const CustomSearchTextField({
    required this.onChanged,
    required this.placeholder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CupertinoSearchTextField(
        onChanged: onChanged,
        placeholder: placeholder,
      ),
    );
  }
}
