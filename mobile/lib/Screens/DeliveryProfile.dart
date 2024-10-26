import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../Widgets/FoodItem.dart';
import '../Provider/auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';
import '../main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DeliveryProfile extends StatefulWidget {
  // final Auth auth;

  // DeliveryProfile(this.auth);
  @override
  _DeliveryProfileState createState() => _DeliveryProfileState();
}

class _DeliveryProfileState extends State<DeliveryProfile> {
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
      Provider.of<FoodProvider>(context).acceptDeliveryOrders();
      // Provider.of<FoodProvider>(context).processOrders();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  accept(i) {
    Provider.of<FoodProvider>(context, listen: false).acceptDeliveryReq(i);

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

  // if (accepted) {
  //   return Text('req accepted');
  // }
  // }

  startProcessing(i) {
    // if (formKey.currentState.validate()) {
    //   formKey.currentState.save();
    // }

    Timer(Duration(seconds: 2), () {
      Provider.of<FoodProvider>(context, listen: false).processHotelReq(i);

      showAcceptPage = false;
      showProcessingPage = true;
      orderAccept = false;
    });
  }

  acceptPage(List<dynamic> args) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: args
            .asMap()
            .map((i, n) => MapEntry(
                i,
                Container(
                    padding: EdgeInsets.only(bottom: 5, left: 5),
                    child: Column(children: <Widget>[
                      Text('Customer Name: ${n['customerName']}'),
                      Text('DropOff Location: ${n['dropOffAddress']}'),
                      Column(
                        children: n['foodInfo']
                            .map<Widget>((m) => Column(children: <Widget>[
                                  Text(m['foodName']),
                                ]))
                            .toList(),
                      ),
                      Row(
                        children: [
                          orderAccept
                              ? timeField(i)
                              : RaisedButton(
                                  onPressed: () => accept(i),
                                  child: Text('Accept'),
                                ),
                          // RaisedButton(
                          //     onPressed: () => rejectReq(i),
                          //     child: Text('Reject')),
                        ],
                      ),
                    ]))))
            .values
            .toList(),
      ),
    ));
  }

  processPage(List<dynamic> args) {
    print('args are $args');

    return Expanded(
        child: SingleChildScrollView(
      child: Column(
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
                      accepted ? Text('req accepted') : null
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
    ));
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
    final orderItems = data.deliveryFood;
    // final processItems = data.processedItems;
    // final foodData = Provider.of<FoodProvider>(context);
    // final foods = foodData.hotelItems;

    return Scaffold(
      appBar: AppBar(title: Text('Delivery Profile')),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RaisedButton(
                      onPressed: onTapAccept,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text('ACCEPTED'),
                      color: buttonColAccept,
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RaisedButton(
                      onPressed: onTapProcess,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text('PROCESSING'),
                      color: buttonColProcess,
                    ),
                  )
                ],
              ),
            ],
          ),
          showAcceptPage
              ? acceptPage(orderItems)
              // : showProcessingPage
              //     ? processPage(processItems)
              //     : showDispatchPage
              //         ? dispatchPage()
              : null
        ],
      ),
    );
  }
}
