import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:classmate/models/user.dart';
import 'package:image_picker/image_picker.dart';

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _phoneController = TextEditingController();
  Course? _selectedCourse;
  Branch? _selectedBranch;
  File? _image;
  final picker = ImagePicker();

  void _presentCourse(value) {
    setState(() {
      _selectedCourse = value;
    });
  }

  void _presentBranch(value) {
    setState(() {
      _selectedBranch = value;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future _showOptions() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _getImageFromCamera();
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _getImageFromGallery();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Please fill all the fields'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewClassMate() async {
    final name = _nameController.text;
    final rollNo = _rollNoController.text;
    final course = _selectedCourse;
    final branch = _selectedBranch;
    final phone = _phoneController.text;
    final image = _image;

    if (name.isEmpty ||
        rollNo.isEmpty ||
        phone.isEmpty ||
        phone.length != 10 ||
        image.toString().isEmpty ||
        course == null ||
        branch == null) {
      _showErrorDialog();
    } else {
      final newUser = Student(
        name: _nameController.text,
        rollNo: _rollNoController.text,
        course: _selectedCourse!,
        branch: _selectedBranch!,
        phone: _phoneController.text,
        image: _image!.path,
      );
      print(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FirebaseStorage storage = FirebaseStorage.instance;

    Future<Uri> uploadPic() async {
      var location;
      Reference reference =
          storage.ref().child("classmates/" + DateTime.now().toString());
      UploadTask uploadTask = reference.putFile(_image!);
      uploadTask
          .whenComplete(() => {location = reference.getDownloadURL()})
          .catchError((onError) {
        print(onError);
      });
      return location;
    }

    Future<void> addNewClassMate() {
      final img_url = uploadPic();
      print(img_url);
      return users.add({
        'name': _nameController.text,
        'rollNo': _rollNoController.text,
        'course': _selectedCourse!.name.toString(),
        'branch': _selectedBranch!.name.toString(),
        'phone': _phoneController.text,
        'image': img_url,
        'password': _rollNoController.text
      }).then((value) {
        print("User Added");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Added'),
          ),
        );
        Navigator.of(context).pop();
      }).catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: _image == null
                    ? const AssetImage('assets/images/avatar.png')
                    : FileImage(_image!) as ImageProvider<Object>?,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: _showOptions,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 24,
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _rollNoController,
                decoration: const InputDecoration(
                  labelText: 'Roll No',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedCourse,
                    hint: _selectedCourse == null
                        ? const Text("Select Course")
                        : Text(_selectedCourse!.name.toString()),
                    items: Course.values
                        .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(course.name.toString()),
                            ))
                        .toList(),
                    onChanged: _presentCourse,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedBranch,
                    hint: _selectedBranch == null
                        ? const Text("Select Branch")
                        : Text(_selectedBranch!.name.toString()),
                    items: Branch.values
                        .map((branch) => DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name.toString()),
                            ))
                        .toList(),
                    onChanged: _presentBranch,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addNewClassMate,
                      child: const Text('Add ClassMate'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
