import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UiIconButton extends StatelessWidget {
  final void Function()? onClick;
  final Widget icon;
  final Widget child;

  const UiIconButton({
    this.onClick,
    required this.icon,
    required this.child,
  });

  @override
  build(context) {
    return InkWell(
      onTap: onClick,
      child: Column(children: [icon, const SizedBox(height: 6), child]),
    );
  }
}
