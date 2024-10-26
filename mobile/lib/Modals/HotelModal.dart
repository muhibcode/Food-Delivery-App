import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HotelModal extends StatefulWidget {
  @override
  _HotelModalState createState() => _HotelModalState();
}

class _HotelModalState extends State<HotelModal> {
  String msgHotel;

  // @override
  // void initState() {
  //   super.initState();
  //   // showmsg();
  // }

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // showmsg() {
  //   print(msgHotel);

  //   return msgHotel;
  // }

  @override
  Widget build(BuildContext context) {
    final routeRgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Container(
        color: Colors.white.withOpacity(0.5),
        child: AlertDialog(
          title: Text('Food Request!!'),
          // elevation: 20,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(routeRgs['msg']),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
