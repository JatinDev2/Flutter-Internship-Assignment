import 'package:hive/hive.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final int salary;

  @HiveField(4)
  final String? profileImage;

  Employee({
    required this.id,
    required this.name,
    required this.age,
    required this.salary,
    this.profileImage,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      name: json['employee_name'] as String,
      age: json['employee_age'] as int,
      salary: json['employee_salary'] as int,
      profileImage: json['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'salary': salary,
      'profile_image': profileImage ?? '',
    };
  }
}
