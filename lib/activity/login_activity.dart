
import 'package:flutter/material.dart';

class login_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return loginactivity_state();
  }

}
class loginactivity_state extends State<login_activity>{

  bool hidden_password = true;
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: InkWell(
       onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
       child: Container(
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
                 color: Theme.of(context).canvasColor,
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
                             child: Column(
                               children: [
                                 TextFormField(
                                   decoration: InputDecoration(
                                     prefixIcon: Icon(Icons.email_outlined),
                                       prefixIconColor: Theme.of(context).primaryColor,
                                       hintText: "Enter your email.",
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
                                                ),
                                 SizedBox(
                                   height: 20,
                                 ),
                                 TextFormField(
                                   obscureText: hidden_password,
                                   decoration: InputDecoration(
                                     hintText: "Enter your password.",
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
                                     child: ElevatedButton(onPressed: (){},
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: Theme.of(context).primaryColor,
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(10),
                                           ),
                                         ),
                                         child: Text("LOGIN",style: TextStyle(fontSize: 16,color: Theme.of(context).canvasColor),)))
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
   );
  }

}