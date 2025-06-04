import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  // Constructor for UserTile widget
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align children at the start
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the cross axis
          children: [
            Icon(Icons.person), // An icon next to the text
            SizedBox(width: 10), // Space between icon and text
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
