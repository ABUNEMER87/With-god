import 'package:flutter/material.dart';

class IconHeaderScreen extends StatefulWidget {
  const IconHeaderScreen({super.key, required this.numText, this.onTap});
  final String numText;
  final void Function()? onTap;
  @override
  State<IconHeaderScreen> createState() => _IconHeaderScreenState();
}

class _IconHeaderScreenState extends State<IconHeaderScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(widget.numText),
      ),
    );
  }
}
