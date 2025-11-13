// @dart=2.12
//import 'package:flutter/foundation.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AndroidBottomActionSheet extends StatelessWidget {
  final Widget? title;
  final Widget? message;
  final List<Widget>? actions;

  const AndroidBottomActionSheet({
    Key? key,
    this.title,
    this.message,
    this.actions,
  })  : assert(
            actions != null || title != null || message != null,
            'An action sheet must have a non-null value for at least one of the following arguments: '
            'actions, title, message, or cancelButton'),
        super(key: key);

  @override
  build(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildContent(context),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = <Widget>[];

    if (title != null || message != null) {
      final titleChildren = <Widget>[];

      if (title != null) {
        titleChildren.add(Container(child: title));
      }
      if (title != null && message != null) {
        titleChildren.add(SizedBox(height: 8));
      }
      if (message != null) {
        titleChildren.add(Container(child: message));
      }

      final titleSection = Container(
        margin: EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: titleChildren,
        ),
      );

      content.add(Flexible(child: titleSection));
    }

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }

  Widget _buildActions() {
    if (actions == null || actions!.isEmpty) {
      return Container(
        height: 0.0,
      );
    }
    return Container(
      child: Column(
        children: actions!,
      ),
    );
  }
}

class AndroidBottomActionSheetAction extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AndroidBottomActionSheetAction({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  build(context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 56,
        ),
        child: Semantics(
          button: true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
