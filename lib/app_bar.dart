import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.leftAvatarImageUrl =
        'https://i.pinimg.com/736x/d5/8a/f4/d58af48f25d5a8df2854463c83e2f2e8.jpg',
    this.rightAvatarImageUrl,
  }) : super(key: key);

  final Color backgroundColor;
  final Color textColor;
  final String leftAvatarImageUrl;
  final String? rightAvatarImageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          child: Container(
          
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 132, 241, 255),
                  Color.fromARGB(255, 250, 250, 250),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(58, 68, 68, 68).withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  // Avatar izquierdo
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(leftAvatarImageUrl),
                  ),
                  // Spacer para empujar el texto hacia la izquierda
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 75.0), // Ajusta el espacio entre el avatar y el texto
                        Text(
                          'Jake Nails',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar derecho (opcional)
                  if (rightAvatarImageUrl != null)
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(rightAvatarImageUrl!),
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
