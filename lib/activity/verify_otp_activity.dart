import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class verifyOTP_activity extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String cPassword;

  const verifyOTP_activity({super.key, required this.email, required this.name, required this.password, required this.cPassword});

  @override
  State<StatefulWidget> createState() {
    return verifyOTP_state();
  }
}

class verifyOTP_state extends State<verifyOTP_activity>{

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    focusNode.forEach((f)=> f.dispose());
    super.dispose();
  }

  final List<TextEditingController> controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNode = List.generate(5,(_) => FocusNode());


  Widget otpBoxes(int index){
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
      ),
      width: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNode[index],
        cursorColor: Colors.white,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold , color: Theme.of(context).canvasColor),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
        ),
        onChanged: (value){
          if(value.length == 1 && index < 4){
            focusNode[index+1].requestFocus();
          }else if(value.isEmpty && index > 0){
            focusNode[index-1].requestFocus();
          }
        },
      ),
    );
}
void verifyOTP(){
    String otp = controllers.map((c)=>c.text).join();
}

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("OTP Verification", style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 30, fontWeight: FontWeight.bold),),
                // SizedBox(
                //   height: 25,
                // ),
                Text("Enter a OTP sent to",style: TextStyle(fontSize: 16),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, otpBoxes),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't get a code?"),
                    TextButton(onPressed: (){}, child: Text("Resend OTP",style: TextStyle(color: Colors.green ,fontSize: 16),))
                    
                  ],
                ),
                ElevatedButton(
                    onPressed: verifyOTP,
                    child: Text("SUBMIT",style: TextStyle(color: Theme.of(context).canvasColor,fontSize: 16,fontWeight: FontWeight.w500),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}