
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iapply3/activity/login_activity.dart';
import 'package:iapply3/activity/verify_otp_activity.dart';
import 'package:iapply3/models/register_model.dart';
import 'package:iapply3/services/register_services.dart';

class register_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return register_activity_state();
  }

}
class register_activity_state extends State<register_activity>{
  bool hidden_password = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();

  final form_key = GlobalKey<FormState>();
  final scaffold_key = GlobalKey<ScaffoldState>();

  late final register_request passRegisterData;

  @override
  void initState() {
    passRegisterData = register_request(name: "", email: "", password: "", c_password: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *0.85,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset("assets/images/iapply_logo.png",scale: 1.2,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).canvasColor,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Register",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Form(
                                    key: form_key,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.person),
                                                prefixIconColor: Theme.of(context).primaryColor,
                                                hintText: "Enter your name.",
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor
                                                    )
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                        width: 2
                                                    )
                                                )
                                            ),
                                            controller: nameController,
                                            validator: (input){
                                              if (input == null || input.isEmpty){
                                                return "Full name is required.";
                                              }
                                              if(input.length < 4){
                                                return("Enter a valid name.");
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          TextFormField(
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.email_outlined),
                                                prefixIconColor: Theme.of(context).primaryColor,
                                                hintText: "Enter your email.",
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor
                                                    )
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                        width: 2
                                                    )
                                                )
                                            ),
                                            controller: emailController,
                                            validator: (input){
                                              if (input == null || input.isEmpty){
                                                return "Email is required.";
                                              }
                                              if(!input.contains("@") || !input.contains(".")){
                                                return("Enter a valid email.");
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          TextFormField(
                                            validator: (input){
                                              if(input == null || input.isEmpty){
                                                return "Password is required.";
                                              }
                                              if(input.length < 8){
                                                return "Password must contain atleast 8 character.";
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            obscureText: hidden_password,
                                            decoration: InputDecoration(
                                                hintText: "Enter your password.",
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                ),
                                                suffixIcon: IconButton(onPressed:()
                                                {
                                                  setState(() {
                                                    hidden_password = !hidden_password;
                                                  });
                                                }
                                                  ,  icon: Icon(hidden_password ? Icons.visibility_off_outlined : Icons.visibility_outlined),),
                                                suffixIconColor: Theme.of(context).primaryColor,
                                                prefixIcon: Icon(Icons.lock_outline),
                                                prefixIconColor: Theme.of(context).primaryColor,
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context).primaryColor,
                                                    )
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context).primaryColor,
                                                      width: 2,
                                                    )
                                                )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          TextFormField(
                                            validator: (input){
                                              if(input == null || input.isEmpty){
                                                return "Confirm password is required.";
                                              }
                                              if(input != passwordController.text){
                                                return "Confirm Password must be same as Password.";
                                              }
                                              return null;
                                            },
                                            controller: cPasswordController,
                                            obscureText: hidden_password,
                                            decoration: InputDecoration(
                                                hintText: "Confirm your password.",
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                ),
                                                suffixIcon: IconButton(onPressed:()
                                                {
                                                  setState(() {
                                                    hidden_password = !hidden_password;
                                                  });
                                                }
                                                  ,  icon: Icon(hidden_password ? Icons.visibility_off_outlined : Icons.visibility_outlined),),
                                                suffixIconColor: Theme.of(context).primaryColor,
                                                prefixIcon: Icon(Icons.lock_person_outlined),
                                                prefixIconColor: Theme.of(context).primaryColor,
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context).primaryColor,
                                                    )
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context).primaryColor,
                                                      width: 2,
                                                    )
                                                )
                                            ),
                                          ),
                                          SizedBox(
                                         height: 25,
                                       ),

                                          SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: ElevatedButton(onPressed: ()async{
                                                if(form_key.currentState!.validate()){
                                                  passRegisterData.email  = emailController.text.trim();
                                                  passRegisterData.password = passwordController.text.trim();
                                                  passRegisterData.name = nameController.text.trim();
                                                  passRegisterData.c_password = cPasswordController.text.trim();

                                                  final registering = register_services();
                                                  final response =await registering.register_user(passRegisterData);
                                                  if(response.statusCode == 200 ){
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: Colors.green,
                                                          content: Center(child: Text("OTP has been sent to your email."),))
                                                    );
                                                   // await Future.delayed(Duration(seconds: 2));
                                                    if(context.mounted){
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>verifyOTP_activity()));
                                                    }
                                                  }else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: Colors.red,
                                                          content: Center(child: Text("Registration failed.")))
                                                    );
                                                  }

                                                }
                                              },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: Text("Register",style: TextStyle(fontSize: 16,color: Theme.of(context).canvasColor),))),

                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Already have an account?"),
                                                TextButton(onPressed: (){
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login_activity()));
                                                }, child: Text("Login",style: TextStyle(color: Colors.green),))
                                              ],
                                            ),
                                          )
                                        ],

                                      )
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}