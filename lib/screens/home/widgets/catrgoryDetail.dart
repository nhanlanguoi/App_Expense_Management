import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/components/cardshowvalue/CardShowTotalofCard.dart';
import 'package:expense_management/components/widget/purple_header.dart';
import 'package:expense_management/screens/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/screens/mainlayoutcontrol.dart';
import '../../../components/cardshowvalue/CardShowHistoryTrade.dart';

class categoryDetail extends StatefulWidget {
  const categoryDetail({super.key});

  @override
  State<categoryDetail> createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {



  @override
  Widget build(BuildContext context) {
    final cao  = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // header tím
          PurpleHeader(height: 250,),
          // content nằm trên header
          SafeArea(
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child:Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // nút back về trang chủ
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => {
                                Navigator.pop(context),
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          // title của trang
                          const Text(
                            "Chi tiết Ăn Uống",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'BeVietnamPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        child: Column(
                          children: [
                            SizedBox(height: 25),
                            Text("Tổng chi tháng này",
                              style:TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                            Text("2.450.000 "+ "₫",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(height: 40,),
                    Cardshowtotalofcard(
                      Background: Colors.white,
                    ),
                    SizedBox(height: 20,),

                    Row(
                      spacing: 20,
                      children: [
                        custombutton(
                          onPressed: (){
                            setState(() {
                              var backgroundColor = Colors.purple;
                            });
                          },
                          label: "Tất cả",
                          height: 30,
                          borderRadius: 30,
                          width: 100,
                          backgroundColor: Colors.purple[500],
                          textColor: Colors.white,
                        )
                      ],
                    ),
                    SizedBox(height: 20),


                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Cardshowhistorytrade(),
                            Cardshowhistorytrade(),
                            Cardshowhistorytrade()
                          ],
                        ),
                      ),
                    )
                  ],
                ),

              ),
          ),
        ],

      ),
    );
  }
}
