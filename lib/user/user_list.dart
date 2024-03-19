import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:classmate/user/user_item.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading"));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (ctx, index) => UserItem(
            avatar: snapshot.data!.docs[index]['avatar'].toString().isEmpty
                ? 'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png'
                : snapshot.data!.docs[index]['avatar'],
            name: snapshot.data!.docs[index]['name'],
            rollNo: snapshot.data!.docs[index]['rollNo'],
            course: snapshot.data!.docs[index]['course'],
            branch: snapshot.data!.docs[index]['branch'],
            phone: snapshot.data!.docs[index]['phone'],
          ),
        );
      },
    );
  }
}
