import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  const UserItem(
      {required this.avatar,
      required this.name,
      required this.rollNo,
      required this.course,
      required this.branch,
      required this.phone,
      super.key});
  final String avatar;
  final String name;
  final String rollNo;
  final String course;
  final String branch;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(avatar),
        ),
        title: Text(name),
        subtitle: Text("$course ($branch)"),
      ),
    );
  }
}
