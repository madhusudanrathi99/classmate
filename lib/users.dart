import 'package:flutter/material.dart';
import 'package:classmate/user/user_list.dart';
import 'package:classmate/user/new_user.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewUser()));
        },
        child: const Icon(Icons.add),
      ),
      body: const UserList(),
    );
  }
}
