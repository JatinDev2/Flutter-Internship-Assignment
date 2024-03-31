import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/Models/employee_model.dart';
import 'package:quantmhill_assignment/Providers/employee_provider.dart';

class EmployeeEditPage extends StatelessWidget {
  final Employee employee;

  const EmployeeEditPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Employee",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: ColorsManager.warmGreen,
        elevation: 0,
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _EmployeeEditForm(employee: employee),
      ),
    );
  }
}

class _EmployeeEditForm extends StatefulWidget {
  final Employee employee;

  const _EmployeeEditForm({required this.employee});

  @override
  _EmployeeEditFormState createState() => _EmployeeEditFormState();
}

class _EmployeeEditFormState extends State<_EmployeeEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee.name;
    _ageController.text = widget.employee.age.toString();
    _salaryController.text = widget.employee.salary.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _updateEmployee(BuildContext context,EmployeeProvider employeeProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedEmployee = Employee(
      id: widget.employee.id,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      salary: int.parse(_salaryController.text),
      profileImage: widget.employee.profileImage,
    );

    bool success = await employeeProvider.updateEmployee(updatedEmployee);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(employeeProvider.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Age cannot be empty' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _salaryController,
            decoration: const InputDecoration(labelText: 'Salary'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Salary cannot be empty' : null,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: (){
              _updateEmployee(context,employeeProvider);
            },
            child: employeeProvider.isLoading? const CircularProgressIndicator() : const Text('Update'),
          ),
        ],
      ),
    );
  }
}

