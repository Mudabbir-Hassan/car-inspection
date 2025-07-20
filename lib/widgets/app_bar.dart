import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.subtitle,
      this.actions,
      this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF00BFA6)),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(Icons.directions_car,
                      color: Theme.of(context).colorScheme.secondary, size: 28),
                ),
          title: Column(
            children: [
              Text(title),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF00BFA6)),
                ),
            ],
          ),
          centerTitle: true,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
