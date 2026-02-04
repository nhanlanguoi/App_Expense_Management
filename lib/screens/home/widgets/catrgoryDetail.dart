import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:flutter/material.dart';

class categoryDetail extends StatefulWidget {
  const categoryDetail({super.key});

  @override
  State<categoryDetail> createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            width: MediaQuery.of(context).size.height,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xFF791FE1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)
              )
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                    children: [
                      custombutton(
                        backgroundColor:  Color(0xFF791FE1),
                        isOutline: true,
                        label: "",
                        height: 40,
                        width: 40,
                        borderRadius: 60,
                        icon: const Icon(Icons.arrow_back, color: Colors.white,
                          size: 25,),
                      ),

                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 30)  ,
                        child:Text("Chi tiết Ăn Uống",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BeVietnamPro'
                        ),
                      ) ,)



                    ]
                ),
              ]

            ),

          ),
        ],

      ),
    );
  }
}
