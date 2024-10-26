import 'package:flutter/cupertino.dart';

class Wrapper extends StatefulWidget {
  final Widget widget;

  final bool accessible;

  Wrapper(this.widget, this.accessible);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();

    if (widget.accessible == false) {
      // Navigator.pop(context);

      Navigator.pushNamed(context, 'Login');
      //  Navigator.of(BuildContext context).pushNamed('Register');

    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}
