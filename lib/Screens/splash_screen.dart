import 'package:flutter/material.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/Local%20Memory/LoginData.dart';
import 'package:quantmhill_assignment/Screens/Authentication/signin_signup.dart';
import 'package:quantmhill_assignment/Screens/Home%20Screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override


  void initState() {
    // TODO: implement initState
    super.initState();
    bool isLoggedIn=LoginData().getIsLoggedIn();

    Future.delayed(const Duration(seconds:2)).then((value){
      if(isLoggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return  HomeScreen();
        }));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return const SignInSignUpPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.lightBlue,
      body: Image.asset("assets/indexImg.png",
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
