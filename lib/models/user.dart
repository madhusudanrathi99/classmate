import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Course { BTech, MTech, MCA, MSc }

enum Branch { CSE, ECE, EEE, MME }

class Student {
  Student({
    required this.name,
    required this.rollNo,
    required this.course,
    required this.branch,
    required this.phone,
    required this.image,
  }) : id = uuid.v4();

  final String id;
  final String name;
  final String rollNo;
  final Course course;
  final Branch branch;
  final String phone;
  final String image;
}
