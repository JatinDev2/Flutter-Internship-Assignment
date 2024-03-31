import 'package:get_storage/get_storage.dart';

class LoginData{
  final loginData = GetStorage('LoginData');

  //---------------------------------------------Read-------------------------------------------------------------

  String getUserName(){
    return loginData.read("userName") ?? "Unknown";
  }

  String getUserEmail(){
    return loginData.read("userEmail") ?? "Unknown";
  }

  String getUserId(){
    return loginData.read("userId") ?? "Unknown";
  }

  bool getIsLoggedIn(){
    return loginData.read<bool>("isLoggedIn") ?? false;
  }

  //---------------------------------------------Write-------------------------------------------------------------

  void writeUserName(String userName){
    loginData.write("userName",userName);
  }

  void writeIsLoggedIn(bool value){
    loginData.write("isLoggedIn", value);
  }

  void writeUserEmail(String userEmail){
    loginData.write("userEmail",userEmail);
  }

  void writeUserId(String userId){
    loginData.write("userId",userId);
  }



}