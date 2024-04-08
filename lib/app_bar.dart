import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.white,
    this.leftAvatarImageUrl =
        'https://i.pinimg.com/564x/85/53/5e/85535e2d471e0f036ae4492327581c3e.jpg',
    this.rightAvatarImageUrl =
        'https://i.pinimg.com/236x/1e/56/aa/1e56aa733e30dc0fd59a72182c8a7df9.jpg',
  }) : super(key: key);

  final Color backgroundColor;
  final Color textColor;
  final String leftAvatarImageUrl;
  final String rightAvatarImageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(230, 98, 196, 221),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(leftAvatarImageUrl),
                  ),
                  Text(
                    'Jacke Nail',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(rightAvatarImageUrl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
