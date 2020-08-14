import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData descriptionIcon;
  final String destination;
  const SettingsTile({
    @required this.description,
    @required this.descriptionIcon,
    @required this.title,
    @required this.destination,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(destination);
          },
          leading: Icon(
            descriptionIcon,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
