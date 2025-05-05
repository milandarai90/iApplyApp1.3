import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class verifyOTP_activity extends StatefulWidget {

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
      color: Theme.of(context).canvasColor,
      width: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNode[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(counterText: ""),
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
    ////////////////////////////////////////////////
}

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, otpBoxes),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: verifyOTP,
                  child: Text("SUBMIT",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w500),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).canvasColor,
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
  );
  }
}