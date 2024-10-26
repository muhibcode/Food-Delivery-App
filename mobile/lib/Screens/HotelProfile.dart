import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../Widgets/FoodItem.dart';
import '../Provider/auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';
import '../main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HotelProfile extends StatefulWidget {
  // final Auth auth;

  // HotelProfile(this.auth);
  @override
  _HotelProfileState createState() => _HotelProfileState();
}

class _HotelProfileState extends State<HotelProfile> {
  LocalStorage storage = new LocalStorage('food_app');

  bool _isInit = true;
  bool accepted = false;
  Color buttonColAccept = Colors.yellow[900];
  Color buttonColProcess = Colors.yellow[700];
  Color buttonColDispatch = Colors.yellow[700];
  bool orderAccept = false;

  bool showAcceptPage = true;
  bool showProcessingPage = false;
  bool showDispatchPage = false;
  String time = '';

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  final formKey = GlobalKey<FormState>();

  List<dynamic> items = [];

  // @override
  // void initState() {
  //   reset();
  //   super.initState();
  // }

  reset() {
    Phoenix.rebirth(context);
    // RestartWidget.restartApp(context);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FoodProvider>(context).acceptOrders();
      Provider.of<FoodProvider>(context).processOrders();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  deliveryField() async {
    final hotel = await storage.getItem('hotel');
    socket.on('reqAcceptD${hotel['_id']}', (data) {
      // setState(() {
      //   accepted = data['accepted'];
      // });
      print(data);
    });
  }

  accept(i) {
    Provider.of<FoodProvider>(context, listen: false).acceptReq(i);

    setState(() {
      orderAccept = true;
    });
  }

  rejectReq(i) {
    socket.emit('reqReject', {
      'customerID': items[i]['customerID'],
      'data': 'Sorry your desired food is finished'
    });
  }

  onTapAccept() {
    setState(() {
      showAcceptPage = true;
      showDispatchPage = false;
      showProcessingPage = false;
      buttonColAccept = Colors.yellow[900];
      buttonColProcess = Colors.yellow[700];
      buttonColDispatch = Colors.yellow[700];
    });
  }

  onTapProcess() {
    setState(() {
      showAcceptPage = false;
      showProcessingPage = true;
      showDispatchPage = false;

      buttonColProcess = Colors.yellow[900];
      buttonColAccept = Colors.yellow[700];
      buttonColDispatch = Colors.yellow[700];
    });
  }

  onTapDispatch() {
    setState(() {
      showAcceptPage = false;
      showDispatchPage = true;
      showProcessingPage = false;
      buttonColDispatch = Colors.yellow[900];
      buttonColAccept = Colors.yellow[700];
      buttonColProcess = Colors.yellow[700];
    });
  }

  Widget timeField(j) {
    return Expanded(
        child: Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'Preparation Time',
              hintText: 'Enter Preparation time'),
          onSaved: (value) {
            time = value;
          },
        ),
        // Container(
        // width: MediaQuery.of(context).size.width * 0.333,
        RaisedButton(
          onPressed: () {
            startProcessing(j);
          },
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text('Start Processing'),
          // color: buttonColAccept,
        ),
      ],
    ));
  }

  // deliveryField() {
  //   final hotel = storage.getItem('hotel');
  //   socket.on('reqAcceptD${hotel['_id']}', (data) {
  //     // setState(() {
  //     //   accepted = data['accepted'];
  //     // });
  //     print(data);
  //   });
  //   // if (accepted) {
  //   //   return Text('req accepted');
  //   // }
  // }

  startProcessing(i) {
    // if (formKey.currentState.validate()) {
    //   formKey.currentState.save();
    // }
    formKey.currentState.save();

    Timer(Duration(seconds: 2), () {
      Provider.of<FoodProvider>(context, listen: false).processHotelReq(i);

      showAcceptPage = false;
      showProcessingPage = true;
      orderAccept = false;
    });
  }

  Widget acceptPage(List<dynamic> args) {
    print('length is ${args.length}');
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        // return Text('${args[index]['foodInfo'].map((m) => m['foodName'])}');
        return Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Customer Name: ${args[index]['customerName']}'),
              ),
              Column(
                children: args[index]['foodInfo']
                    .map<Widget>((n) => SizedBox(
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(n['foodQuantity']),
                              SizedBox(
                                width: 8,
                              ),
                              Text(n['foodName']),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
          height: 1.0,
        );
      },
      itemCount: args.length,
    );
  }

  Widget proces(List<dynamic> args) {
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // return Text('${args[index]['foodInfo'].map((m) => m['foodName'])}');
          return Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer Name: ${args[index]['customerName']}'),
                Column(
                  children: args[index]['foodInfo']
                      .map<Widget>((n) => SizedBox(
                            height: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(n['foodQuantity']),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(n['foodName']),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
            height: 1.0,
          );
        },
        itemCount: args.length,
      ),
    );
  }

  Widget processPage(List<dynamic> args) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Text('accepted page'),
          Column(
            children: args
                .asMap()
                .map((i, n) => MapEntry(
                    i,
                    Container(
                        padding: EdgeInsets.only(bottom: 5, left: 5),
                        child: Column(children: <Widget>[
                          Text('Customer Name: ${n['customerName']}'),
                          Column(
                            children: n['foodInfo']
                                .map<Widget>((m) => Column(children: <Widget>[
                                      Text(m['foodName']),
                                    ]))
                                .toList(),
                          ),
                          accepted ? Text('req accepted') : Text(''),
                          // RaisedButton(
                          //   onPressed: () => startProcessing(i),
                          //   child: Text('Start Processing'),
                          // )
                          // Row(
                          //   children: [
                          //     orderAccept
                          //         ? timeField(i)
                          //         : RaisedButton(
                          //             onPressed: () => accept(i),
                          //             child: Text('Accept'),
                          //           ),
                          //     RaisedButton(
                          //         onPressed: () => rejectReq(i),
                          //         child: Text('Reject')),
                          //   ],
                          // ),
                        ]))))
                .values
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget dispatchPage() {
    return Center(
      heightFactor: 30,
      child: Text('Dispatch Screen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FoodProvider>(context);
    final orderItems = data.items;
    final processItems = data.processedItems;
    // final foodData = Provider.of<FoodProvider>(context);
    // final foods = foodData.hotelItems;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hotel Profile'),
          bottom: TabBar(
            indicatorColor: Colors.yellow[800],
            indicatorWeight: 3.5,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(
                  child: Text(
                'Accepted',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
              Tab(
                  child: Text(
                'Processing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
              Tab(
                  child: Text(
                'Dispatched',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
              // Tab(text: 'Processing'),
              // Tab(text: 'Dispatched')
            ],
          ),
        ),
        drawer: Drawer(
          child: ListTile(
            title: Text('Manage Food'),
            onTap: () => Navigator.pushNamed(context, 'HotelFoodForm'),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            acceptPage(orderItems),
            processPage(processItems),
            dispatchPage()
          ],
        ),
        // body: Column(
        //   children: <Widget>[
        //     Row(
        //       children: <Widget>[
        //         Column(
        //           children: <Widget>[
        //             Container(
        //               width: MediaQuery.of(context).size.width * 0.333,
        //               child: RaisedButton(
        //                 onPressed: onTapAccept,
        //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //                 child: Text('ACCEPTED'),
        //                 color: buttonColAccept,
        //               ),
        //             )
        //           ],
        //         ),
        //         Column(
        //           children: <Widget>[
        //             Container(
        //               width: MediaQuery.of(context).size.width * 0.333,
        //               child: RaisedButton(
        //                 onPressed: onTapProcess,
        //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //                 child: Text('PROCESSING'),
        //                 color: buttonColProcess,
        //               ),
        //             )
        //           ],
        //         ),
        //         Column(
        //           children: <Widget>[
        //             Container(
        //               width: MediaQuery.of(context).size.width * 0.333,
        //               child: RaisedButton(
        //                 onPressed: onTapDispatch,
        //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //                 child: Text('DISPATCHED'),
        //                 color: buttonColDispatch,
        //               ),
        //             )
        //           ],
        //         )
        //       ],
        //     ),
        //     showAcceptPage
        //         ? acceptPage(orderItems)
        //         : showProcessingPage
        //             ? processPage(processItems)
        //             : showDispatchPage
        //                 ? dispatchPage()
        //                 : null
        //   ],
        // ),
      ),
    );
  }
}
