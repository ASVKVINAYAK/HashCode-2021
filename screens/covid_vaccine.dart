import 'dart:convert';

import 'package:covid19_tracker/model/covid_vaccine_by_pin.dart';
import 'package:covid19_tracker/screens/Indian.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class VaccinebyPin extends StatefulWidget {
  @override
  _VaccinebyPinState createState() => _VaccinebyPinState();
}
Future<List<Centers>> checkavailabilty1(String p)
async {
  String d = DateFormat("dd-MM-yyyy").format(DateTime.now());
  var url = Uri.parse('https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${p}&date=${d}');
  var response = await http.get(url);
  print("res ${response.body}");
  if (response.statusCode == 200) {
    var r=covidvaccinebypinFromJson(response.body);
    List<Centers> s=r.centers;
    print(r.toString());
    return s;
  } else {
    throw Exception('Unexpected error occured!');
  }
}
// Future<List<Session>> checkavailabilty2()
// async {
//   var url = Uri.parse('https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=721301&date=23-05-2021');
//   var response = await http.get(url);
//   print("res ${response.body}");
//   if (response.statusCode == 200) {
//     var r=covidvaccinebypinFromJson(response.body);
//     List<Centers> s=r.centers;
//     List<Session> st=
//     print(r.toString());
//     return s;
//   } else {
//     throw Exception('Unexpected error occured!');
//   }
// }
class _VaccinebyPinState extends State<VaccinebyPin> {
  List<Centers> cn;
  TextEditingController  pin = new TextEditingController();
  String pincode="";
  String t="";

  // void initState() {
  //   super.initState();
  //   checkavailabilty1().then((value) {
  //     cn =value;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Notified for Vaccine availability"),
        titleSpacing: 00.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
           onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        toolbarHeight: 60.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        elevation: 0.00,
        backgroundColor: Colors.greenAccent[400],
      ), //AppBar
      body:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              DialogButton(
                width: 100,
                 height: 80,
                 child: Text(
                   "Enter Pincode",
                   style: TextStyle(color: Colors.white, fontSize: 20),
                 ),
                 onPressed: (){
                   Alert(
                       context: context,
                       title: "Get notified for vaccine ",
                       content: Column(
                         children: <Widget>[
                           TextField(
                             controller: pin,
                             decoration: InputDecoration(
                               icon: Icon(Icons.location_city_sharp),
                               labelText: 'Enter Details',
                             ),
                           ),
                         ],
                       ),
                       buttons: [
                         DialogButton(
                           onPressed: ()
                           {
                             t=pincode;
                             pincode=pin.text;
                             setState(() {
                               checkavailabilty1(pincode).then((value) {
                                 cn = value;
                               });
                             });

                             Navigator.pop(context);
                           },
                           child: Text(
                             "OK",
                             style: TextStyle(color: Colors.white, fontSize: 20),
                           ),
                         )
                       ]).show();
                 },
                 color: Color.fromRGBO(0, 179, 134, 1.0),
                 radius: BorderRadius.circular(0.0),
               ),
              Expanded(
                    child: Center(
                      child: (cn==null &&t==pincode) ? Text("Enter PinCode"): ListView.builder(
                          itemCount: cn==null?0:cn.length,
                          itemBuilder: (BuildContext context, int index) {
                            Centers cdata=cn[index];
                            List<Session> s=cdata.sessions;
                            List<VaccineFee> v=cdata.vaccineFees;
                            int i=0;
                            Session sdata=s[i];
                            i<=s.length?++i:0;
                            return  Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ExpandableNotifier(// <-- Provides ExpandableController to its children
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          child: Expandable(// <-- Driven by ExpandableController from ExpandableNotifier
                                            collapsed: ExpandableButton(// <-- Expands when tapped on the cover photo
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('${cdata.name}'),
                                              ),
                                            ),
                                            expanded: Column(
                                                children: [
                                            Padding(
                                            padding: EdgeInsets.only(left: 6.0, right: 0.0, top: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  child: Row(
                                                      children: [
                                                        IconButton(
                                                              icon: Icon(Icons.coronavirus),
                                                              onPressed: (){},
                                                            ),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:[
                                                              Text(
                                                        'Vaccine ${sdata.vaccine}= ${sdata.availableCapacity}',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Montserrat',
                                                                      fontSize: 17.0,
                                                                      fontWeight: FontWeight.bold,
                                                                  )
                                                              ),
                                                              Text(
                                                                'Fee : ${cdata.feeType}',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Montserrat',
                                                                      fontSize: 17.0,
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.bold,
                                                                  ),
                                                              ),
                                                              Text(
                                                                  'Tag ${sdata.minAgeLimit}+',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Montserrat',
                                                                      fontSize: 17.0,
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.bold,
                                                                  )
                                                              ),
                                                            ]
                                                        )
                                                      ]
                                                  )
                                              ),
                                              ExpandableButton(
                                                child:Icon(Icons.keyboard_arrow_up),
                                              )
                                            ],
                                          )
                                    ),
                                                  // Text(' Fee Type ${cdata.feeType}'),
                                                  // Text('Vaccine Available: ${sdata.vaccine}= ${sdata.availableCapacity}'),
                                                  // Text('Tag ${sdata.minAgeLimit}+'),
                                                  // Text('Date;  ${sdata.date}'),
                                                  // ExpandableButton(       // <-- Collapses when tapped on
                                                  //   child: Text("Back"),
                                                  // ),
                                                ]
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 20,
                                          thickness: 5,
                                          indent: 20,
                                          endIndent: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                            //   ListTile(
                            //   title: Text('${cdata.name}'),
                            // );
                          }
                      ),
                    ),
              ),
            ],
          ),
      ), //Center
    );
  }
}
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF21BFBD),
//       body: ListView(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 15.0, left: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios),
//                   color: Colors.white,
//                   onPressed: () {},
//                 ),
//                 Container(
//                     width: 125.0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.filter_list),
//                           color: Colors.white,
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.menu),
//                           color: Colors.white,
//                           onPressed: () {},
//                         )
//                       ],
//                     ))
//               ],
//             ),
//           ),
//           SizedBox(height: 25.0),
//           Padding(
//             padding: EdgeInsets.only(left: 40.0),
//             child: Row(
//               children: <Widget>[
//                 Text('Get Notified',
//                     style: TextStyle(
//                         fontFamily: 'Montserrat',
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25.0)),
//                 SizedBox(width: 10.0),
//                 Text('For Vaccine Slots ',
//                     style: TextStyle(
//                         fontFamily: 'Montserrat',
//                         color: Colors.white,
//                         fontSize: 25.0))
//               ],
//             ),
//           ),
//           SizedBox(height: 40.0),
//           Container(
//             height: MediaQuery.of(context).size.height - 185.0,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
//             ),
//             child: ListView(
//               primary: false,
//               padding: EdgeInsets.only(left: 25.0, right: 20.0),
//               children: <Widget>[
//                 Padding(
//                     padding: EdgeInsets.only(top: 45.0),
//                     child: Container(
//                         height: MediaQuery.of(context).size.height - 300.0,
//                         child: ListView(children: [
//                           _buildFoodItem('assets/plate1.png', 'Salmon bowl', '\$24.00'),
//                           _buildFoodItem('assets/plate2.png', 'Spring bowl', '\$22.00'),
//                           _buildFoodItem('assets/plate6.png', 'Avocado bowl', '\$26.00'),
//                           _buildFoodItem('assets/plate5.png', 'Berry bowl', '\$24.00')
//                         ]))),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Container(
//                       height: 65.0,
//                       width: 60.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Colors.grey,
//                             style: BorderStyle.solid,
//                             width: 1.0),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Center(
//                         child: Icon(Icons.search, color: Colors.black),
//                       ),
//                     ),
//                     Container(
//                       height: 65.0,
//                       width: 60.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Colors.grey,
//                             style: BorderStyle.solid,
//                             width: 1.0),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Center(
//                         child: Icon(Icons.shopping_basket, color: Colors.black),
//                       ),
//                     ),
//                     Container(
//                       height: 65.0,
//                       width: 120.0,
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Colors.grey,
//                               style: BorderStyle.solid,
//                               width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                           color: Color(0xFF1C1428)),
//                       child: Center(
//                           child: Text('Checkout',
//                               style: TextStyle(
//                                   fontFamily: 'Montserrat',
//                                   color: Colors.white,
//                                   fontSize: 15.0))),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFoodItem(String imgPath, String foodName, String price) {
//     return Padding(
//         padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
//         child: InkWell(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => DetailsPage(heroTag: imgPath, foodName: foodName, foodPrice: price)
//               ));
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                     child: Row(
//                         children: [
//                           Hero(
//                               tag: imgPath,
//                               child: Image(
//                                   image: AssetImage(imgPath),
//                                   fit: BoxFit.cover,
//                                   height: 75.0,
//                                   width: 75.0
//                               )
//                           ),
//                           SizedBox(width: 10.0),
//                           Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children:[
//                                 Text(
//                                     foodName,
//                                     style: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         fontSize: 17.0,
//                                         fontWeight: FontWeight.bold
//                                     )
//                                 ),
//                                 Text(
//                                     price,
//                                     style: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         fontSize: 15.0,
//                                         color: Colors.grey
//                                     )
//                                 )
//                               ]
//                           )
//                         ]
//                     )
//                 ),
//                 IconButton(
//                     icon: Icon(Icons.add),
//                     color: Colors.black,
//                     onPressed: () {}
//                 )
//               ],
//             )
//         ));
//   }
// }
