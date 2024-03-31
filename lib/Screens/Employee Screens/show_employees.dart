import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/App%20Constants/appBar.dart';
import 'package:quantmhill_assignment/Models/employee_model.dart';
import '../../Providers/employee_provider.dart';
import 'edit_employee.dart';

class EmployeeDetailsPage extends StatelessWidget {
  const EmployeeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      if (!employeeProvider.isLoading) {
        employeeProvider.fetchEmployees();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Employee Details',
        backgroundColor: ColorsManager.warmGreen,
        iconColor: ColorsManager.textLight,
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (provider.errorMessage.isNotEmpty) {
            return RefreshIndicator(
              backgroundColor: ColorsManager.warmGreen,
              color: Colors.white,
              onRefresh: () async {
                await provider.fetchEmployees();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height-120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(provider.errorMessage),
                    ],
                  ),
                ),
              ),
            );

          }
          else {
            return RefreshIndicator(
              backgroundColor: ColorsManager.warmGreen,
              color: Colors.white,

              onRefresh: () async {
                await provider.fetchEmployees();
              },
              child: ListView.builder(
                itemCount: provider.employees.length,
                itemBuilder: (context, index) {
                  final employee = provider.employees[index];
                  return _buildEmployeeCard(context, employee);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    const avatarBackgroundColor = Color(0xFF81C784);
    const textColor = Color(0xFF334D5C);
    const actionTextColor = Color(0xFF35524A);

    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 5.0,
      shadowColor: const Color(0xFF9DBF9E).withOpacity(0.5),
      color: ColorsManager.warmBeige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: avatarBackgroundColor,
                      child: Text(employee.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Age: ${employee.age}', style: TextStyle(color: textColor.withOpacity(0.75))),
                          Text('Salary: \$${employee.salary}', style: TextStyle(color: textColor.withOpacity(0.75))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.edit, color: actionTextColor),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EmployeeEditPage(employee: employee))),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteEmployee(context, employee.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(BuildContext context, int employeeId) {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Employee', style: TextStyle(color: ColorsManager.textDark)),
          content: const Text('Are you sure you want to delete this employee?', style: TextStyle(color: ColorsManager.grey400)),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: ColorsManager.warmGreen)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: ColorsManager.red)),
              onPressed: () async {
                try {
                  await provider.deleteEmployee(employeeId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Employee deleted successfully.', style: TextStyle(color: Colors.white)),
                      backgroundColor: ColorsManager.warmGreen,
                    ),
                  );
                } catch (_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete employee. Please try again.', style: TextStyle(color: Colors.white)),
                      backgroundColor: ColorsManager.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
