
import 'package:flutter/material.dart';
import 'package:iapply3/activity/bottom_navbar_activity.dart';
import 'package:iapply3/activity/home_activity.dart';
import 'package:iapply3/activity/register_activity.dart';
import 'package:iapply3/models/login_model.dart';
import 'package:iapply3/services/login_services.dart';


class login_activity extends StatefulWidget{
  const login_activity({super.key});
  @override
  State<StatefulWidget> createState() {
    return loginactivity_state();
  }

}
class loginactivity_state extends State<login_activity>{

  late String auth_token;

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final form_key = GlobalKey<FormState>();
  final scaffold_key = GlobalKey<ScaffoldState>();
  bool hidden_password = true;
  late final login_request requestData ;


  @override
  void initState() {
    requestData = login_request(email: "", password: "");
    super.initState();
  }

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  bool isLoading = false;

  void _login()async{
    FocusScope.of(context).unfocus();
    if(form_key.currentState!.validate()){
      requestData.email = email_controller.text;
      requestData.password = password_controller.text;

      login_api_services login_services =login_api_services();
      setState(() {
        isLoading = true;
      });
      try{
        login_response responseFromServer = await login_services.login(requestData);
        // if(responseFromServer.token != null && responseFromServer.token.isNotEmpty){
        if(responseFromServer.token?.isNotEmpty == true){
          auth_token =responseFromServer.token!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text("login successful")),
              backgroundColor: Colors.green,),
          );
          await Future.delayed(Duration(seconds: 2));
          if(context.mounted){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => bottom_navbar_activity(token: auth_token,)),
            );
          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Center(child: Text("Login Failed. Incorrect Email or Password.")),
                  backgroundColor: Colors.red));
        }
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text("Something went wrong during login.")),
                backgroundColor: Colors.red));
      }
      finally{
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      }

    }

  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     resizeToAvoidBottomInset: true,
     key: scaffold_key,
     body: InkWell(
       onTap: () {
         FocusScope.of(context).unfocus();
       },
       child: Stack(
         children:[
           Container(
           height: MediaQuery.of(context).size.height,
           color: Theme.of(context).primaryColor,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Image.asset("assets/images/iapply_logo.png",scale: 1.2,),
               ),
               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Theme.of(context).canvasColor,
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child: Center(
                     child: Column(
                       children: [
                         SizedBox(
                           height: 20,
                         ),
                         Text("Login",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Form(
                             key: form_key,
                               child: Column(
                                 children: [
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
                                     validator: (input){
                                       if (input == null || input.isEmpty){
                                         return "Email is required.";
                                       }
                                       if(!input.contains("@") || !input.contains(".")){
                                         return("Enter a valid email.");
                                       }
                                       return null;
                                     },
                                     controller: email_controller,
                                                  ),
         
                                   SizedBox(
                                     height: 20,
                                   ),
                                   TextFormField(
                                     controller: password_controller,
                                     validator: (input){
                                       if(input == null || input.isEmpty){
                                         return "Password is required.";
                                       }
                                       if(input.length < 6){
                                         return "Password must contain atleast 8 character.";
                                       }
                                       return null;
                                     },
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
         
                                   Padding(
                                     padding: const EdgeInsets.all(5.0),
                                     child: TextButton(onPressed: (){}, child: Text("Forgot Password?")),
                                   ),
         
                                   SizedBox(
                                     width: 100,
                                       height: 40,
                                       child: ElevatedButton(onPressed: _login ,
                                           style: ElevatedButton.styleFrom(
                                             backgroundColor: Theme.of(context).primaryColor,
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(10),
                                             ),
                                           ),
                                           child: Text("LOGIN",style: TextStyle(fontSize: 16,color: Theme.of(context).canvasColor),))),
                                   Padding(
                                     padding: const EdgeInsets.all(5.0),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text("Don't have an account?"),
                                         TextButton(onPressed: (){
                                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>register_activity()));
                                         }, child: Text("Register Now",style: TextStyle(color: Colors.green),))
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
           if(isLoading)
             Container(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
               child:const Center(
                 child: CircularProgressIndicator(
                     valueColor:AlwaysStoppedAnimation<Color>(Colors.white)),
               ),
             )

     ],
       ),
     ),
   );
  }

}