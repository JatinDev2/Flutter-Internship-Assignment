import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/App%20Constants/appBar.dart';
import 'package:quantmhill_assignment/Providers/auth_provider.dart';
import 'package:quantmhill_assignment/Providers/profile_provider.dart';
import 'package:quantmhill_assignment/Screens/Employee%20Screens/show_employees.dart';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({super.key});

  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  Future<void> _handleAuthentication(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final profileProvider = Provider.of<FirestoreUserProvider>(context, listen: false);

    try {
      if (_isSignUp) {
        bool success = await authProvider.signUp(_emailController.text, _passwordController.text);
        if (success) {
          String? imageUrl;
          if (_profileImage != null) {
            imageUrl = await profileProvider.uploadProfilePicture(_profileImage!);
          }
          await profileProvider.createUserProfile(
            _usernameController.text,
            _emailController.text,
            imageUrl ?? '',
          );
        }
      } else {
        await authProvider.signIn(_emailController.text, _passwordController.text,context);
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (_){
        return const EmployeeDetailsPage();
      }));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      authProvider.setLoading(false);
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<FirebaseAuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: ColorsManager.lightBlue,
      appBar: CustomAppBar(title: _isSignUp ? 'Sign Up' : 'Sign In', backgroundColor: ColorsManager.warmGreen),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSignUp) ...[
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: ColorsManager.grey400,
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _usernameController,
                      'Username',
                      Icons.person,
                      'Enter your username',
                          (value) => value != null && value.isEmpty ? 'Username cannot be empty' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (!_isSignUp) ...[
                    Image.asset("assets/person.jpg",height: 200,width: 200,),
                    const SizedBox(height: 32),
                  ],
                  _buildTextField(
                    _emailController,
                    'Email',
                    Icons.email,
                    'Enter a valid email address',
                        (value) => value != null && !value.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _passwordController,
                    'Password',
                    Icons.lock,
                    'Enter your password',
                        (value) => value != null && value.length < 6 ? 'Password must be at least 6 characters long' : null,
                    isObscure: true,
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () => _handleAuthentication(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.warmGreen,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(_isSignUp ? 'Sign Up' : 'Sign In', style: const TextStyle(fontSize: 18)),
                  ),
                  if (!isLoading)
                    TextButton(
                      onPressed: _toggleSignUp,
                      child: Text(_isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      String hint,
      String? Function(String?) validator, {
        bool isObscure = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(22)
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: ColorsManager.textDark),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: ColorsManager.grey400.withOpacity(0.5), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: ColorsManager.warmGreen, width: 2.0),
          ),
        ),
        obscureText: isObscure,
        style: const TextStyle(fontSize: 16),
        validator: validator,
      ),
    );
  }

}
