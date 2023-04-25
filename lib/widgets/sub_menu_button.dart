import 'package:flutter/material.dart';

class SubMenuButton extends StatefulWidget {
  const SubMenuButton({super.key, required this.title, this.onPressed, this.disabled = false});
  final Widget title;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  State<SubMenuButton> createState() => _SubMenuButtonState();
}

class _SubMenuButtonState extends State<SubMenuButton> {
  @override
  Widget build(BuildContext context) {
    var title = widget.title;
    var disabled = widget.disabled;
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              padding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 2,
            ),
            onPressed: disabled ? null : widget.onPressed,
            child: ListTile(
                title: title,
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ))));
  }
}
