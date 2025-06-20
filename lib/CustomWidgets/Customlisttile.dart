import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Customlisttile extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final Function onTap;

  const Customlisttile({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  State<Customlisttile> createState() => _CustomlisttileState();
}

class _CustomlisttileState extends State<Customlisttile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap();
      },
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SvgPicture.asset(
          widget.image,
          // height: 20,
          // width: 20,
          // color: Color(0xFF4F4F4F),
        ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Color(0xFF4F4F4F),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        widget.subtitle,
        style: const TextStyle(
          color: Color(0xFF4F4F4F),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
