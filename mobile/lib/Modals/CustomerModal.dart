import 'package:flutter/material.dart';

class CustomerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withOpacity(0.5),
        child: AlertDialog(
          title: Text('Please wait....'),
          // elevation: 20,

          // backgroundColor: Colors.blueGrey,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                // Text('This is a demo alert dialog.'),
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
