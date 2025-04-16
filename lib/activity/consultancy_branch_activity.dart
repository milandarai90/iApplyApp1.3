import 'package:flutter/material.dart';

class consultancy_branch_activity extends StatefulWidget{
  late final String token;
  consultancy_branch_activity({super.key,required this.token});
  @override
  State<StatefulWidget> createState() {
    return consultancy_branch_state();
  }
}
class consultancy_branch_state extends State<consultancy_branch_activity>{
  @override
  Widget build(BuildContext context) {
  return Scaffold();
  }
}