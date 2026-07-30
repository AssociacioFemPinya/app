import 'package:flutter/material.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';

class UserProfileSectionPropertyWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, String Function(UserProfileEntity user)> properties;
  final UserProfileEntity user;

  const UserProfileSectionPropertyWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.properties,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: properties.entries.map((entry) {
          final value = entry.value(user);
          return ListTile(
            title: Text(entry.key),
            subtitle: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
