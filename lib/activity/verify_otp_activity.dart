import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iApply/activity/login_activity.dart';
import 'package:iApply/models/resendOTP_model.dart';
import 'package:iApply/models/verifyOTP_model.dart';
import 'package:iApply/services/resendOTP_services.dart';
import 'package:iApply/services/verifyOTP_services.dart';

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
  void initState() {
    passOTP = verifyOTP_request(c_password: "", name: "", password: "", email: "", otp: "");
    otpResent = otpResendRequest(email: "");
    super.initState();
  }

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

  late final verifyOTP_request passOTP ;
  late final otpResendRequest otpResent;

  late  String messageResendOTP;

  bool isLoading = false;

  void otpResend()async{
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
try{
  otpResent.email = widget.email.trim();
  final otpResendServices otpResend = otpResendServices();
  final resendResponse =await otpResend.otp(otpResent);

  if(resendResponse.statusCode == 200){
    messageResendOTP = resendResponse.message ?? "otp has been sent to your email";
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor:Colors.green, content: Center(child: Text(messageResendOTP),))
    );
  }
  else{
    messageResendOTP = resendResponse.message ?? "Something went wrong.";
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text(messageResendOTP),))
    );
  }
}
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text(messageResendOTP),))
      );
    }
    finally{
  if(mounted)
    setState(() {
      isLoading = false;
    });
    }
  }

  void verifyOTP() async{

    setState(() {
      isLoading = true;
    });
  String finalOTP = controllers.map((c)=>c.text).join();
  try{

    passOTP.c_password = widget.cPassword.trim();
    passOTP.name = widget.name.trim();
    passOTP.otp = finalOTP.trim();
    passOTP.password = widget.password.trim();
    passOTP.email = widget.email.trim();

    final verifyOTP_services otpRecieved = verifyOTP_services();
    final response = await otpRecieved.otp_verification(passOTP);
    if(response.statusCode == 200 ){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                  child: Text("Verified.Your registration is successful. Please LOGIN to continue.",))
          ));
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login_activity()));

    }else if(response.statusCode == 400){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text("Expired or Invalid OTP."),))
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text("Registration failed.")))
      );
    }
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("Please enter valid OTP.")))
    );
  }
  finally{
    if(mounted)
    setState(() {
      isLoading = false;
    });
  }

}

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Stack(
      children: [
        Container(
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
                  Text("Enter a OTP sent to ${widget.email}",style: TextStyle(fontSize: 16),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, otpBoxes),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't get a code?"),
                      TextButton(onPressed:otpResend, child: Text("Resend OTP",style: TextStyle(color: Colors.green ,fontSize: 16),))

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
        if(isLoading)
          Container(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
    ],
    ),
  );
  }
}