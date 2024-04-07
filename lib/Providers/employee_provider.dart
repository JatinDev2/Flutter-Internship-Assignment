import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quantmhill_assignment/Models/employee_model.dart';

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _formError = '';
  static const baseUrl = 'https://dummy.restapiexample.com/api/v1';
  final String employeesBoxName = 'employeesBox';


  List<Employee> get employees => [..._employees];
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get formError => _formError;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setFormError(String message) {
    _formError = message;
    notifyListeners();
  }

  Future<void> fetchEmployees() async {
    _setLoading(true);
    var box = Hive.box('employeesBox');

    List<Employee>? cachedEmployees = box.get('employees')?.cast<Employee>();
    DateTime? lastFetchTime = box.get('lastFetchTime');

    if (cachedEmployees != null &&
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime).inMinutes < 60) {
      _employees = cachedEmployees;
      _setLoading(false);
      notifyListeners();
    } else {
      try {
        final response = await http.get(Uri.parse('$baseUrl/employees'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            final List<dynamic> employeeData = data['data'];
            _employees = employeeData.map((json) => Employee.fromJson(json as Map<String, dynamic>)).toList();

            // Cache the fetched employees
            box.put('employees', _employees);
            box.put('lastFetchTime', DateTime.now());
            notifyListeners();
          } else {
            _setErrorMessage('Internal error. Please try again later.');
          }
        } else {
          _setErrorMessage('Internal error. Please try again later.');
        }
      } catch (_) {
        _setErrorMessage('Internal error. Please try again later.');
      }
      _setLoading(false);
    }
  }

  Future<bool> createEmployee(Employee employee) async {
    _setLoading(true);
    var box = Hive.box('employeesBox');

    List<Employee> employees = box.get('employees')?.cast<Employee>() ?? [];
    employees.add(employee);
    box.put('employees', employees);
    _setLoading(false);
    return true;
  }

  Future<bool> submitEmployeeForm(String name, String age, String salary) async {
    _setLoading(true);
    _setFormError('');

    if (name.isEmpty || age.isEmpty || salary.isEmpty) {
      _setFormError("All fields must be filled.");
      return false;
    }

    int parsedAge;
    int parsedSalary;
    try {
      parsedAge = int.parse(age);
      parsedSalary = int.parse(salary);
    } on FormatException {
      _setFormError("Age and salary must be numbers.");
      return false;
    }

    final newEmployee = Employee(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      age: parsedAge,
      salary: parsedSalary,
      profileImage: '',
    );

    return await createEmployee(newEmployee);
  }

  Future<bool> updateEmployee(Employee employee) async {
    _setLoading(true);
    var box = Hive.box('employeesBox');
    print("Hello");
    List<Employee> employees = box.get('employees')?.cast<Employee>() ?? [];
    int index = employees.indexWhere((emp) => emp.id == employee.id);
    if (index != -1) {
      employees[index] = employee;
      box.put('employees', employees);
      print("Saved to local");
      _setLoading(false);
      return true;
    } else {
      _setErrorMessage("Employee not found in the local cache.");
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteEmployee(int employeeId) async {
    _setLoading(true);
    var box = Hive.box('employeesBox');

    List<Employee> employees = box.get('employees')?.cast<Employee>() ?? [];
    int index = employees.indexWhere((emp) => emp.id == employeeId);
    if (index != -1) {
      employees.removeAt(index);
      box.put('employees', employees);
      _setLoading(false);
      return true;
    } else {
      _setErrorMessage("Employee not found in the local cache.");
      _setLoading(false);
      return false;
    }
  }

}
