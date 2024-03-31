import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/App%20Constants/appBar.dart';
import 'package:quantmhill_assignment/Providers/employee_provider.dart';

class EmployeeCreatePage extends StatefulWidget {
  const EmployeeCreatePage({super.key});

  @override
  _EmployeeCreatePageState createState() => _EmployeeCreatePageState();
}

class _EmployeeCreatePageState extends State<EmployeeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _createEmployee(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    bool success = await employeeProvider.submitEmployeeForm(
      _nameController.text,
      _ageController.text,
      _salaryController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Employee added successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(employeeProvider.formError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Add New Employee',
        backgroundColor: ColorsManager.warmGreen,
        iconColor: ColorsManager.textLight,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_nameController, 'Name', 'Name cannot be empty', theme),
              const SizedBox(height: 16.0),
              _buildTextField(_ageController, 'Age', 'Age cannot be empty', theme, isNumber: true),
              const SizedBox(height: 16.0),
              _buildTextField(_salaryController, 'Salary', 'Salary cannot be empty', theme, isNumber: true),
              const SizedBox(height: 24.0),
              _buildCreateButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String errorText, ThemeData theme, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: ColorsManager.textDark, fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          errorStyle: const TextStyle(color: ColorsManager.errorRed),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: ColorsManager.warmGreen, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: ColorsManager.grey400, width: 1.0),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? errorText : null,
      ),
    );
  }

  Widget _buildCreateButton(ThemeData theme) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) => ElevatedButton(
        onPressed: provider.isLoading ? null : () => _createEmployee(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: ColorsManager.warmGreen,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 4,
        ),
        child: provider.isLoading
            ? CircularProgressIndicator(color: theme.primaryColor, strokeWidth: 3.0)
            : Text('Add Employee', style: theme.textTheme.button?.copyWith(color: Colors.white)),
      ),
    );
  }
}
